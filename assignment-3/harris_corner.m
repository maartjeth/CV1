% Computer Vision Assignment 3 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

% Best setting I figured:
% k = 0.05

function [r, c] = harris_corner(im_path, sigma, kernel_length, k, neighbour_length, threshold, verbose)
    
    close all
    % steps:
    % 1) get_i
    % 2) get_elem_q
    % 3) construct_h
    
    if nargin < 7
        verbose = true;
    end
    
    % function copied from last week:    
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    
    %display('getting i')
    [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y);
    %display('getting a b c')
    [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y);
    %display('getting h')
    H = construct_h(A, B, C, k);
    %size(H)
    %display('getting corners')
    [r, c] = get_corners2(H, neighbour_length, threshold);
    %display('r')
    %
    %display('c')
    %
    
    if verbose
        plot_corners(im_path, r, c);
    end
end

function [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y)
    % smoothed derivatives of the image: convolve the first order gaussian
    % derivative, Gd, with the image along the x or y direction   
   
    % function copied from last week, but slightly modified to get the two different directions  
    % use same to get the same dimensions
    Ix = gaussianDer2(im_path, filter_x, sigma, 1, 'same'); % horizontal edge filter
    Ix = ( Ix - min(min(Ix))) / (max(max(Ix)) - min(min(Ix)));
    
    Iy = gaussianDer2(im_path, filter_y, sigma, 2, 'same'); % vertical edge filter
    Iy = ( Iy - min(min(Iy))) / (max(max(Iy)) - min(min(Iy)));
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
    
    %% think it should be xy in each case
    A = conv2(Ix.^2, filter_x, 'same');
    %B = conv2(Ix, filter_x, 'same') .* conv2(Iy, filter_y, 'same');
    B = conv2(Iy.*Ix, filter_xy, 'same');
    C = conv2(Iy.^2, filter_y, 'same'); 
    
    %size(A)
    %size(B)
    %size(C)    
end

function [H] = construct_h(A, B, C, k)
    H = (A.*C-B.^2) - k*(A+C).^2;
    %figure, imshow(H*255); % had to normalise this to get results --> deleting it gives black picture
    %size(H)
    %max(max(H))
end

function [r, c] = get_corners2(H, neighbour_length, threshold)   
    M = zeros(size(H));
    for row = 1:size(H, 1)
        for col = 1:size(H, 2)
            if H(row, col) >= threshold
                rmin = max(1, row - neighbour_length);
                cmin = max(1, col - neighbour_length);
                rmax = min(size(H, 1), row + neighbour_length);
                cmax = min(size(H, 2), col + neighbour_length);

                window = H(rmin:rmax, cmin:cmax);

                if max(max(window)) == H(row, col) 
                    M(row,col) = 255;
                end
            end
        end
    end
    %figure, imshow(M)
    [r, c] = find(M);
end

% NOTE: I guess there's still something wrong in this function as it
% doesn't really plot the maxima correctly
function [r, c] = get_corners(H, neighbour_length, threshold)    
    display('getting corners')
    row = 1;
    col = 1;
    number_corners = floor((size(H, 1) / neighbour_length) * (size(H, 2) / neighbour_length)); 
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
            r(total_corners_found) = NaN; 
            c(total_corners_found) = NaN;
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
    figure, imshow(im);
    hold on
    %% had to switch dimensions here. not totally clear why atm
    scatter(c, r); 
    hold off
end