%% Segmentation of 1005C 5h Air Cooling

clear; close all;
 
fname=('1005C5hAC_800x');
i = imread(sprintf('%s.tif',fname));
[h, w] = size(i);

%% %%%%%% First section: separation of the primary alpha  %%%%%%%%%

% This part use the function edge to find the edge of the different phase
% and require manual closing of the boundaries



%% Gaussian smoothing followed by sharpenning 
s =imsharpen(imgaussfilt(i,3),'amount',100);

% find edge
e= edge(s);

% grow edge
d= imdilate(e,strel('disk',3));

% remove more than 200 pixel
op= bwareaopen(d,200);

% close grain boundaries 
cl= imclose(op,strel('disk',3));

%% Manual closing of the boundaries %%

% In this part pixel that have to be part of the boundarie are given the
% value 1.


%% Assume all boundaries are now closed 
%close white grain (fill inside of boundaries)
rm= ~bwareaopen(~cl,150000);

%  erosion following the previous dilatation
G= imerode(F,strel('disk',3));

% remove more than x pixel
H= bwareaopen(G,200);

% Save the separation of alpha phase 
imwrite(H,'saveSegment.tif');

%% Given that the first section is manual and can take time, it has been saved in a tif file

imwrite(H,sprintf('%f_saveSegment.tif',fname));


%% %%%%% Second section: Separation of beta and secondary alpha %%%%%%
% Alpha phase has been differentiate, focus is now on lamellae part.

% Gaussian smoothing
a = imgaussfilt(i,1);

% alpha phase is given the 0 value in the smoothed original image
a(~H)=0;

% Sharpening of the beta and alpha2 phase
amount=8;
Sa = imsharpen(a,'amount',amount);

% Masking of alpha phase (NaN)
Sa=double(Sa);
Sa(~H)=NaN;

% threshold on remaining beta and secondary alpha
Sa_nonans=Sa_NaN(~isnan(Sa_NaN(:)));            % Extract all the non-NaN value in a 1D array
counts = grscrep(Sa_nonans,size(Sa_nonans),1);  % Repartition of the non-NaN value [0 255]
t = otsuthresh(counts(2,:))*255;                % Threshold using otsu method

Salpha1 = H==0;
Salpha2 = Sa<=t*1;
Sbeta = Sa>t*1;

% Filling the beta phase (Remove small dot in beta)
SbetaN = ~bwareaopen(~Sbeta,10);  %remove all the holes in beta smaller than 20
SbetaN = bwareaopen(SbetaN,10);     %remove all the beta smaller than 20

% delete alpha 2 that are now beta
Salpha2N = ~(Salpha1 + SbetaN );

SFinalSegN =zeros(h,w,3);
SFinalSegN(:,:,1)=Salpha2N;
SFinalSegN(:,:,2)=Salpha1;
SFinalSegN(:,:,3)=SbetaN;

% Save segmented image
imwrite(SFinalSegN,sprintf('%s_Segmented(shap8)_NoNaNs.tif',fname));
imwrite(SFinalSegN,sprintf('%s_Segmented(shap8)_NoNaNs.jpg',fname));


