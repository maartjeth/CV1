function prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs)
    % from each sdir, take part to create and save vis-vocab. then use rest
    % to make and save histogram training samples

    rng(2718);

    
    [vfiles, ffiles] = divide_data(source_dirs, file_format, vocab_percentage);

    vocabulary = build_vocab(vfiles, sift_type, vocab_size);
    train_data = build_histograms(ffiles, vocabulary, sift_type);
    
    filename = strcat(target_dir, '\train_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
    save(filename, 'vocabulary', 'train_data');
    
    if nargin > 6 % get histogram description of test data
        tfiles = get_test_files(test_dirs, file_format);
        test_data = build_histograms(tfiles, vocabulary, sift_type);
        filename = strcat(target_dir, '\test_data_', sift_type, '_voc_', num2str(vocab_size),'.mat');
        save(filename, 'test_data');
    end
end

function [vfiles, ffiles] = divide_data(source_dirs, file_format, vocab_percentage)

    vfiles = cell(0, 1);                        % cell vector of paths
    ffiles = cell(length(source_dirs), 1);      % cell vector of vectors for each class
    
    for idx = 1:length(source_dirs)
        display(source_dirs{idx})
        im_paths = get_imagepaths(source_dirs{idx}, file_format); % get file paths
        
        im_paths = im_paths( randperm(length(im_paths)),: ); % shuffle file paths
        
        lastv = round(length(im_paths) * vocab_percentage); % split file paths
        vfiles = [vfiles; im_paths(1:lastv,:)]; 
        ffiles{idx} = im_paths(lastv+1:end,:);
    end
    
end

function vocabulary = build_vocab(im_paths, sift_type, vocab_size)
    num_channels = str2double(sift_type(end));
    vocab_features = zeros(0, 128*num_channels);

    for i=1:size(im_paths, 1)
        im = imread(im_paths{i});
        features = sift(im, sift_type);
        vocab_features(end+1:end+size(features, 2), :) = features';
        
    end
    
    [~, vocabulary] = kmeans(vocab_features, vocab_size, 'MaxIter', 500);
end

function features = sift(im, type)
    switch type
        case 'ip_intensity_1'
            if size(im, 3) == 3
                [~, features] = vl_sift(single(rgb2gray(im)));
            else
                [~, features] = vl_sift(single(im));
            end
        case 'dense_intensity_1'
            'a'
        case 'ip_RGB_3'
            'a'
        case 'dense_RGB_3'
            'a'
        case 'ip_rgb_3'
            'a'
        case 'dense_rgb_3'
            'a'
        case 'ip_opponent_3'
            'a'
        case 'dense_opponent_3'
            'a'
        otherwise
            display('invalid sift type')
    end
end

function train_data = build_histograms(label_sets, vocabulary, sift_type)
    train_data = zeros(0, size(vocabulary, 1) + 1); % last index is the label
    
    for label = 1:length(label_sets)
        im_paths = label_sets{label};
        label_data = zeros(length(im_paths), size(vocabulary, 1));
        
        for idx = 1:length(im_paths)
            im = imread(im_paths{idx});
            label_data(idx, :) = make_hist(im, sift_type, vocabulary);
        end
        
        train_data = [train_data; [label_data, ones(length(im_paths), 1)*label]];
    end
end

function hist = make_hist(im, sift_type, vocab)    

    desc = sift(im, sift_type);
    words = knnsearch(vocab, double(desc'));
    hist = zeros(1, size(vocab, 1));
    for i = 1:size(words,1)
        hist(words(i)) = hist(words(i)) + 1;
    end
    hist = hist ./ double(size(words,1));
end

function tfiles = get_test_files(test_dirs, file_format)
    tfiles = cell(length(test_dirs), 1); 
    for idx = 1:length(test_dirs)
        im_paths = get_imagepaths(test_dirs{idx}, file_format); % get file paths
        tfiles{idx} = im_paths;
    end
end