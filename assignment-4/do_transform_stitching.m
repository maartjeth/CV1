% image stitching: http://www.mathworks.com/matlabcentral/answers/108769-how-to-stitch-two-images-with-overlapped-area

function do_transform_stitching(M, t, im_path1, im_path2)
    
    im1 = imread(im_path1);
    im2 = imread(im_path2);

    t = flipud(t); % WHYYYYYY???
   
    corners = [1,1 ; 1, size(im1, 2) ; size(im1, 1), 1 ; size(im1, 1), size(im1, 2)]';
    corner_transforms = round(M * corners + repmat(t,1,size(corners,2)));
    
    min_rows1 = min(corner_transforms(1,:));
    max_rows1 = max(corner_transforms(1,:));
    min_cols1 = min(corner_transforms(2,:));
    max_cols1 = max(corner_transforms(2,:));

    max_rows2 = size(im2,1);
    max_cols2 = size(im2,2);
   
    offset_rows = - min(0, min_rows1);
    offset_cols = - min(0, min_cols1);
   
    t_rows = max(max_rows1, max_rows2)-min(min_rows1, 1);
    t_cols = max(max_cols1, max_cols2)-min(min_cols1, 1);
   
    target_mat = zeros(t_rows, t_cols, 3);
    
    target_mat((1:size(im2,1))+offset_rows, (1:size(im2,2))+offset_cols, :) = im2;
    
    for x = 1:size(target_mat,1)
        for y = 1:size(target_mat,2)
           
            res = (M \ ([ x - offset_rows-1; y - offset_cols-1 ] - t));
            row = round(res(1));
            col = round(res(2));
            if row > 0 && col > 0 && row <= size(im1,1) && col <= size(im1,2)
                target_mat(x,y, :) = im1(row, col, :);
            end
        end
    end   
    
    figure, imshow(target_mat/255);
end
