%% Segmentation of 950C 1h Air cooling

clear; close all;

fname=('950C1hAC_800x');
i = imread(sprintf('%s.tif',fname));

% gaussian smoothing
a = imgaussfilt(i,1);

% Threshold
% t = graythresh(a);
t=0.65;
A = a>t*255;

% Remove small white dot
B = bwareaopen(A,50); %remove all object smaller than 50

% Save segmented image
imwrite(B,sprintf('%s_Segmented.tif',fname));
imwrite(B,sprintf('%s_Segmented.jpg',fname));








