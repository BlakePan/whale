clear all;
clc;
%% image processing
% read img
[filename1,pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'Select an image');
img=imread(filename1);
[Rows, Cols, dep] = size(img);
imggray = rgb2gray(img);
figure; imshow(img); title('original image');

% hsv model
imghsv = rgb2hsv(img);
imghue = imghsv(:,:,1);
% figure; imshow(img); title('image hue channel');

% filter
% imghue = medfilt2(imghue,[5,5]); % median filter use 2-d img
imghue = imgaussfilt(imghue,2);
% figure; imshow(img); title('image hue channel after filter');

% histogram
imgpost = imghue;
binnum = 100;
imgpost_1d = reshape(imgpost,1,[]);
[cnt, ~] = hist(imgpost_1d,binnum);
[~, mostind] = max(cnt);
ratio = (max(imgpost_1d) - min(imgpost_1d))/binnum;
backgnd = mostind*ratio + min(imgpost_1d);

% background extraction
imgbw = imgpost;
for i=1:Rows
    for j=1:Cols
        if (imgbw(i,j) >= backgnd-0.05 && imgbw(i,j) <= backgnd+0.05)...
            || (imgbw(i,j) > 0.8)
            imgbw(i,j) = 0;
        else
            imgbw(i,j) = 1;
        end
    end
end
figure; imshow(imgbw); title('image hue channel after background extraction');

% edge detection hsv after background extraction
% imgbwedge = edge(imgbw,'Canny');
% figure; imshow(imgbwedge); title('edge detection on image hue channel');

% dilate and erode
se = strel('line',100,90);
imgdilate = imdilate(imgbw,se);
se = strel('line',100,0);
imgdilate = imdilate(imgdilate,se);
figure; imshow(imgdilate); title('image hue channel dilate');

se = strel('disk',20);
imgerode = imerode(imgdilate,se);
figure; imshow(imgerode); title('image hue channel erode');

% find orientation
imgCen = regionprops(imgerode,'Centroid');
imgOri = regionprops(imgerode,'Orientation');
centroids = cat(1, imgCen.Centroid);
% hold on
% plot(centroids(:,1),centroids(:,2), 'b*')
% hold off

% find object
L = bwlabel(imgerode,8);
Lbin = max(max(L))+1;
L_1d = reshape(L,1,[]);
[cnt, ~] = hist(L_1d,Lbin);
[~, mostind] = max(cnt(2:end));
[r,c] = find(L == mostind); 

% define boundaries
roi_ext = 0;
maxr = max(r)+roi_ext; minr = min(r)-roi_ext;
maxc = max(c)+roi_ext; minc = min(c)-roi_ext;
bound = [maxr, Rows];   maxr = bound((maxr>Rows)+1);
bound = [minr, 1];      minr = bound((minr<1)+1);
bound = [maxc, Cols];   maxc = bound((maxc>Cols)+1);
bound = [minc, 1];   minc = bound((minc<1)+1);

%% feature extraction
% extract roi
imgroi = img(minr:maxr, minc:maxc, :);
figure; imshow(imgroi); title('ROI image');

% gray model
imgroigray = rgb2gray(imgroi);
% imgroiedge = edge(imgroigray,'Canny');
% figure; imshow(imgroiedge); title('edge detection on ROI image');
% imgroigray = medfilt2(imgroigray,[5,5]);
% imgroigray = imgaussfilt(imgroigray,1);
% figure; imshow(imgroigray); title('ROI gray image');
% 
% corner detection
% C = corner(imgroigray);
% figure; imshow(imgroigray); title('corner detection on ROI img');
% hold on; plot(C(:,1), C(:,2), 'r*');

% Whale detector
load('../WhaleDetectorMdl.mat');

DetecImg = imggray; %imgroigray;
bbox = step(WhaleDetectorMdl,DetecImg);
detectedImg = insertObjectAnnotation(DetecImg,'rectangle',bbox,'whale');
figure; imshow(detectedImg); title('whale detector')