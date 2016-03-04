% Computer Vision Assignment 2 Part 3
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [imOut, Gd] = gaussianDer4(image_path, G, sigma, dir, conv_option)
    %set default conv2 shape to valid
    if nargin < 5
        conv_option = 'valid';
    end

    % create gaussian derivative filter Gd from gaussian filter G
    % direction depending on x (=1) or y (=2)
    if dir == 1
      Gd = [1 0 -1];
    end
    
    if dir == 2               
        Gd = [1 0 -1]';
    end
    % load image
    im = imread(image_path);
    im = rgb2gray(im);
    
    % apply filter and renormalize image
    imOut = conv2(double(im), double(Gd), conv_option);
    %imOut = ( imOut - min(min(imOut))) / (max(max(imOut)) - min(min(imOut)));
end