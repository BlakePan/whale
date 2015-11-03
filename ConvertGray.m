images = imageSet('imgs'); % 'imgs': Folder of images
formatStr = 'w_%d.jpg';   % Output format
SourceFolder = 'imgs/';
GrayFolder = 'GrayFolder/';
mkdir(GrayFolder)
for i=1:images.Count 
 %imgi = read(images,i);  % Read an image
 fileName = sprintf(formatStr,i-1);
 ReadfileName = strcat(SourceFolder, fileName);
 imgi = imread(ReadfileName);
 imggray = rgb2gray(imgi);
 WritefileName = strcat(GrayFolder, fileName);
 imwrite(imggray,WritefileName); % Save images
end