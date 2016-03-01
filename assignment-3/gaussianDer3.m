% Computer Vision Assignment 2 Part 3
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [imOut, Gd] = gaussianDer3(region, G, sigma, dir, conv_option)
    %set default conv2 shape to valid
    if nargin < 5
        conv_option = 'valid';
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
    
    % apply filter and renormalize image
    imOut = conv2(region, double(Gd), conv_option);
    imOut = ( imOut - min(min(imOut))) / (max(max(imOut)) - min(min(imOut)));
end