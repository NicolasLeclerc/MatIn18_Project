%% Segmentation of 900C 5h Water Quenching

clear; close all;

fname=('900C5hIWQ_800x');
i = imread(sprintf('%s.tif',fname));

% gaussian smoothing
a = imgaussfilt(i,1);

% Threshold
t = graythresh(a);
A = a>t*255;

% Remove small white dot
B = bwareaopen(A,100); %remove all object smaller than 100

% Save segmented image
imwrite(B,sprintf('%s_Segmented.tif',fname));
imwrite(B,sprintf('%s_Segmented.jpg',fname));







