clc; clear;
%myInstr = instrhwinfo('Bluetooth');
fs = 100;
b = Bitalino('btspp://98D351FD7108',100);
b.startBackground

disp("Begin")
pause(40);
% The following shows which columns correlate to each channel.
% 1             2   3   4   5   6   7   8   9   10  11
% packetNumber  I0  I1  I2  I3  A0  A1  A2  A3  A4  A5
data = b.read;
EMG_raw = data(:,7);

%lowpass(EMG_raw,50,fs)

b.stopBackground;
delete(b)
figure;
plot(EMG_raw);