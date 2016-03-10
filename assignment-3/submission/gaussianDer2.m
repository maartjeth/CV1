% Computer Vision Assignment 3 - Helper function
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [imOut, Gd] = gaussianDer2(image_path, G, sigma, dir, conv_option)
    
%set default conv2 shape to valid
    if nargin < 5
        conv_option = 'same';
    end

    % create gaussian derivative filter Gd from gaussian filter G
    % direction depending on x (=1) or y (=2)
    if dir == 1
      x = ((1:size(G,2)) - ceil(size(G,2)/2));       
      Gd = (-x / sigma^2 .* G);         
    end
    
    if dir == 2               
        y = ((1:size(G,1)) - ceil(size(G,1)/2))';
        Gd = (-y / sigma^2 .* G);  
    end
    
    % load image
    im = imread(image_path);
    im = rgb2gray(im);
    
    % apply filter
    imOut = conv2(double(im), double(Gd), conv_option);
end