%% Right Whale Recognition Challenge
clear all;
clc;

%% Whale extraction
% read img
[filename1,pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'Select an image');
filename1 = strcat(pathname, filename1);
img=imread(filename1);
figure; imshow(img); title('original image');

% Extract whole whale
whaleimg = WhaleExtract(img);
figure; imshow(whaleimg); title('whale image');

% Extract face
[whaleHeight, whaleWidth, ~] = size(whaleimg);
face1 = whaleimg(1:whaleWidth,:,:); % top
face2 = whaleimg(whaleHeight-whaleWidth:whaleHeight,:,:); % buttom
figure; imshow(face1); title('whale face1');
figure; imshow(face2); title('whale face2');

%% 
% % Whale detector
% load('MAT/WhaleDetectorMdl_100X100.mat');
% 
% DetecImg = rgb2gray(whaleimg); %imgroigray;
% [DetRows, DetCols] = size(DetecImg);
% DetecImg = imresize(DetecImg, 300/DetRows);
% bbox = step(WhaleDetectorMdl,DetecImg);
% detectedImg = insertObjectAnnotation(DetecImg,'rectangle',bbox,'whale');
% figure; imshow(detectedImg); title('whale detector')