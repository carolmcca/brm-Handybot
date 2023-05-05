% Read the JSON file
json_str = fileread('test_json.json');

% Decode the JSON string
data = jsondecode(json_str);

% Display the contents of the JSON file
disp(data.returnData.x98_D3_51_FD_71_08(:, 7));
