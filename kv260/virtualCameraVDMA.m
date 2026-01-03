% Dr. Kaputa
% Virtual Camera Demo
% must run matlabStereoServerVDMA.py first on the FPGA SoC

width = 752;
height = 480;

%Initialization Parameters
server_ip   = '192.168.1.51';     % IP address of the server
server_port = 9999;                % Server Port of the sever

client = tcpclient(server_ip,server_port);
fprintf(1,"Connected to server\n");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% send raw frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
for x = 1:100
write(client,'0');
flush(client);
data = imread('sailboat.jpg');
data = uint8(data);

% mark the image number on the image
data = insertText(data,[100 100],x);

dataGray = im2gray(data);
imageStack = uint8(ones(height,width,8));
imageStack(:,:,1:3) = data;
imageStack(:,:,5:7) = data;
imageStack(:,:,4) = dataGray;
imageStack(:,:,8) = dataGray;
imageStack = permute(imageStack,[3 2 1]);
write(client,imageStack(:));
disp("hello")
temp = read(client,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% receive processed frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
if x < 10
    % receive feedthrough frame
    write(client,'1');
    flush(client);
else
    % receive processed frame
    write(client,'2');
    flush(client); 
end

dataLeft = read(client,width*height);   
temp = reshape(dataLeft,[width,height]);
leftProcessed = permute(temp,[2 1]);
dataRight = read(client,width*height);
temp = reshape(dataRight,[width,height]);
rightProcessed = permute(temp,[2 1]);
imagesc(leftProcessed);
end

% this write cmd will break out of the zynq server loop
write(client,'3');
flush(client); 

t = tiledlayout(1,2, 'Padding', 'none', 'TileSpacing', 'compact'); 
t.TileSpacing = 'compact';
t.Padding = 'compact';
 
nexttile    
imagesc(data)
axis off
nexttile
imagesc(leftProcessed);
colormap gray
axis off