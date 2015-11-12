%% Whale Extraction
% input:
% raw image(RGB)
% output:
% whale image(RGB) with callibration
function[whale] = WhaleExtract(img)
[Rows, Cols, dep] = size(img);
% imggray = rgb2gray(img);
% figure; imshow(img); title('original image');

% hsv model
imghsv = rgb2hsv(img);
imghue = imghsv(:,:,1);
% figure; imshow(img); title('image hue channel');

% filter
% imghue = medfilt2(imghue,[5,5]); % median filter use 2-d img
imghue = imgaussfilt(imghue,2);
% figure; imshow(img); title('image hue channel after filter');

% histogram
binnum = 100;
imgpost_1d = reshape(imghue,1,[]);
[cnt, ~] = hist(imgpost_1d,binnum);
[~, mostind] = max(cnt);
ratio = (max(imgpost_1d) - min(imgpost_1d))/binnum;
backgnd = mostind*ratio + min(imgpost_1d);

% background extraction
imgbw = imghue;
for i=1:Rows
    for j=1:Cols
        if (imgbw(i,j) >= backgnd-0.05 && imgbw(i,j) <= backgnd+0.05)
            imgbw(i,j) = 0;
        else
            imgbw(i,j) = 1;
        end
    end
end
% figure; imshow(imgbw); title('image hue channel after background extraction');

% dilate and erode
se = strel('disk',10);
imgerode = imerode(imgbw,se);

se = strel('line',130,90);
imgdilate = imdilate(imgerode,se);
se = strel('line',130,0);
imgdilate = imdilate(imgdilate,se);
% figure; imshow(imgdilate); title('image hue channel dilate');

se = strel('disk',20);
imgerode = imerode(imgdilate,se);
% figure; imshow(imgerode); title('image hue channel erode');

% find object
L = bwlabel(imgerode,8);
Lbin = max(max(L))+1;
L_1d = reshape(L,1,[]);
[cnt, ~] = hist(L_1d,Lbin);
[~, mostind] = max(cnt(2:end)); % index 1 of cnt indicates to '0', that means background

% filter all non-object pixels
imgbw = imgerode;
for i=1:Rows
    for j=1:Cols
        if L(i,j) ~= mostind
            imgbw(i,j) = 0;
        end
    end
end
% figure; imshow(imgbw); title('image filter all non-object pixels');

% plot ellipse
s = regionprops(imgbw, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid');
% PlotEllipse(s, imgbw);

% img rotate
imgbwrot = imrotate(imgbw,90-s.Orientation+180);
[Rowsrot, Colsrot] = size(imgbwrot);
% figure; imshow(imgbwrot); title('bw image after rotation');

% find object boundary
L = bwlabel(imgbwrot,8);
[r,c] = find(L == 1);

roi_ext = 0;
maxr = max(r)+roi_ext; minr = min(r)-roi_ext;
maxc = max(c)+roi_ext; minc = min(c)-roi_ext;
bound = [maxr, Rowsrot];    maxr = bound((maxr>Rowsrot)+1);
bound = [minr, 1];          minr = bound((minr<1)+1);
bound = [maxc, Colsrot];    maxc = bound((maxc>Colsrot)+1);
bound = [minc, 1];          minc = bound((minc<1)+1);

% LU = [minr, minc];RU = [minr, maxc];
% LD = [maxr, minc];RD = [maxr, maxc];
% x = [LU(1), LD(1), RD(1), RU(1), LU(1)];
% y = [LU(2), LD(2), RD(2), RU(2), LU(2)];
% hold on; plot(y,x); hold off;

% rotate image
imgrot = imrotate(img,90-s.Orientation+180);
% figure; imshow(imgrot); title('image after rotation');
whale = imgrot(minr:maxr, minc:maxc, :);

% cutting edge
imgbwrot = imgbwrot(minr:maxr, minc:maxc, :);
[~, whaleCols, ~] = size(imgbwrot);
horz_cnt = zeros(whaleCols);
whaleedge = edge(imgbwrot);
figure; imshow(whaleedge); title('whale image edge');

% scan horizonal direction
for i = 1:whaleCols
    horz_cnt(i) = sum(whaleedge(:,i));
end
horz_mav = tsmovavg(horz_cnt,'s',50,1); % moving average
[peakLR, ~] = peakfinder(transpose(horz_mav(:,1)));

whale = whale(:, peakLR(1):peakLR(2));
end