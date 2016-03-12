function do_transform_builtin(M, t, im_path)

    im = imread(im_path);
    
    mat = [M, zeros(2,1); t', 1];
    real_trans_mat = maketform('affine', mat);
    transformation = imtransform(im, real_trans_mat);
    figure, imshow(transformation);
end