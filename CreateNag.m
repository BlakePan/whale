images = imageSet('GrayFolder'); % 'imgs': Folder of images

formatStr = 'neg%d.jpg';   % Output format for negatives
negativeFolder = 'negativeFolder/';
mkdir(negativeFolder)
for i=1:images.Count 
 imginp = read(images,i);  % Read an image 
 imcropped = imcrop(imginp,[1 1 1078 670]); % Crop
 fileName = sprintf(formatStr,i);
 fileName = strcat(negativeFolder, fileName);
 imwrite(imcropped,fileName); % Save negative images
end