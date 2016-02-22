% Computer Vision Assignment 2 Part 2
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function imOut = gaussianConv(im_path, sigma_x, sigma_y, kernel_length)

    close all
    
    if nargin < 4
        kernel_length = 11;
    end
    
    filter_x = gaussian(sigma_x, kernel_length);
    filter_y = gaussian(sigma_y, kernel_length)';
    
    im = imread(im_path);
    im = rgb2gray(im);
    figure, imshow(im);
    
    imOut = conv2(filter_x, filter_y, im, 'valid') / 255;
    figure, imshow(imOut);
    
end