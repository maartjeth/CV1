function test
    im = imread('.\Caltech4\ImageData\faces_small_train\img035.jpg');
            rval = im(:,:,1);
            gval = im(:,:,2);
            bval = im(:,:,3);

            im_mat = zeros(size(im));
            im_mat(:,:,1) = (double(rval) - double(gval)) ./ sqrt(2);
            im_mat(:,:,2) = (double(rval) + double(gval) - double(2 * bval)) ./ sqrt(6);
            im_mat(:,:,3) = (double(rval) + double(gval) + double(bval)) ./ sqrt(3);
            
            [~, features_1] = vl_phow(single(im_mat(:, :, 1)), 'Step', 8);
            [~, features_2] = vl_phow(single(im_mat(:, :, 2)), 'Step', 8);
            [~, features_3] = vl_phow(single(im_mat(:, :, 3)), 'Step', 8);
            features = [features_1, features_2, features_3];

    size(features_1)
    size(features_2)
    size(features_3)
    size(features)
    
        
end