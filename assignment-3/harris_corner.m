% Computer Vision Assignment 3 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [H] = harris_corner(im_path, sigma, kernel_length)

    % steps:
    % 1) get_i
    % 2) get_elem_q
    % 3) construct_h
    
    % function copied from last week:    
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    
    [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y);
    [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y);
    H = construct_h(A, B, C);
end

function [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y)
    % smoothed derivatives of the image: convolve the first order gaussian
    % derivative, Gd, with the image along the x or y direction   
   
    % function copied from last week:    
    Ix = gaussianDer(im_path, filter_x, sigma);
    Iy = gaussianDer(im_path, filter_y, sigma);
end

function [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y)
    % A: squaring Ix and convolving it with a Gaussian (convolution comes
    % from sum over w)
    
    % B: multiply Ix and Iy and convolve it with a Gaussian
    % C: squaring Iy and convolving it with a Gaussian
    
    filter_xy = filter_y * filter_x; % need to use this, as both directions?
    A = conv2(Ix.^2, filter_xy, 'valid');
    B = conv2(Ix*Iy, filter_xy, 'valid'); % correct multiplication?
    C = conv2(Iy.^2, filter_xy, 'valid');
end

function [H] = construct_h(A, B, C)
    H = (A*B-B.^2) - 0.04*(A+C).^2; % doesn't work yet --> dimension error
end