function [imOut, Gd] = gaussianDer(image_path, G, sigma)
    
    x = 0:kernelLength-1;
    Gd = -x / sigma^2 * G;
    im = imread(image_path);
    imOut = conv2(Gd, im, 'valid') / 255;
end