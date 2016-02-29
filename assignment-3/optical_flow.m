function [] = optical_flow(im_path)
    % Algorithm
    % 1) Divide input images on non-overlapping regions
    %    each region being 15x15 pixels
    % 2) For each region compute A, A^T an b; then estimate optical 
    %    flow as given in equation (20)
    % 3) Display results with quiver
    
    im = imread(im_path);
    %im = rgb2gray(im);
    region_size = 15;
    regions = get_regions(im, region_size);
    [A, b] = lucas_kanade(regions);
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
    regions(1)
end

function [A, b] = lucas_kanade(regions)
    % get Ix --> same as before
    % get Iy --> same as before
    % get It --> what is that?? where's the t component in the image?
    for i=1:size(regions, 1)
        regions(i)
    end
end