% *HANDYBOT* 
%
%     Developers: Carolina Albuquerque, David Machado, José Almeida
%     Medical Bionics and Robotics Course, FEUP 2023
%
%     This code allows to control the SUNFOUNDER Robot Arm using muscular
%     activity from the user.
%     The robot is to be connected via serial port, while the EMG data is
%     obtained from OpenSignals via TCP/IP port. At least one Bitalino
%     board should be connected to OpenSignals in order to run this program


clear all; clc; close all;
warning('off', 'all');

%% CONNECTION TO OPENSIGNALS TCP/IP PROTOCOL

ip_address = 'localhost'; % IP address of the computer running OpenSignals
port_number = 5555; % Port number configured in OpenSignals
s = tcpclient(ip_address, port_number);
num_bytes = 9999;
fopen(s);
write(s, 'start'); % Signals OpenSignals that MatLab is ready to recieve data

%% CONNECTION TO ROBOT ARM

serialportlist("available")
port = serialport("COM10", 9600); % Change to the correct COM Port
configureTerminator(port, "LF");
flush(port);
fopen(port);
fscanf(port);

%% ACQUISITON PARAMETERS AND VARIABLES

samp_freq = 100;
th = 0.04;
buffer_size = 1024;
used_channels = [];

first_json = true;
k=0;
cont = true;
points = 0;
current_state = 0;

servo_state = [0 0];
json_data = '';
emg_data = [0 0];
time = [0 0];
rms_signal = [0 0];
time_rms = [0 0];

%% PLOTS CONFIGURATION

plotTitle = 'EMG Signal';
xLabel = 'Time (s)';
yLabel = 'Voltage (mV)';
legend1 = 'EMG Raw';
legend2 = 'RMS Signal';
legend3 = 'Servo State';

figure
subplot(2,1,1);
rawEMGPlot = plot(time, emg_data, '-b');
legend(legend1);

subplot(2,1,2);
rmsEMGPlot = plot(time_rms, rms_signal, '-r');
hold on;
%servoStatePlot = plot(time_rms, servo_state, '-g');
%legend(legend2);

title(plotTitle, 'FontSize', 10);
xlabel(xLabel, 'FontSize',10);
ylabel(yLabel, 'FontSize', 10);

%% MAIN LOOP

tic
while cont
    chunk = read(s, buffer_size, 'uint8');
    new_char = char(chunk);
    json_data = append(json_data,new_char);

    if contains(json_data, '}}') && ~first_json
        substrings = split(json_data, '}}');
        for t=1:length(substrings)-1
            json_str = substrings(t);
            json_str = append(json_str{1},'}}');

            json_file = jsondecode(json_str);
            
            current_size = length(emg_data(1,:));
            channel = 1;
            for i = 1:length(available_devices)
                for k = used_channels(i)-1:0
                     new_data = json_file.returnData.(available_devices{i})(:, end-k);
                     emg_data(channel, current_size+1:current_size+length(new_data)) = new_data;
                     channel = channel + 1;
                end 
            end
        end
        json_data = substrings(end);
        json_data = json_data{1};
    
        time = linspace(0,toc,length(emg_data));
        %set(rawEMGPlot, 'XData', time, 'Ydata', emg_data);
    end

    if contains(json_data, '}}}')
        substrings = split(json_data, '}}}');
        json_str = substrings(1);
        json_str = append(json_str{1},'}}}');
        json_data = substrings(2);
        json_data = json_data{1};
    
        json_file = jsondecode(json_str);
        available_devices = fieldnames(json_file.returnData);
        
        for i=1:length(available_devices)
            num_channels = length(json_file.returnData.(available_devices{1}).channels);
            used_channels(i) = num_channels;
        end

        emg_data = zeros(sum(used_channels), 2);
        first_json = false;
    end
    
    new_k = floor(length(emg_data(1,:))/samp_freq);
    if new_k > k
        k = new_k;
        x = emg_data(1, end-samp_freq:end);
        %x = highpass(x, 1, 100);
        value = rms(x);
        rms_signal(end+1) = value;
        th = triangleThreshold(rms_signal, 24);
        if value>th
            if current_state ~= 1
                 write(port, "U", "char");
                 disp('U')
                 current_state = 1;
            end
           
        else
            if current_state ~= 0
                 write(port, "S", "char");
                 disp('S')
                 current_state = 0;
            end
        end
        servo_state(end+1) = current_state;
        time_rms = linspace(0,toc,length(rms_signal));
        %set(rmsEMGPlot, 'XData', time_rms, 'Ydata', rms_signal);
        %set(servoStatePlot, 'XData', time_rms, 'Ydata', servo_state);
    end
end

%% END PROGRAM

clear port
clear s