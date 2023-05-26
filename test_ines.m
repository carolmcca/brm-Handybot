data = importdata('signal.txt');


data = data.data(:,6);
t = linspace(0,length(data)/100,length(data));

thenvelopewindow=50;
[signal,~] = envelope(data, thenvelopewindow, 'rms');


th = triangleThreshold(signal, 24);

figure
subplot(2,1,1)
plot(t,data)
title('EMG data from OpenSignals')
movement = (signal>th)*max(signal);
subplot(2,1,2)
plot(t,signal)
hold on
plot(t,movement)
title('RMS of EMG Signal')