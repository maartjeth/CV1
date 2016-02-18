function imOut = gaussianConv(im_path, sigma_x, sigma_y)

    close all
    
    kernel_length = 11;
    filter_x = gaussian(sigma_x, kernel_length);
    filter_y = gaussian(sigma_y, kernel_length)';
    
    im = imread(im_path);
    im = rgb2gray(im);
    figure, imshow(im);
    
    imOut = conv2(filter_x, filter_y, im, 'valid') / 255;
    figure, imshow(imOut);
    
end