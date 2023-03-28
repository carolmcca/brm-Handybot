% Define the serial port
port = serialport("COM3", 9600);

% Open the serial port
configureTerminator(port, "LF");
flush(port);
fopen(port);

% Send the message "up" to the serial port
message = "u\n"; 
write(port, message, "char");
pause(1)
write(port, "s\n", "char");
% Close the serial port
fclose(port);
