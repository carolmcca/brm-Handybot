warning('off', 'all');
data = importdata('signal.txt');
serialportlist("available")
port = serialport("COM6", 9600);
configureTerminator(port, "LF");
flush(port);
fopen(port);
fscanf(port)
data = data.data(:,6);
t = 1:length(data);
acquired_data = [];
x = [];
rms_signal = [];
th = 0.04;
led_mode = [];
for i = t
    x(end+1) = data(i);
    pause(2/1000);
    if length(x) == 100
        x = highpass(x, 20, 100);
        x = lowpass(x, 150, 100);
        value = rms(x);
        rms_signal(end+1) = value;
        new_th = triangleThreshold(rms_signal, 24);
        if new_th > th
            fprintf('New threshold selected: %d\n', new_th);
            th = new_th;
        end
        if value>th
            fprintf('Above threshold value found: %d\n', value);
            led_mode(end+1) = 1;
            write(port, "U", "char");         
        else 
            write(port, "S", "char");
            led_mode(end+1) = 0;
        end
        x = [];
    end
end
fclose(port);
clear port
th = triangleThreshold(rms_signal, 24);
action = (rms_signal>th).*max(rms_signal);
led_mode = led_mode.*max(rms_signal);
t_1 = 1:length(rms_signal);
plot(t,data)
figure
plot(t_1, rms_signal, t_1, action, t_1, led_mode)