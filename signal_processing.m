data = importdata('signal.txt');

data = data.data(:,6);
t = 1:length(data);
acquired_data = [];
x = [];
rms_signal = [];
for i = t
    x(end+1) = data(i);
    %pause(1/100);
    if length(x) == 100
        x = highpass(x, 20, 100);
        x = lowpass(x, 150, 100);
        value = rms(x);
        rms_signal(end+1) = value;
        x = [];
    end
end
th = triangleThreshold(rms_signal, 24);
action = (rms_signal>th).*max(rms_signal);
t_1 = 1:length(rms_signal);
plot(t,data)
figure
plot(t_1, rms_signal, t_1, action)