% Computer Vision Assignment 4
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function do_transform_builtin(M, t, im_path)

    im = imread(im_path);
    
    % make transformation matrix
    mat = [M, zeros(2,1); t', 1];
    
    % let matlab do the rest
    real_trans_mat = maketform('affine', mat);
    transformation = imtransform(im, real_trans_mat);
    figure, imshow(transformation);
end