% Computer Vision Assignment 4 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

% Documentation: http://www.vlfeat.org/overview/sift.html
% Maartje: in maartje/vlfeat-0.9.20-bin/vlfeat-0.9.20 run: run('toolbox/vl_setup')

function image_alignment(im_path1, im_path2, N)
    
    close all;
    im1 = imread(im_path1);
    im2 = imread(im_path2);
    
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
    
    % Steps 1, 2, 3 --> use David Lowes SIFT
    [matches, frames1, desc1, frames2, desc2] = get_matches(im1, im2);
    
    % plot the interest points and regions on the image
    % plot_images(frames1, desc1, im1);
    % plot_images(frames2, desc2, im2); 
    
    % RANSAC
    P = 10;
    transformations = ransac(N, P, matches, frames1, frames2, im1, im2);     
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

function [transformations] = ransac(N, P, matches, frames1, frames2, im1, im2)

    % for P = 10, the transformations seem to work quite well?
    N = 1000;
    no_inliers = 0;
    for i=1:N
        A = zeros(2*P, 6); % resetting matrices in the beginning of the loop
        b = zeros(2*P, 1);
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

        trans_mat = pinv(A)*b; % now you can compute x based on 1 p point only, how to add all the others to it?
        
        % transform locations
        M = reshape(trans_mat(1:4), [2,2])';
        t = trans_mat(5:6);
        
        T1 = frames1(1:2, matches(1, :));   
        T2 = frames2(1:2, matches(2, :));
        % this is a bit rediculous..
        res1 = M * T1(1:2, :);
        res2 = res1(1, :) + t(1);
        res3 = res1(2, :) + t(2);        
        new_T = [res2; res3]; % this is the transformed image (naming is a bit odd..)
         
        
        % plot lines between transformation --> this is still between
        % matchigng points
        % source: http://inside.mines.edu/~whoff/courses/EENG512/lectures/12-SIFT-examples.pdf
        %figure, imshow([im1, im2], []);
        add_cols = size(im1, 2);
        sample = 10; % how many lines do you want to show --> otherwise it's so messy with lines
        %line([T1(1,1:sample);new_T(1,1:sample)+add_cols], [T1(2,1:sample);new_T(2,1:sample)]);
       
        % compute in- and outliers and keep them if needed        
        diff = sqrt( (T2(1,:) - new_T(1,:)).^2 + (T2(2,:) - new_T(2,:)).^2 );
        inliers = diff(diff < 10 & diff > -10);
        
        if size(inliers, 2) > no_inliers
            best_inliers = inliers; % why do you need these?
            no_inliers = size(inliers, 2);
            best_trans_mat = trans_mat;
        end  
        
        
    end  
    
    % TRANSFORM IMAGE, USING YOUR OWN NEAREST-NEIGHBOUR IMPLEMENTATION
    % I guess that is because now you have pixel values that might not
    % really exist. So, you need to go from a continuous to a discrete space
    % and that's what you're gonna use nearest neighbours for. But for now
    % first with the imtransform only.    

     M = reshape(best_trans_mat(1:4), [2,2]);
     t = best_trans_mat(5:6);
     
     %do_transform_matlab(M, t, im1, im2);
     %do_transform_homebrew(M, t, im1);
     do_transform_stitching(M, t, im1, im2);
    transformations = 0;
end

function do_transform_matlab(M, t, im1, im2)
     mat = zeros(3, 3);
     mat(1:2, 1:2) = M;
     mat(3, 1:2) = t;
     mat(3, 3) = 1;
     
     real_trans_mat = maketform('affine', mat);
     transformation = imtransform(im1, real_trans_mat);
     figure, imshow(im2);
     figure, imshow(transformation);
end

function do_transform_homebrew(M, t, im1)
   size([1,1 ; 1, size(im1, 2) ; size(im1, 1), 1 ; size(im1, 1), size(im1, 2)])
   res1 = M * [1,1 ; 1, size(im1, 2) ; size(im1, 1), 1 ; size(im1, 1), size(im1, 2)]';
   res2 = round(res1(1, :) + t(1));
   res3 = round(res1(2, :) + t(2));
   min_rows = min(res2);
   max_rows = max(res2);
   min_cols = min(res3);
   max_cols = max(res3);

   target_mat = zeros(max_rows-min_rows, max_cols-min_cols);
   for x = 1:size(im1,1)
       for y = 1:size(im1,2)
           
            res1 = M * [x;y];
            new_x = res1(1, :) + t(1);
            new_y = res1(2, :) + t(2);
            target_mat(round(new_x-min_rows+1), round(new_y-min_cols+1)) = im1(x,y);
       end
   end
   
   [row, col] = find(target_mat == 0);
   pos = [row, col];
   for idx = 1:size(pos,1)
       row = pos(idx,1);
       col = pos(idx,2);
       
       if  row > 1 && col > 1 && row < size(target_mat,1) && ...
               col < size(target_mat,2)
           window = target_mat(row-1:row+1, col-1:col+1);
           if sum(window == 0) < 4
            target_mat(row,col) = sum(window(:))/8.0;
           end
       end
           
   end
   
   
   figure, imshow(target_mat/255);
end

% image stitching: http://www.mathworks.com/matlabcentral/answers/108769-how-to-stitch-two-images-with-overlapped-area


function do_transform_stitching(M, t, im1, im2)
   t = flipud(t);
   res1 = M * [1,1 ; 1, size(im1, 2) ; size(im1, 1), 1 ; size(im1, 1), size(im1, 2)]';
   res2 = round(res1(1, :) + t(1));
   res3 = round(res1(2, :) + t(2));
   min_rows1 = min(res2);
   max_rows1 = max(res2);
   min_cols1 = min(res3);
   max_cols1 = max(res3);

   max_rows2 = size(im2,1);
   max_cols2 = size(im2,2);
   
   offset_rows = - min(0, min_rows1);
   offset_cols = - min(0, min_cols1);
   
   t_rows = max(max_rows1, max_rows2)-min(min_rows1, 1);
   t_cols = max(max_cols1, max_cols2)-min(min_cols1, 1);
   
   target_mat = zeros(t_rows, t_cols);
   
   
   
   for x = 1:size(im1,1)
       for y = 1:size(im1,2)
           
            res1 = M * [x;y];
            new_x = res1(1, :) + t(1);
            new_y = res1(2, :) + t(2);
%             offset_rows
%             offset_cols
            target_mat(offset_rows +1+ round(new_x), offset_cols +1+ round(new_y)) = im1(x,y);
       end
   end
   
   [row, col] = find(target_mat == 0);
   pos = [row, col];
   for idx = 1:size(pos,1)
       row = pos(idx,1);
       col = pos(idx,2);
       
       if  row > 1 && col > 1 && row < size(target_mat,1) && ...
               col < size(target_mat,2)
           window = target_mat(row-1:row+1, col-1:col+1);
           if sum(window == 0) < 4
            target_mat(row,col) = (sum(window(:))-window(2,2))/8.0;
           end
       end
           
   end
   
   target_mat((1:size(im2,1))+offset_rows, (1:size(im2,2))+offset_cols) = im2;
   
   figure, imshow(target_mat/255);
end
