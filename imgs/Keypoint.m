clear all;
clc;
[filename1,pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'Select an image');
img=imread(filename1);
[Rows, Cols, dep] = size(img);imgfilt = imgaussfilt(img,20);
figure(1);imshow(imgfilt);

imghsv = rgb2hsv(imgfilt);
figure(2);imshow(imghsv);

% transfer to hsv model
binnum = 16;
huehist = hist(imghsv(:,:,1),binnum); % histogram for hue
imghue = imghsv(:,:,1);
figure(3); imshow(imghue);

% filter
%h1=fspecial('gaussian');imghue=imfilter(imghue,h1);
%imghue = medfilt2(imghue,[3 3]);
%figure(4); imshow(imghue);

% edge detection
imgedge = edge(imghue,'Sobel');
figure(5); imshow(imgedge);

% 1st
se = strel('line',15,90);
imgdilate = imdilate(imgedge,se);
se = strel('line',15,0);
imgdilate = imdilate(imgdilate,se);
figure(6); imshow(imgdilate);

se = strel('disk',15);
imgerode = imerode(imgdilate,se);
figure(7); imshow(imgerode);

% 2nd
se = strel('line',15,90);
imgdilate = imdilate(imgerode,se);
se = strel('line',15,0);
imgdilate = imdilate(imgdilate,se);
figure(8); imshow(imgdilate);

se = strel('disk',15);
imgerode = imerode(imgdilate,se);
figure(9); imshow(imgerode);

% 3rd
se = strel('line',15,90);
imgdilate = imdilate(imgerode,se);
se = strel('line',15,0);
imgdilate = imdilate(imgdilate,se);
figure(10); imshow(imgdilate);

se = strel('disk',15);
imgerode = imerode(imgdilate,se);
figure(11); imshow(imgerode);

% find center
% labeledImage = bwlabel(imgedge);
% measurements = regionprops(labeledImage, imghue, 'WeightedCentroid');
% centerOfMass = measurements.WeightedCentroid
% [x, y] = meshgrid(1:size(imgedge, 2), 1:size(imgedge, 1));
% weightedx = x .* imgedge;
% weightedy = y .* imgedge;
% xcentre = sum(weightedx(:)) / sum(imgedge(:));
% ycentre = sum(weightedy(:)) / sum(imgedge(:));
% figure(6); imshow(img);
% rectangle('Position',[ycentre,xcentre,30,30],'Curvature',[1,1],'FaceColor','r');

% filter
%h1=fspecial('gaussian');imgedge=imfilter(imgedge,h1);
%figure(6); imshow(imgedge);

% imggray=rgb2gray(img);[rows,cols]=size(imggray);
% imggray = edge(imggray,'Canny');
% h1=fspecial('gaussian');imgfilter=imfilter(imggray,h1);
% imshow(imgfilter);

% 
% [Fx,Fy]=gradient(double(imgfilter));
% 
% Ix2 = abs(imfilter(Fx.*Fx,h1));
% Iy2 = abs(imfilter(Fy.*Fy,h1));
% IxIy = abs(imfilter(Fx.*Fy,h1));
% 
% TH=mean(mean(IxIy))/80;TL=0;
% alpha=0.06;L=0;
% imshow(img);
% 
%  for j=1:cols
%      for i=1:rows 
%         L=abs(Fy(i,j))+abs(Fx(i,j))*4;
%         AN=atand(Fy(i,j)/Fx(i,j));
%         tensor=[Ix2(i,j) IxIy(i,j);IxIy(i,j) Iy2(i,j)];
%         eigv=eig(tensor);
% 
%          if (eigv(1)<TH & eigv(2)<TH & eigv(1)>TL & eigv(2)>TL)
% 
%              Ly=L*cosd(AN);Lx=L*sind(AN);
%              if L>=15
%             rectangle('Position',[j,i,3,3],'Curvature',[1,1],'FaceColor','r');
%              end
%              if L<15
%             rectangle('Position',[j,i,3,3],'Curvature',[1,1],'FaceColor','r');
%              end
%              line([j,j+Ly],[i,i+Lx],'Color','b','LineWidth',3);
%          end
%      end
%  end

        %eigv(1)*eigv(2)-alpha*(eigv(1)+eigv(2))^2;