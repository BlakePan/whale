clc;
clear all;

% set folder
TrainFolder = '../Train/';
Folder = '../positiveFolder/';mkdir(Folder);
images = imageSet(TrainFolder); % 'imgs': Folder of images

for i=1:5%images.Count 
    % open file
    imginp = read(images,i);
    whaleimg = WhaleExtract()
    
    % get filename
    curFile = char(images.ImageLocation(i));
    % extract image number from original image file name
    [~,len] = size(curFile); fileName = char();
    j = len;
    while curFile(j) ~= '\'
        fileName = strcat(curFile(j),fileName);
        j = j-1;
    end
    fileName = strcat(Folder, fileName);
    
    % write files
    imwrite(whaleimg,fileName);
end