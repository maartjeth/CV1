function order = get_image_order(test_dirs, test_scores)

    tfiles = get_test_files(test_dirs, 'jpg');
    tflat = cell(0, 1);
    for idx = 1:length(tfiles)
        tflat = [tflat; tfiles{idx}];
    end
    %test_scores(:,2)
    [~, ind] = sort(test_scores(:,2), 'descend');
    order = tflat(ind, :);
end


function tfiles = get_test_files(test_dirs, file_format)
    tfiles = cell(length(test_dirs), 1); 
    for idx = 1:length(test_dirs)
        im_paths = get_imagepaths(test_dirs{idx}, file_format); % get file paths
        tfiles{idx} = im_paths;
    end
end