function [V] = optical_flow(im_path1, im_path2, sigma, kernel_length, region_size, interest_points, verbose)

    close all
    % Algorithm
    % 1) Divide input images on non-overlapping regions
    %    each region being 15x15 pixels
    % 2) For each region compute A, A^T an b; then estimate optical 
    %    flow as given in equation (20)
    % 3) Display results with quiver
        
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    
    if nargin < 6
        interest_points = make_grid(im1, region_size);
    end
    
    if nargin < 7
        verbose = true;
    end
    
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    
    
    Ix = gaussianDer4(im_path1, filter_x, sigma, 1, 'same');
    Iy = gaussianDer4(im_path1, filter_y, sigma, 2, 'same');
    
    It = (double(im2) - double(im1));
    
    It = sum(It, 3);
    regions_x = get_regions(Ix, region_size, interest_points); % returns cell arrays for every region in I
    regions_y = get_regions(Iy, region_size, interest_points);
    regions_t = get_regions(It, region_size, interest_points);

    flat_x = reshape(regions_x, size(regions_x, 1)*size(regions_x, 2), 1, size(regions_x, 3));
    flat_y = reshape(regions_y, size(regions_y, 1)*size(regions_y, 2), 1, size(regions_y, 3));
    flat_t = reshape(regions_t, size(regions_t, 1)*size(regions_t, 2), 1, size(regions_t, 3));
    
    A = cat(2, flat_x, flat_y);
    b = -flat_t;
    At = permute(A, [2,1,3]);
    
    V = zeros(2, 1, size(interest_points, 3));
    
    for idx = 1:size(A, 3)
        r = At(:,:,idx) * A(:,:,idx);
        q = (At(:,:,idx) * b(:,:,idx));
        V(:,:,idx) = pinv(At(:,:,idx) * A(:,:,idx)) * (At(:,:,idx) * b(:,:,idx));
    end
    
    V = squeeze(V)';
    if verbose
        display_results(im1, interest_points, V);
        figure, imshow(im2);
    end
end

function res = make_grid(im, region_size)
    
    remainder_row = mod(size(im, 1), region_size);
    remainder_col = mod(size(im, 2), region_size);
    rows = (floor(remainder_row / 2)+1+floor(region_size/2)):region_size:(size(im,1) - ceil(remainder_row / 2) - floor(region_size/2));
    cols = (floor(remainder_col / 2)+1+floor(region_size/2)):region_size:(size(im,2) - ceil(remainder_col / 2) - floor(region_size/2));
    [rows, cols] = meshgrid(rows, cols);
    res = [rows(:), cols(:)];
end

function regions = get_regions(I, region_size, interest_points)

    lu_offset = int32(floor((region_size-1)/2));
    rd_offset = int32(ceil((region_size-1)/2));
    
    num_points = size(interest_points, 1);
    regions = zeros(region_size, region_size, num_points);
    
    for idx = 1:num_points
        row = interest_points(idx, 1);
        col = interest_points(idx, 2);
        
        if row-lu_offset > 1 && row+rd_offset < size(I, 1) &&  col-lu_offset > 1 && col+rd_offset < size(I, 2)
            regions(:,:,idx) = I(row-lu_offset:row+rd_offset, col-lu_offset:col+rd_offset);
        end
    end
    
end

% function v = lucas_kanade(region_x, region_y, region_t)
%     % checked: sizes are all fine
%     
%     mat_x = cell2mat(region_x);
%     mat_y = cell2mat(region_y);
%     mat_t = cell2mat(region_t);
%         
%     
%     A = [mat_x(:), mat_y(:)];
%     b = -mat_t(:);
%     v = pinv(A'*A)*A' * b;
% end


function display_results(im, interest_points, V)

    Vrow = V(:,1);
    Vcol = V(:,2);
    
    Prow = interest_points(:, 1);
    Pcol = interest_points(:, 2);
    
    figure, imshow(im);
    hold on
    quiver(Pcol, Prow, Vrow, Vcol, 'AutoScale', 'off');
    hold off
end