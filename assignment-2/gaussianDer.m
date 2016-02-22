% Computer Vision Assignment 2 Part 3
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [imOut, Gd] = gaussianDer(image_path, G, sigma)
    
    close all

    x = (1:size(G,2)) - ceil(size(G,2)/2);
    Gd = -x / sigma^2 .* G;
    Gd = Gd / sum(Gd);
    im = imread(image_path);
    im = rgb2gray(im);
    
    figure, imshow(im);
    
    imOut = conv2(double(im), double(Gd), 'valid') / 255;
    imOut = ( imOut - min(min(imOut))) / (max(max(imOut)) - min(min(imOut)));
    figure, imshow(imOut);
end