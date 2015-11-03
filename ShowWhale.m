clc;
clear all;
load('WhaleDetectorMdl.mat');

I = imread('GrayFolder/w_26.jpg');
I = medfilt2(I,[3 3]);% img filter
%I = imgaussfilt(I,8);% smoothing
I2 = imread('imgs/w_25.jpg');
DetecImg = I;

bbox = step(WhaleDetectorMdl,DetecImg);
detectedImg = insertObjectAnnotation(DetecImg,'rectangle',bbox,'whale');
figure; imshow(detectedImg);