% Computer Vision Assignment 3 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl



function [] = harris_corner(im_path, sigma, kernel_length, k, neighbour_length, threshold)
    
    % steps:
    % 1) get_i
    % 2) get_elem_q
    % 3) construct_h
    
    % function copied from last week:    
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    
    display('getting i')
    [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y);
    display('getting a b c')
    [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y);
    display('getting h')
    H = construct_h(A, B, C, k);
    %size(H)
    %display('getting corners')
    [r, c] = get_corners(H, neighbour_length, threshold);
    %display('r')
    %
    %display('c')
    %
    
    plot_corners(im_path, r, c);
    
end

function [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y)
    % smoothed derivatives of the image: convolve the first order gaussian
    % derivative, Gd, with the image along the x or y direction   
   
    % function copied from last week, but slightly modified to get the two different directions  
    % use same to get the same dimensions
    Ix = gaussianDer2(im_path, filter_x, sigma, 1, 'same'); % horizontal edge filter
    Iy = gaussianDer2(im_path, filter_y, sigma, 2, 'same'); % vertical edge filter
    
    % show the images (part of the assignment, don't delete)
    % figure, imshow(Ix);
    % figure, imshow(Iy);
    
    % notes
    % Ix: 576 * 720
    % Iy: 576 * 720
end

function [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y)
    % A: squaring Ix and convolving it with a Gaussian (convolution comes
    % from sum over w)
    
    % B: multiply Ix and Iy and convolve it with a Gaussian
    % C: squaring Iy and convolving it with a Gaussian
    
    % NOTE: This setting gives the best H-matrix, considering where you'd expect
    % the corners
    
    filter_xy = filter_y * filter_x;
    
    A = conv2(Ix.^2, filter_x, 'same');
    %B = conv2(Ix, filter_x, 'same') .* conv2(Iy, filter_y, 'same');
    B = conv2(Ix.*Iy, filter_xy, 'same');
    C = conv2(Iy.^2, filter_y, 'same'); 
    
    %size(A)
    %size(B)
    %size(C)    
end

function [H] = construct_h(A, B, C, k)
    H = (A.*C-B.^2) - k*(A+C).^2;
    figure, imshow(H*50);
end

function [r, c] = get_corners(H, neighbour_length, threshold)    
    display('getting corners')
    row = 1;
    col = 1;
    number_corners = (size(H, 1) / neighbour_length) * (size(H, 2) / neighbour_length);
    display(number_corners)
    r = zeros(number_corners, 1);
    c = zeros(number_corners, 1);
    total_corners_found = 1;
    
    while col <= size(H, 2) 
        %display('in while')
        %display(total_corners_found)
        %display(row)
        %display(col)
        local_matrix = H(row:row+neighbour_length-1, col:col+neighbour_length-1); % slice part of matrix
        max_value = max(local_matrix(:));
        
        % checking for the threshold
        if max_value > threshold            
            [max_row, max_col] = find(local_matrix == max_value); % sometimes you get more values, so then just take the first on next lines
            r(total_corners_found) = max_row(1) + (row-1); % to account for the fact that you took a slice, you need to add 'row'
            c(total_corners_found) = max_col(1) + (col-1); % 'or col'
        else
            r(total_corners_found) = 999; % just taking a value (999) that we can filter out easily when plotting
            c(total_corners_found) = 999;
        end

        % move the filter
        if col == (size(H, 2) - neighbour_length + 1) % if we're at the end of the matrix (horizontally)
            %display('at the end of a colum')
            col = 1; % move your filter to the start of the matrix
            row = row + neighbour_length; % and move the filter down, to the next part
        elseif row == (size(H, 1) - neighbour_length + 1)
            display('done')
            break % then you've had all parts of your matrix
        else
            %display('moving to the right')
            col = col + neighbour_length; % move the filter to the next part, but stay at the same row
        end
        total_corners_found = total_corners_found + 1;
    end
end

function [] = plot_corners(im_path, r, c)
    im = imread(im_path);
    imshow(im);
    %hold on
    figure, scatter(r, c);
    %hold off
end