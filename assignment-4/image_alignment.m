% Computer Vision Assignment 4
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [M, t] = image_alignment(im_path1, im_path2, N, P, showplots)
    
    if nargin < 4
        P = 10;
    end
    
    if nargin < 5 
        showplots = false;
    end
    
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    
    if size(im1,3) > 1
        im1 = rgb2gray(im1);
        im2 = rgb2gray(im2);
    end
    
    % Steps 1, 2, 3 --> use David Lowes SIFT
    [matches, frames1, desc1, frames2, desc2] = get_matches(im1, im2);
    
    % plot the interest points and regions on the image
    if showplots
        plot_images(frames1, desc1, im1);
        plot_images(frames2, desc2, im2); 
    end
    
    % RANSAC
    [M, t] = ransac(N, P, matches, frames1, frames2, im1, im2, showplots);     
end

function [matches, frames1, desc1, frames2, desc2] = get_matches(im1, im2)

    im1 = single(im1);
    im2 = single(im2);
    
    % interest points and regions around this (step 1 & 2)
    [frames1, desc1] = vl_sift(im1);
    [frames2, desc2] = vl_sift(im2);
          
    % get matches (step 3)
    [matches] = vl_ubcmatch(desc1, desc2);   
end

function plot_images(frames, desc, im)

    figure, imshow(im);
    
    % Source: http://www.vlfeat.org/overview/sift.html
    perm = randperm(size(frames, 2));
    sel = perm(1:50);
    h1 = vl_plotframe(frames(:, sel));
    h2 = vl_plotframe(frames(:, sel));
    h3 = vl_plotsiftdescriptor(desc(:,sel), frames(:, sel));
    set(h1, 'color', 'k', 'linewidth', 3);
    set(h2, 'color', 'y', 'linewidth', 2);
    set(h3, 'color', 'g');    
end

function [M, t] = ransac(N, P, matches, frames1, frames2, im1, im2, showplots)

    no_inliers = 0;
    for i=1:N
        A = zeros(2*P, 6); % resetting matrices in the beginning of the loop
        b = zeros(2*P, 1);
        perm = randperm(size(matches, 2)); % number of columns gives number of matches found
        rand_matches = matches(:, perm(1:P));
        for p=1:2:2*P 
            
            match_im1 = rand_matches(1, ceil(p/2)); % first get the indices of the matching pairs, ceil because you have intervals of 2 in the loop
            match_im2 = rand_matches(2, ceil(p/2));
            
            frame_im1 = frames1(:, match_im1); % get all values for this particular frame
            frame_im2 = frames2(:, match_im2); 
                        
            x1 = frame_im1(1); % get x and y values for both frames
            y1 = frame_im1(2);            
            x2 = frame_im2(1);
            y2 = frame_im2(2);
                     
            A(p, :) = [x1; y1; 0; 0; 1; 0]; % add to A matrix
            A(p+1, :) = [0; 0; x1; y1; 0; 1];
            
            b(p) = x2; % add to b matrix
            b(p+1) = y2;
        end

        trans_mat = pinv(A)*b; 
        
        % transform locations
        M = reshape(trans_mat(1:4), [2,2])';
        t = trans_mat(5:6);
        
        T1 = frames1(1:2, matches(1, :));   
        T2 = frames2(1:2, matches(2, :));
        
        new_T = M * T1(1:2, :) + repmat(t,1,size(T1,2)); % this is the transformed image
                 
        % plot lines between transformation
        % source: http://inside.mines.edu/~whoff/courses/EENG512/lectures/12-SIFT-examples.pdf
        if showplots
            figure, imshow([im1, im2], []);
            add_cols = size(im1, 2);
            num_samples = 50; % how many lines do you want to show --> otherwise it's so messy with lines
            sample_idx = datasample(1:size(T1,2), num_samples, 2, 'Replace', false); 
            line([T1(1,sample_idx);new_T(1,sample_idx)+add_cols], [T1(2,sample_idx);new_T(2,sample_idx)]);
        end
        
        % compute in- and outliers and keep them if needed        
        diff = sqrt( (T2(1,:) - new_T(1,:)).^2 + (T2(2,:) - new_T(2,:)).^2 );
        inliers = diff(diff < 10 & diff > -10);
        
        if size(inliers, 2) > no_inliers
            best_inliers = inliers;
            no_inliers = size(inliers, 2);
            best_trans_mat = trans_mat;
        end  
    end  
    
    M = reshape(best_trans_mat(1:4), [2,2]);
    t = best_trans_mat(5:6);
end