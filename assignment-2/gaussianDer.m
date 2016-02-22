function [imOut, Gd] = gaussianDer(image_path, G, sigma)
    close all
    x = (1:size(G,2)) - ceil(size(G,2)/2);
    %size(x)
    %size(G)
    Gd = -x / sigma^2 .* G;
    Gd = Gd / sum(Gd);
    im = imread(image_path);
    min(min(im))
    im = im ;
    im = rgb2gray(im);
    figure, imshow(im);
    imOut = conv2(double(im), double(Gd), 'valid');
    imOut = ( imOut - min(min(imOut))) / (max(max(imOut)) - min(min(imOut)));
    figure, imshow(imOut);
end