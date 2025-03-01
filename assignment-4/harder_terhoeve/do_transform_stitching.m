% Computer Vision Assignment 4
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function do_transform_stitching(M, t, im_path1, im_path2)
    
    im1 = imread(im_path1);
    im2 = imread(im_path2);

    t = flipud(t); % not sure why, but the dimensions are swapped
   
    % estimate dimensions of new image by transforming the corners of the old
    corners = [1,1 ; 1, size(im1, 2) ; size(im1, 1), 1 ; size(im1, 1), size(im1, 2)]';
    corner_transforms = round(M * corners + repmat(t,1,size(corners,2)));
    
    min_rows1 = min(corner_transforms(1,:));
    max_rows1 = max(corner_transforms(1,:));
    min_cols1 = min(corner_transforms(2,:));
    max_cols1 = max(corner_transforms(2,:));
    
    max_rows2 = size(im2,1);
    max_cols2 = size(im2,2);
    
    %compute offset for non-transformed im2
    offset_rows = - min(0, min_rows1);
    offset_cols = - min(0, min_cols1);
   
    t_rows = max(max_rows1, max_rows2)-min(min_rows1, 1);
    t_cols = max(max_cols1, max_cols2)-min(min_cols1, 1);
    
    % make frame for new image
    target_mat = zeros(t_rows, t_cols, 3);
    
    % map image 2 to the new image
    target_mat((1:size(im2,1))+offset_rows, (1:size(im2,2))+offset_cols, :) = im2;
    
    % map transformed image 1 to the new image
    for x = 1:size(target_mat,1)
        for y = 1:size(target_mat,2)
            % try to map each pixel in the target frame back to im1
            res = (M \ ([ x - offset_rows-1; y - offset_cols-1 ] - t));
            row = round(res(1));
            col = round(res(2));
            % if mapped within bounds of im1, retrieve closest pixel's value
            if row > 0 && col > 0 && row <= size(im1,1) && col <= size(im1,2)
                target_mat(x,y, :) = im1(row, col, :);
            end
        end
    end   
    
    figure, imshow(target_mat/255);
end
