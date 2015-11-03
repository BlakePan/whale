images = imageSet('GrayFolder'); % 'imgs': Folder of images

formatStr = 'w_%d.jpg';   % Output format
GrayFolder = 'GrayFolder/';
for i=1:images.Count
 imgi = read(images,i);  % Read an image  
 fileName = sprintf(formatStr,i-1);
 fileName = strcat(GrayFolder, fileName);
 imwrite(imgi,fileName); % Save images
end