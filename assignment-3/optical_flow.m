% Computer Vision Assignment 3 Part 2
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [V] = optical_flow(im_path1, im_path2, region_size, interest_points, verbose)
        
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    
    % if used for assignment 2 --> make grid of non-overlapping regions
    % else if used for assignment 3 --> make regions around interest points
    if nargin < 4
        interest_points = make_grid(im1, region_size);
    end
    
    if nargin < 5
        verbose = true;
    end
        
    Ix = gradient_filter(im_path1, 1, 'same');
    Iy = gradient_filter(im_path1, 2, 'same');   
    It = (double(im2) - double(im1));    
    It = sum(It, 3);
    
    regions_x = get_regions(Ix, region_size, interest_points); 
    regions_y = get_regions(Iy, region_size, interest_points);
    regions_t = get_regions(It, region_size, interest_points);

    % convert each region matrix to a vector
    flat_x = reshape(regions_x, size(regions_x, 1)*size(regions_x, 2), 1, size(regions_x, 3));
    flat_y = reshape(regions_y, size(regions_y, 1)*size(regions_y, 2), 1, size(regions_y, 3));
    flat_t = reshape(regions_t, size(regions_t, 1)*size(regions_t, 2), 1, size(regions_t, 3));
    
    % apply lukas kanade
    A = cat(2, flat_x, flat_y);
    b = -flat_t;
    At = permute(A, [2,1,3]);
    
    V = zeros(2, 1, size(interest_points, 3));    
    for idx = 1:size(A, 3)
        V(:,:,idx) = pinv(At(:,:,idx) * A(:,:,idx)) * (At(:,:,idx) * b(:,:,idx));
    end
    V = squeeze(V)';
    
    if verbose
        display_results(im1, interest_points, V);
        figure, imshow(im2);
    end
end

function res = make_grid(im, region_size)
    % Make grid of non-overlapping regions; centers of regions are interest
    % points
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
        
        % check if regions are out of bounds
        if row-lu_offset > 1 && row+rd_offset < size(I, 1) &&  col-lu_offset > 1 && col+rd_offset < size(I, 2)
            regions(:,:,idx) = I(row-lu_offset:row+rd_offset, col-lu_offset:col+rd_offset);
        end
    end
    
end

function display_results(im, interest_points, V)

    Vrow = V(:,1);
    Vcol = V(:,2);
    
    Prow = interest_points(:, 1);
    Pcol = interest_points(:, 2);
    
    figure, imshow(im);
    hold on
    quiver(Pcol, Prow, Vrow, Vcol, 'AutoScale', 'off', 'Color', 'cyan');
    hold off
end