data = importdata('signal.txt');
serialportlist("available")
port = serialport("COM10", 9600);
configureTerminator(port, "LF");
flush(port);
fopen(port);
fscanf(port)
data = data.data(:,6);
t = 1:length(data);
acquired_data = [];
x = [];
rms_signal = [];
for i = t
    x(end+1) = data(i);
    pause(2/1000);
    if length(x) == 100
        x = highpass(x, 20, 100);
        x = lowpass(x, 150, 100);
        value = rms(x);
        rms_signal(end+1) = value;
        if value>0.07
            disp(value)
            write(port, "U", "char");
            
        else 
            write(port, "S", "char");
            
        end
        x = [];
    end
end
fclose(port);
clear port
th = triangleThreshold(rms_signal, 24);
action = (rms_signal>th).*max(rms_signal);
t_1 = 1:length(rms_signal);
plot(t,data)
figure
plot(t_1, rms_signal, t_1, action)