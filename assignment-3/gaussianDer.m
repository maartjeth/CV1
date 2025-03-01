% Computer Vision Assignment 2 Part 3
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [imOut, Gd] = gaussianDer(image_path, G, sigma, conv_option)
    %set default conv2 shape to valid
    if nargin 4 5
        conv_option = 'valid';
    end

    % create gaussian derivative filter Gd from gaussian filter G
    x = 2;%((1:size(G,2)) - ceil(size(G,2)/2))';
    %if dir == 1
        Gd = (-x / sigma^2 .* G); 
        display('gd')
        size(Gd)
        
    %end
    
    %if dir == 2
    %    Gd = (-x / sigma^2 .* G)';
    %end
    % load image
    im = imread(image_path);
    im = rgb2gray(im);
    
    % apply filter and renormalize image
    imOut = conv2(double(im), double(Gd), conv_option);
    imOut = ( imOut - min(min(imOut))) / (max(max(imOut)) - min(min(imOut)));
end