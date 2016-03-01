function [] = optical_flow(im_path1, im_path2)
    % Algorithm
    % 1) Divide input images on non-overlapping regions
    %    each region being 15x15 pixels
    % 2) For each region compute A, A^T an b; then estimate optical 
    %    flow as given in equation (20)
    % 3) Display results with quiver
    
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    %im = rgb2gray(im);
    region_size = 15;
    regions1 = get_regions(im1, region_size);
    regions2 = get_regions(im2, region_size);
    
    sigma = 3;
    kernel_length = 11;
    [A, b] = lucas_kanade(regions1, regions2, sigma, kernel_length);
end

function [regions] = get_regions(im, region_size)
    size_rows = floor(size(im, 1) / region_size);
    size_cols = floor(size(im, 2) / region_size);
    parts_rows = zeros(region_size, 1);
    parts_cols = zeros(region_size, 1);
    
    for i=1:size_rows
        parts_rows(i) = region_size;
    end
    
    for i=1:size_cols
        parts_cols(i) = region_size;
    end
    
    % note that I deleted part of the image, to make this fit, not so neat
    regions = mat2cell(im(1:size_rows*region_size, 1:size_cols*region_size), parts_rows, parts_cols);
end

function [A, b] = lucas_kanade(regions1, regions2, sigma, kernel_length)

    % get Ix and Iy for all pixels in the region and therefor A --> we use image 1 for this
    % also get It and therfor b
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    
    A = zeros(size(regions1, 1), size(regions1, 1), 2, size(regions1, 2)); % you want 15 rows for all q values, 2 columns for Ix and Iy and a third dimension to store this for all regions
    b = zeros(size(regions1, 1), size(regions1, 2), size(regions1, 2));
    
    for i=1:size(regions1, 1)  
        region1 = cell2mat(regions1(i)); % get back from cell to matrix
        region2 = cell2mat(regions2(i));
        if size(region1, 1) ~= 0 % this shouldn't need to be checked, just added it to be able to go on; need to have a look to the regions again
            Ix = gaussianDer3(double(region1), filter_x, sigma, 1, 'same'); % horizontal edge filter
            Iy = gaussianDer3(double(region1), filter_y, sigma, 2, 'same'); % vertical edge filter
            It = region2 - region1;
        end
        
        A(:, :, 1, i) = Ix; % store Ix in all rows of the first column, in dim i
        A(:, :, 2, i) = Iy; % store Iy in all rows the second column, in dim i  
        
        b(:, :, i) = It;           
    end    
end

