data = importdata('signal.txt');

data = data.data(:,6);
t = 1:length(data);
plot(data)
% acquired_data = [];
% x = [];
% for i = t
%     x(end+1) = data(i);
%     pause(1/100);
%     if length(x) == 100
%         x = highpass(x, 20, 100);
%         x = lowpass(x, 150, 100);
%         value = rms(x);
%         plot(x)
%         x = [];
%     end
% end

%plot(x)