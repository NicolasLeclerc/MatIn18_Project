%% Segmentation of 900C 1h Air cooling

clear; close all

fname=('900C1hAC_800x');
i = imread(sprintf('%s.tif',fname));
[h, w] = size(i);

% gaussian smoothing
a = imgaussfilt(i,1);

%Threshold
t = graythresh(a);
A = a>t*255;

% Remove small white dot
B = bwareaopen(A,50); %remove all object smaller than 50

% Save segmented image
imwrite(B,sprintf('%s_Segmented.tif',fname));
imwrite(B,sprintf('%s_Segmented.jpg',fname));








