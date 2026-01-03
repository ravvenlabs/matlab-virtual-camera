% Dr. Kaputa
% Virtual Camera Demo
% must run helloWorld.py first on the FPGA SoC
% make sure to modify the IP address below accordingly

%Initialization Parameters
server_ip   = '192.168.1.51';     % IP address of the server
server_port = 9999;               % Server Port of the sever

client = tcpclient(server_ip,server_port);
fprintf(1,"Connected to server\n");
 
write(client,uint8(5));
flush(client);
result = read(client,1);
disp(result)