ip_address = 'localhost'; % replace with the IP address of the computer running OpenSignals
port_number = 5555; % replace with the port number configured in OpenSignals
s = tcpclient(ip_address, port_number); % create a TCP/IP object
num_bytes = 8;
set(s, 'InputBufferSize', num_bytes); % set the input buffer size to match the expected data size
fopen(s); % open the connection

tic
cont = true;
while cont
    data = fread(s,2,'float');
    plot(data);
    drawnow
    pause(3);
    if toc > 20
        cont = false;
    end
end