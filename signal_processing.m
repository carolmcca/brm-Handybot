data = importdata('signal.txt');

data = data.data(:,6);
t = 1:length(data);
acquired_data = [];
x = [];
action = [];
for i = t
    x(end+1) = data(i);
    %pause(1/100);
    if length(x) == 100
        x = highpass(x, 20, 100);
        x = lowpass(x, 150, 100);
        value = rms(x);
        action(end+1) = value;
        %plot(x)
        x = [];
    end
end

t_1 = 1:length(action);
plot(t,data)
figure
plot(t_1, action)