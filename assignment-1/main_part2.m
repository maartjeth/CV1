function [] = main_part2()
    im_name = 'bricks.jpg';
    %im_name = 'rose.jpg';
    % for colour space, choose from: 'opp_col_space', 'rgb_col_space', 'hsv_col_space' 
    colour_space = 'rgb_col_space';
    colour_spaces(im_name, colour_space);
end

% split the image into its three colour channels
function [] = colour_spaces(im_name, colour_space)
    im = imread(im_name);

    
    % get the channels for the rgb colour space
    % image has 3 dimensions, third dimension is the rgb component       
    R = im(:,:,1); % 1st component 3rd dim is red
    G = im(:,:,2); % 2nd component 3rd dim is green
    B = im(:,:,3); % 3rd component 3rd dim is blue
        
    % construct zero matrix and use this to construct the three
    % channels
    im_zeros = zeros(size(im, 1), size(im, 2));
    
    % show three rgb channels (comment out if not needed)
    %show_first_channel(im_zeros, R, 'red channel');
    %show_second_channel(im_zeros, G, 'green channel');
    %show_third_channel(im_zeros, B, 'blue channel');
    
    % get opponent colour space
    if strcmp(colour_space, 'opp_col_space')
        [o1, o2, o3] = calc_opp_col_space(R, G, B);
        show_first_channel(im_zeros, o1, 'first channel opponent colour space');
        show_second_channel(im_zeros, o2, 'second channel opponent colour space');
        show_third_channel(im_zeros, o3, 'third channel opponent colour space');
    end   
    
    % get normalised rgb colour space
    if strcmp(colour_space, 'rgb_col_space')
        [norm_r, norm_g, norm_b] = calc_rgb_col_space(R, G, B);
        imshow(norm_r)
        show_first_channel(im_zeros, norm_r, 'first channel rgb colour space');
        show_second_channel(im_zeros, norm_g, 'second channel rgb colour space'); 
        show_third_channel(im_zeros, norm_b, 'third channel rgb colour space');
    end
    
    if strcmp(colour_space, 'hsv_col_space')
        hsv_im = rgb2hsv(im);
        figure, imshow(hsv_im), title('original hsv image');
        [h, s, v] = calc_hsv_col_space(hsv_im);
        show_first_channel(im_zeros, h, 'first channel hsv colour space');
        show_first_channel(im_zeros, s, 'second channel hsv colour space');
        show_first_channel(im_zeros, v, 'third channel hsv colour space');
    end
end

% functions to construct the channel matrices and show the corresponding
% image
function [] = show_first_channel(im_zeros, comp1, im_title)
    im1 = cat(3, comp1, im_zeros, im_zeros);
    figure, imshow(im1), title(im_title);
    %imwrite(im1, im_title, 'jpg')
end

function [] = show_second_channel(im_zeros, comp2, im_title)
    im2 = cat(3, im_zeros, comp2, im_zeros);
    figure, imshow(im2), title(im_title);
    colormap winter
end

function [] = show_third_channel(im_zeros, comp3, im_title)
    im3 = cat(3, im_zeros, im_zeros, comp3);
    figure, imshow(im3, hsv), title(im_title);
    colormap winter
end

% calculate the oponent colour space, based on calculated rgb values
% formula given in the assignment
function [o1, o2, o3] = calc_opp_col_space(R, G, B)
    o1 = double(R-G) / sqrt(2);
    o2 = double(R+G-2*B) / sqrt(6);
    o3 = double(R+G+B) / sqrt(3); 
end

% calculate the rgb colour space
function [r, g, b] = calc_rgb_col_space(R, G, B)
    r = double(R) ./ double(R+G+B);
    g = double(G) ./ double(R+G+B);
    b = double(B) ./ double(R+G+B);
end

% calculte the hsv colour channels
% NOTE: it's different but all reddish????
function [h, s, v] = calc_hsv_col_space(hsv_im)
    h = hsv_im(:,:,1);
    s = hsv_im(:,:,2);
    v = hsv_im(:,:,3);
end
