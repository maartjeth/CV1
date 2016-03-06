% Computer Vision Assignment 3 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

% Best setting I figured:
% k = 0.05

function [r, c, H] = harris_corner(im_path, sigma, kernel_length, k, neighbour_length, threshold, verbose)
        
    if nargin < 7
        verbose = true;
    end    
  
    filter_x = gaussian(sigma, kernel_length);
    filter_y = gaussian(sigma, kernel_length)';
    
    [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y);
    [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y);
    H = construct_h(A, B, C, k);
    [r, c] = get_corners(H, neighbour_length, threshold);
    
    if verbose
        figure, imshow(Ix);
        figure, imshow(Iy);
        figure, imshow(H*255);
        plot_corners(im_path, r, c);
    end
end

function [Ix, Iy] = get_i(im_path, sigma, filter_x, filter_y)

    Ix = gaussianDer2(im_path, filter_x, sigma, 1, 'same'); % horizontal edge filter
    Ix = ( Ix - min(min(Ix))) / (max(max(Ix)) - min(min(Ix)));
    
    Iy = gaussianDer2(im_path, filter_y, sigma, 2, 'same'); % vertical edge filter
    Iy = ( Iy - min(min(Iy))) / (max(max(Iy)) - min(min(Iy)));
    % show the images (part of the assignment, don't delete)
 end

function [A, B, C] = get_elem_q(Ix, Iy, filter_x, filter_y)
   
    filter_xy = filter_y * filter_x;
    
    % think it should be xy in each case
    A = conv2(Ix.^2, filter_x, 'same');
    B = conv2(Iy.*Ix, filter_xy, 'same');
    C = conv2(Iy.^2, filter_y, 'same');  
end

function [H] = construct_h(A, B, C, k)
    H = (A.*C-B.^2) - k*(A+C).^2;
end

function [r, c] = get_corners(H, neighbour_length, threshold) 
    % look at neighbourhood for each pixel
    M = zeros(size(H));
    for row = 5:(size(H, 1)-5)  % introduced by fiat!
        for col = 5:(size(H, 2)-5)
            % only examine pixels above threshold
            if H(row, col) >= threshold
                rmin = max(1, row - neighbour_length);
                cmin = max(1, col - neighbour_length);
                rmax = min(size(H, 1), row + neighbour_length);
                cmax = min(size(H, 2), col + neighbour_length);

                window = H(rmin:rmax, cmin:cmax);

                % if pixel is max in neighbourhood, set as corner
                if max(max(window)) == H(row, col) 
                    M(row,col) = 255;
                end
            end
        end
    end
    [r, c] = find(M);
end

function [] = plot_corners(im_path, r, c)    
    im = imread(im_path);
    figure, imshow(im);
    hold on
    scatter(c, r, 'cyan', '+'); 
    hold off
end