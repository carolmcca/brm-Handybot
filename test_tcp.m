ip_address = 'localhost'; % replace with the IP address of the computer running OpenSignals
port_number = 5555; % replace with the port number configured in OpenSignals
s = tcpclient(ip_address, port_number); % create a TCP/IP object
num_bytes = 9999;
%set(s, 'ByteOrder', 'little-endian');
%set(s, 'InputBufferSize', num_bytes); % set the input buffer size to match the expected data size
fopen(s); % open the connection
write(s, 'start');
cont = true;
v = [];
buffer_size = 1;
json_data = '';
first_json = true;
pause(10)
tic
while cont
    chunk = read(s, buffer_size, 'uint8');
    new_char = char(chunk);
    json_data = append(json_data,new_char);
    if contains(json_data, '}}') && ~first_json
        json_file = jsondecode(json_data);
        disp(json_file)
        json_data = '';
    end
    if contains(json_data, '}}}')
        json_file = jsondecode(json_data);
        disp(json_file)
        json_data = '';
        first_json = false;
    end
end
% while cont
%     data = read(s);
%     disp(data);
%     jsonObj = jsondecode(char(data));
%     plot(data);
%     drawnow
%     pause(3);
%     if toc > 20
%         cont = false;
%     end
% end