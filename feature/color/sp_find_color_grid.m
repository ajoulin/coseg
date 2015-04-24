function features  =sp_find_color_grid(grid_x,grid_y,I, patchSize,resolution)

 %features=zeros([size(grid_x), 6*resolution]);
 features=zeros([size(grid_x), 3*resolution]);

n_per_bin=(1./resolution);


for x=1:size(grid_x,2)
    for y =1:size(grid_x,1)
        
        % find window of pixels that contributes to this descriptor
        %         x_lo = grid_x(y, x) - patchSize * .5 + 1;
        %         x_hi = min( grid_x(y, x) + patchSize * .5, size(I,2));
        %         y_lo = grid_y(y, x) - patchSize * .5 + 1;
        %         y_hi = min( grid_y(y, x) + patchSize * .5, size(I,1));
        
        
        i = y + (x - 1) * size(grid_x,1);
        x_lo = grid_x(i);
        x_hi = grid_x(i) + patchSize - 1;
        y_lo = grid_y(i);
        y_hi = grid_y(i) + patchSize - 1;
        
        patch = I(y_lo:y_hi,x_lo:x_hi,:);
        
        nPoints = size(I,1) * size(I,2);
        
        patch   = reshape(patch, [size(patch,1) * size(patch,2), 3]);
        patch   = floor(patch / n_per_bin) + 1;
        patch   = patch - (patch == resolution + 1);
        %         patch             = sum(patch + ones(size(patch,1),1) * [0, resolution, 2 * resolution],2);
        %         features(y, x,:)  = accumarray(patch,1, [6 * resolution 1]) ;
        %/nPoints
        
        patch   = (patch + ones(size(patch,1),1) * [0, resolution, 2 * resolution]);
        features(y, x,:) = accumarray(patch(:),1, [3 * resolution 1]) ;
        features(y, x,:) = features(y, x,:);
        
    end
end

