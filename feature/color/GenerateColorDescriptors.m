function [features, gridX, gridY] = GenerateColorDescriptors(I, patchSize, gridSpacing, resolution)
%function [] = GenerateSiftDescriptors( imageFileList, imageBaseDir, dataBaseDir, maxImageSize, gridSpacing, patchSize, canSkip )
%
% Generate the dense grid of color histogram for each
% image
% the size of an histogram is patchSize^2

if max(I(:))>1
    I = double(I)/256;
end

[hgt wid ~] = size(I);

%% make grid (coordinates of upper left patch corners)
remX = mod(wid-patchSize,gridSpacing);
offsetX = floor(remX/2)+1;
remY = mod(hgt-patchSize,gridSpacing);
offsetY = floor(remY/2)+1;

[gridX,gridY] = meshgrid(offsetX:gridSpacing:wid-patchSize+1, offsetY:gridSpacing:hgt-patchSize+1);
% 
% gridX = patchSize *.5 : gridSpacing : wid - patchSize *.5 + 1;
% gridY = patchSize *.5 : gridSpacing : hgt - patchSize *.5 + 1;
% 
% [gridX, gridY] = meshgrid(gridX, gridY);



features = sp_find_color_grid(gridX, gridY,I, patchSize,resolution);


