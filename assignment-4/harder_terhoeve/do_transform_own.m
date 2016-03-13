% Computer Vision Assignment 4
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function do_transform_own(M, t, im_path1)
    im1 = imread(im_path1);
    
    % estimate dimensions of new image by transforming the corners of the old
    corners = [1,1 ; 1, size(im1, 2) ; size(im1, 1), 1 ; size(im1, 1), size(im1, 2)]';
    corner_transforms = round(M * corners + repmat(t,1,size(corners,2)));
    min_rows = min(corner_transforms(1,:));
    max_rows = max(corner_transforms(1,:));
    min_cols = min(corner_transforms(2,:));
    max_cols = max(corner_transforms(2,:));

    % make frame for new image
    target_mat = zeros(max_rows-min_rows, max_cols-min_cols);
   
    for x = 1:size(target_mat,1)
        for y = 1:size(target_mat,2)
           
            res = (M \ ([ x + min_rows-1; y + min_cols-1 ] - t));

            row = round(res(1));
            col = round(res(2));
            if row > 0 && col > 0 && row <= size(im1,1) && col <= size(im1,2)
                target_mat(x,y) = im1(row, col);
            end
        end
    end   
    figure, imshow(target_mat/255);
end
