% Computer Vision Assignment 3 - Helper function
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [imOut] = gradient_filter(image_path, dir, conv_option)
    
    %set default conv2 shape to valid
    if nargin < 5
        conv_option = 'same';
    end

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
end