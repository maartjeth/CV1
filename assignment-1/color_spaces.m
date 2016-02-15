function color_spaces(im_source, color_space)

    switch color_space
        case 'opponent'
            im = opponent(im_source);
        case 'norm_rgb'
            im = norm_rgb(im_source);
        case 'hsv'
            im = rgb2hsv(imread(im_source));
        otherwise
            im = imread(im_source);
    end
    imshow(im)
    split(im)
end


function im = opponent(im_source)
    im = imread(im_source);
    im_vals = im(:,:,:);
    im(:,:,1) = double(im_vals(:,:,1) - im_vals(:,:,2)) ./ 2^0.5;
    im(:,:,2) = double(im_vals(:,:,1) + im_vals(:,:,2) - 2 .* im_vals(:,:,3)) ./ 6^0.5;
    im(:,:,3) = double(im_vals(:,:,1) + im_vals(:,:,2) + im_vals(:,:,3)) ./ 3^0.5;
end


function im = norm_rgb(im_source)
    im = imread(im_source);
    im_abs = sum(im, 3);
    for c = 1:3        
        
        im(:,:,c) = round(255 * double(im(:,:,c))./double(im_abs));
    end
end


function split(im)
    im_vals = im(:,:,:);
    
    figure
    im(:,:,2) = 0;
    im(:,:,3) = 0;
    imshow(im);
    
    figure
    im(:,:,1) = 0;
    im(:,:,2) = im_vals(:,:,2);
    imshow(im); 
    
    figure
    im(:,:,2) = 0;
    im(:,:,3) = im_vals(:,:,3);    
    imshow(im);
    
end