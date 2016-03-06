% Computer Vision Assignment 4 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

% Documentation: http://www.vlfeat.org/overview/sift.html

function image_alignment(im_path1, im_path2)
    
    close all;
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    
    % Steps 1, 2, 3 --> use David Lowes SIFT
    matches = get_matches(im1, im2);
    
    % RANSAC
    % transformations = ransac(matches);       
end

function [matches] = get_matches(im1, im2);

    im1_s = single(im1);
    im2_s = single(im2);
    
    % interest points and regions around this (step 1 & 2)
    [frames1, desc1] = vl_sift(im1_s);
    [frames2, desc2] = vl_sift(im2_s);
    
    % get matches (step 3)
    [matches] = vl_ubcmatch(desc1, desc2);
    
    % plot the interest points and regions on the image
    plot_images(frames1, desc1, im1);
    plot_images(frames2, desc2, im2);   
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