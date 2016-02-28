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
    display('getting corners')
    [r, c] = get_corners(H, neighbour_length, threshold);
    display('r')
    r
    display('c')
    c
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
    
    A = conv2(Ix.^2, filter_x, 'same');
    B = conv2(Ix, filter_x, 'same') .* conv2(Iy, filter_y, 'same');
    C = conv2(Iy.^2, filter_y, 'same'); 
    
    %size(A)
    %size(B)
    %size(C)    
end

function [H] = construct_h(A, B, C, k)
    H = (A.*B-B.^2) - k*(A+C).^2;
end

function [r, c] = get_corners(H, neighbour_length, threshold)    

    import vision.*

    %display('local max')
    %imregionalmax(H, neighbour_length)
    
    h = vision.localMaximaFinder;
    
    r = 0;
    c = 0;
    
    %A = [1 2 3 3 6 6 6 6; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 3 6 6 5 6 6 6 6; 2 3 4 4 6 6 6 6 ; 0 0 0 0 0 0 0 0 ;0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0]
    %I2 = imhmax(A,2)
    %imregionalmax(A,4)

    %end
    
    %row = 1;
    %col = 1;
    %number_corners = size(H, 1) / neighbour_length;
    %r = zeros(number_corners, 1);
    %c = zeros(number_corners, 1);
    %total_corners_found = 1;
    
    %while row <= size(H, 1) - neighbour_length && col <= size(H, 1) - neighbour_length
    %    local_max = threshold;
    %    local_matrix = H(row:row+neighbour_length, col:col+neighbour_length); % slice part of matrix
    %    max_value = max(local_matrix(:));
    %%    [max_row max_col] = find(local_matrix == max_value);
    %    r(total_corners_found) = max_row;
    %    c(total_corners_found) = max_col;
        
        %for row = 1:neighbour_length % loop over rows
        %    for col = 1:neighbour_length % loop over cols
        %        if H(row, col) > local_max % find local maxima
        %            local_max = H(row, col);
        %            r(total_corners_found) = row; % add to r 
        %            c(total_corners_found) = col; % add to c
        %        end                
        %    end
        %end
        %row = row + neighbour_length;
        %col = col + neighbour_length; 
    %    total_
end