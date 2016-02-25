% Computer Vision Assignment 2 Part 2
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function imOut = gaussianConv(im_path, sigma_x, sigma_y, kernel_length, conv_option)  

    % set default kernel length to 11
    if nargin < 4
        kernel_length = 11;
    end
    
    % set default conv2 shape to valid
    if nargin < 5
        conv_option = 'valid';
    end
    
    % create horizontal and vertical gaussian filters
    filter_x = gaussian(sigma_x, kernel_length);
    filter_y = gaussian(sigma_y, kernel_length)';
    
    % load image
    im = imread(im_path);
    im = rgb2gray(im);
    
    % apply filter and normalize pixel values
    imOut = conv2(filter_x, filter_y, im, conv_option) / 255;
    size(im)
    size(imOut)
end