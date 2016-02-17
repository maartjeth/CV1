
function color_spaces(im_source, color_space, fancy)
    close all
    if nargin < 3 % default to fancy plots
        fancy = true;
    end
    
    switch color_space
        case 'opponent'
            im = opponent(im_source);
            if fancy
                split_opponent(im);
            else
                split_grayscale(im);
            end
        case 'norm_rgb'
            im = norm_rgb(im_source);
            if fancy
                split_norm_rgb(im);
            else
                split_grayscale(im);
            end
        case 'hsv'
            im = rgb2hsv(imread(im_source));
            if fancy
                split_hsv(im);
            else
                split_grayscale(im);
            end
        otherwise
            im = imread(im_source);
            split_grayscale(im);
    end
end

function im_mat = opponent(im_source)
    im = imread(im_source);
    
    rval = im(:,:,1);
    gval = im(:,:,2);
    bval = im(:,:,3);
    
    im_mat = zeros(size(im));
    im_mat(:,:,1) = (double(rval) - double(gval)) ./ sqrt(2);
    im_mat(:,:,2) = (double(rval) + double(gval) - double(2 * bval)) ./ sqrt(6);
    im_mat(:,:,3) = (double(rval) + double(gval) + double(bval)) ./ sqrt(3);
    
end

function im_mat = norm_rgb(im_source)
    im = imread(im_source);
    
    im_abs = sum(im, 3);
    
    im_mat = zeros(size(im));
    for c = 1:3        
        im_mat(:,:,c) = double(im(:,:,c))./double(im_abs);
    end
end

function split_grayscale(im_mat)
    im_vals = im_mat(:,:,:);
    
    % plot dim 1
    figure
    imshow(mat2gray(reshape(im_vals(:,:,1), size(im_vals, 1), size(im_vals, 2))))
    
    % plot dim 2
    figure
    imshow(mat2gray(reshape(im_vals(:,:,2), size(im_vals, 1), size(im_vals, 2))))
    
    % plot dim 3
    figure
    imshow(mat2gray(reshape(im_vals(:,:,3), size(im_vals, 1), size(im_vals, 2))))
end

function split_norm_rgb(im)
    im_vals = im(:,:,:);
    
    figure % plot normalized image
    imshow(im);
    
    figure % plot normalized red values
    im(:,:,2) = 0;
    im(:,:,3) = 0;
    imshow(im);
    
    figure % plot normalized green values
    im(:,:,1) = 0;
    im(:,:,2) = im_vals(:,:,2);
    imshow(im); 
    
    figure % plot normalized blue values
    im(:,:,2) = 0;
    im(:,:,3) = im_vals(:,:,3);    
    imshow(im);
end

function split_hsv(im)
    im_vals = im(:,:,:);
    
    figure % plot image (just to be sure ;) )
    imshow(hsv2rgb(im));
    
    figure % plot hue
    im(:,:,2) = 1;
    im(:,:,3) = 1;
    imshow(hsv2rgb(im));
    
    figure % plot saturation as greyscale
    imshow(mat2gray(reshape(im_vals(:,:,2), size(im_vals, 1), size(im_vals, 2))))
    
    figure % plot saturation as greyscale
    im(:,:,2) = 0;
    im(:,:,3) = im_vals(:,:,3);    
    imshow(hsv2rgb(im));
    
end

function split_opponent(im)

    ropp = im(:,:,1);
    gopp = im(:,:,2);
    bopp = im(:,:,3);
    
    figure % reconstructed original  (slightly off due to rescaling)
    rval = sqrt(2) * ropp + sqrt(6) * gopp / 3 + sqrt(3) * bopp / 2;
    gval = rval - sqrt(2) * ropp;
    bval = (sqrt(3) * bopp - sqrt(6) * gopp) / 3;
    
    im(:,:,1) = rval;
    im(:,:,2) = gval;
    im(:,:,3) = bval;
    
    min_im = double(min(min(min(im))));
    max_im = double(max(max(max(im))));
    im = (im - min_im) ./ (max_im - min_im);  
    imshow(im);
    

    figure % green-red value
    rval = sqrt(2) * ropp;
    gval = rval - sqrt(2) * ropp;
    bval = 0;
    
    im(:,:,1) = rval;
    im(:,:,2) = gval;
    im(:,:,3) = bval;
    im = (im - min_im) ./ (max_im - min_im);    
    imshow(im);
    
    figure % blue-yellow value
    rval = sqrt(6) * gopp / 3;
    gval = rval;
    bval = (-sqrt(6) * gopp)./3;
    
    im(:,:,1) = rval;
    im(:,:,2) = gval;
    im(:,:,3) = bval;
    im = (im - min_im) ./ (max_im - min_im);    
    imshow(im);
    
    figure % luminosity value
    rval = sqrt(3) * bopp / 2;
    gval = rval;
    bval = (sqrt(3) * bopp)./3;
    
    im(:,:,1) = rval;
    im(:,:,2) = gval;
    im(:,:,3) = bval;
    im = (im - min_im) ./ (max_im - min_im);  
    imshow(im);
    
end