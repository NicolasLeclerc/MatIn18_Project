%% Segmentation of 900C 5h Air cooling 

clear; close all

fname=('900C5hAC_800x');
i = imread(sprintf('%s.tif',fname));

% gaussian smoothing
a = imgaussfilt(i,1);

% Threshold
t = graythresh(a);
A = a>t*255;

% remove of small white object
B = bwareaopen(A,80); 

% Save segmented image
imwrite(B,sprintf('%s_Segmented.tif',fname));
imwrite(B,sprintf('%s_Segmented.jpg',fname));







