function [] = main_part2()
    im_name = 'bricks.jpg';
    colour_space = 'rgb';  % choose from different colour spaces  
    colour_spaces(im_name, colour_space);
end

% split the image into its three colour channels
function [] = colour_spaces(im_name, colour_space)
    im = imread(im_name);
    
    % get the channels for the rgb colour space
    % image has 3 dimensions, third dimension is the rgb component
    if strcmp(colour_space, 'rgb')
        red = im(:,:,1); % 1st component 3rd dim is red
        green = im(:,:,2); % 2nd component 3rd dim is green
        blue = im(:,:,3); % 3rd component 3rd dim is blue
        
        % construct zero matrix and use this to construct the three
        % channels
        im_zeros = zeros(size(im, 1), size(im, 2));
        im_red = cat(3, red, im_zeros, im_zeros);
        im_green = cat(3, im_zeros, green, im_zeros);
        im_blue = cat(3, im_zeros, im_zeros, blue);
        
        figure, imshow(im_red), title('red channel')
        figure, imshow(im_green), title('green channel')
        figure, imshow(im_blue), title('blue channel')
    end
end