%% Segmentation of 950C 5h Air cooling

clear; close all;

fname=('950C5hAC_800x');
i = imread(sprintf('%s.tif',fname));
[h, w] = size(i);

%% %%%%%% First section: separation of the primary alpha  %%%%%%%%%

% gaussian smoothing
a = imgaussfilt(i,1);

% Manual threshold
t=130;
A = a>t;

% Remove small white dot
objSize = 150 ;
B = bwareaopen(A,objSize); %remove all object smaller than objSize (number of px)

% Filling all the black lamellae of secondary alpha
C = imclose(B,strel('disk',4));  % dialtation followed by erosion using same structure 

% Close the white grain (inversion of the color to close the dark dot)
objSize = 250 ;
D = ~bwareaopen(~C,objSize);


%% %%%%% Second section: Separation of beta and secondary alpha %%%%%%
% Alpha phase has been differentiate, focus is now on lamellae part.

% alpha phase is given the 0 value in the smoothed original image (a)
idx = find(D == 0);    
a(idx) = 0;              

% Sharpening of the beta and alpha2 phase
amount=8;
Sa = imsharpen(a,'amount',amount);

% Masking of alpha phase (NaN)
Sa_NaN=double(Sa);
Sa_NaN(idx)=NaN;

% threshold on remaining beta and secondary alpha
Sa_nonans=Sa_NaN(~isnan(Sa_NaN(:)));            % Extract all the non-NaN value in a 1D array
counts = grscrep(Sa_nonans,size(Sa_nonans),1);  % Repartition of the non-NaN value [0 255]
t = otsuthresh(counts(2,:))*255;                % Threshold using otsu method

Salpha1 = D==0;
Salpha2 = Sa_NaN<=t;
Sbeta = Sa_NaN>t;

% Removing of small beta and alpha2 elements
SbetaN = ~bwareaopen(~Sbeta,20);    %remove all the holes in beta smaller than 20
SbetaN = bwareaopen(SbetaN,20);     %remove all the beta smaller than 20

% delete alpha 2 that are now beta
Salpha2N = ~(Salpha1 + SbetaN );

% Save each phase in one different layer of SFinalSegN
SFinalSegN =zeros(h,w,3);
SFinalSegN(:,:,1)=Salpha2N;
SFinalSegN(:,:,2)=Salpha1;
SFinalSegN(:,:,3)=SbetaN;

% Save segmented image
imwrite(SFinalSegN,sprintf('%s_Segmented(shap8)_NoNaNs.tif',fname));
imwrite(SFinalSegN,sprintf('%s_Segmented(shap8)_NoNaNs.jpg',fname));






