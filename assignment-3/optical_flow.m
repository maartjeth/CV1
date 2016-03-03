function [] = optical_flow(im_path1, im_path2, sigma, kernel_length)

    close all
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
    
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    Ix = gaussianDer2(im_path1, filter_x, sigma, 1, 'same');
    Iy = gaussianDer2(im_path1, filter_y, sigma, 2, 'same');
    It = double(im2) - double(im1);
    It = sum(It, 3);
    
    regions_x = get_regions(Ix, region_size); % returns cell arrays for every region in I
    regions_y = get_regions(Iy, region_size);
    regions_t = get_regions(It, region_size);

    V = arrayfun(@(x,y,t) lucas_kanade(x,y,t), regions_x, regions_y, regions_t, 'UniformOutput', false);
    
    display_results(im1, V, region_size);
    
    remainder_row = mod(size(im2, 1), region_size);
    remainder_col = mod(size(im2, 2), region_size);
    im2 = im2((floor(remainder_row / 2)+1):(size(im2,1) - ceil(remainder_row / 2)), ...
        (floor(remainder_col / 2)+1):(size(im2,2) - ceil(remainder_col / 2)), :);
    figure, imshow(im2)
end

% WORKS
function [regions] = get_regions(I, region_size)    
    remainder_row = mod(size(I, 1), region_size);
    remainder_col = mod(size(I, 2), region_size);
    I = I((floor(remainder_row / 2)+1):(size(I,1) - ceil(remainder_row / 2)), ...
        (floor(remainder_col / 2)+1):(size(I,2) - ceil(remainder_col / 2)));
    
    parts_rows = region_size * ones(int16(size(I, 1)) / region_size, 1);
    parts_cols = region_size * ones(int16(size(I, 2)) / region_size, 1);
    
    regions = mat2cell(I, parts_rows, parts_cols);
end

function v = lucas_kanade(region_x, region_y, region_t)
    mat_x = cell2mat(region_x);
    mat_y = cell2mat(region_y);
    mat_t = cell2mat(region_t);
    
    A = [mat_x(:), mat_y(:)];
    b = -mat_t(:);
    v = pinv(A'*A)*A' * b;
end


function display_results(im, V, region_size)
    V = cell2mat(V);
    Vx = V(1:2:end, :);
    Vy = V(2:2:end, :);

    remainder_row = mod(size(im, 1), region_size);
    remainder_col = mod(size(im, 2), region_size);
    im = im((floor(remainder_row / 2)+1):(size(im,1) - ceil(remainder_row / 2)), ...
        (floor(remainder_col / 2)+1):(size(im,2) - ceil(remainder_col / 2)), :);
    figure, imshow(im);
    hold on
    scale_row = floor(region_size / 2)+1:region_size:size(im, 1); % syntax is start:step:end
    scale_col = floor(region_size / 2)+1:region_size:size(im, 2);
    region_size
    size(scale_row)
    size(Vx)
    quiver(scale_col, scale_row, Vx, -Vy);
    hold off
end