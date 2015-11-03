clc; clear all;

% Folder setting
imgFolder = 'GrayFolder/'; trainImgFolder = 'Train/';
mkdir(trainImgFolder);
fid=fopen('trainsort.csv');
trainCSV = textscan(fid,'%s %s','HeaderLines',1,'Delimiter',',');
fclose(fid);
ImgName = trainCSV{1}; WhaleID = trainCSV{2};
[NumImg, ~] = size(ImgName);

idcnt = 0; lastID = -1;
for i = 1:NumImg
    % read img name and its id
    name = char(ImgName(i));
    ID = char(WhaleID(i));
    [~,len] = size(ID);    
    if i==1 || min(ID == lastID)
        idcnt = idcnt + 1;
    else
        idcnt = 1;
    end
    fileName = strcat('[', ID(len-4:len), ']_', num2str(idcnt), '.jpg');
    lastID = ID;
%     [~,len] = size(name);
%     fileName = strcat(name(1:len-4),'_');
%     
%     [~,len] = size(ID);
%     fileName = strcat(fileName, ID(len-4:len), '.jpg');
    
    % set source and destination folder, and copy img file
    source = strcat(imgFolder, name);
    dest = strcat(trainImgFolder, fileName);
    copyfile(source,dest);
end

