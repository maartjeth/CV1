% Computer Vision Assignment 4 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

% Documentation: http://www.vlfeat.org/overview/sift.html

function image_alignment(im_path1, im_path2, N)
    
    close all;
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    
    % Steps 1, 2, 3 --> use David Lowes SIFT
    [matches, frames1, desc1, frames2, desc2] = get_matches(im1, im2);
    
    % plot the interest points and regions on the image
    % plot_images(frames1, desc1, im1);
    % plot_images(frames2, desc2, im2); 
    
    % RANSAC
    N = 1;
    P = 1;
    transformations = ransac(N, P, matches, frames1, frames2);     
end

function [matches, frames1, desc1, frames2, desc2] = get_matches(im1, im2)

    im1 = single(im1);
    im2 = single(im2);
    
    % interest points and regions around this (step 1 & 2)
    [frames1, desc1] = vl_sift(im1);
    [frames2, desc2] = vl_sift(im2);
       
    % get matches (step 3)
    [matches] = vl_ubcmatch(desc1, desc2);
    
    
    
    %size(matches)
    %matches(1,2)
    %matches(1,3)
    %d = desc1(1:20)
    %[x, y] = ismember(matches(1, 3), desc2) 
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

function [transformations] = ransac(N, P, matches, frames1, frames2)

    A = zeros(2*P, 6);
    b = zeros(2*P, 1);
    for i=1:N
        perm = randperm(size(matches, 2)); % number of columns gives number of matches found
        rand_matches = matches(:, perm(1:P));
        % i'm far from sure whether this is how you're supposed to do this
        for p=1:2:2*P % what follows can probably be coded in less lines, but just for my understanding like this for now
            
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

        x = pinv(A)*b; % now you can compute x based on 1 p point only, how to add all the others to it?
        
    end
    transformations = 0;
end


function test_stuff()
% Detection of frames and descriptors
    im1 = imread('img1.pgm');
    im2 = imread('img2.pgm');
%     figure, imshow(im1);
%     figure, imshow(im2);
    im1 = single(im1);
    im2 = single(im2);
    

     [frames, descriptors] = vl_sift(im1);
%     perm = randperm(size(frames, 2));
%     sel = perm(1:20);
%     h1 = vl_plotframe(frames(:, sel));
%     h2 = vl_plotframe(frames(:, sel));
%     h3 = vl_plotsiftdescriptor(descriptors(:,sel), frames(:, sel));
%     set(h1, 'color', 'k', 'linewidth', 3);
%     set(h2, 'color', 'y', 'linewidth', 2);
%     set(h3, 'color', 'g');
    
     [frames2, descriptors2] = vl_sift(im2);
%     perm = randperm(size(frames2, 2));
%     sel = perm(1:20);
%     h11 = vl_plotframe(frames2(:, sel));
%     h22 = vl_plotframe(frames2(:, sel));
%     h33 = vl_plotsiftdescriptor(descriptors2(:,sel), frames2(:, sel));
%     set(h11, 'color', 'k', 'linewidth', 3);
%     set(h22, 'color', 'y', 'linewidth', 2);
%     set(h33, 'color', 'g');

    % matches has two rows and columns for all matching descriptors
    [matches] = vl_ubcmatch(descriptors, descriptors2);
    matches(1, 1)
    matches(2, 1)
    
end