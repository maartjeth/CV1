% Computer Vision Final Assignment
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

% Maartje: in maartje/vlfeat-0.9.20-bin/vlfeat-0.9.20 run: run('toolbox/vl_setup')
% 1) Train and test set --> load images

% 2) Bag of words 
%    a) Feature extraction --> use keypoint sift, dense sift, RGBsift,
%    rgbsift and opponent sift
%    b) Build visual vocabulary --> take subset of ALL images, extract SIFT
%    descriptors, k-means over sift-descriptors --> now we have a visual
%    vocabulary
%    c) quantize features using visual vocabulary --> represent image as visual word, 
%    --> extract sift features and assign each descriptor to closest word
%    from vocab. --> k-nearest neighbour (matlab function)
%    represent each image by histogram of its visual words
%    d) classification --> SVM --> train on histogram images

% 3) Evaluation

function im_classification_maartje()
    vocab_size = 4;
    filename = 'C:\Users\Maartje\Documents\Studie\master\cv1_git\final-project\Caltech4\FeatureData\debug.mat';
    sift_type = 'normal';
    im_directory1 = 'C:\Users\Maartje\Documents\Studie\master\cv1_git\final-project\Caltech4\ImageData\debug';
    im_directory2 = 'C:\Users\Maartje\Documents\Studie\master\cv1_git\final-project\Caltech4\ImageData\debug2';
    im_directories = {im_directory1, im_directory2};
    warning('off','stats:pdist2:DataConversion');
   
    % preprocessing
    desc_mat = feature_extraction(im_directory1, 'normal');
    build_vis_vocab(desc_mat, vocab_size, filename);
    
    
    load(filename);
    [X, y] = make_training_data(im_directories, sift_type, C);
    SVMModel = train_SVM(X, y);

                
    
end

% 'Real' preprocessing
function desc_mat = feature_extraction(directory, sift_type)
    image_paths = get_imagepaths(directory, 'jpg');
    
    desc_mat = zeros(0, 128);
    
    for i=1:size(image_paths, 1)
        im = imread(image_paths{i});
        if strcmp(sift_type, 'normal')
           [~, desc] = vl_sift(single(rgb2gray(im)));
           desc_mat(end+1:end+size(desc, 2), :) = desc';
        end
    end
end

function build_vis_vocab(desc_mat, vocab_size, filename)
    [~, C] = kmeans(desc_mat, vocab_size);    
    save(filename, 'C');
end


% Getting training data for SVM
function [X_train, y_train] = make_training_data(im_directories, sift_type, vocab)
    % list of the different directories --> use same order every single
    % time so that you can easily extract y

    X_train = zeros(0, size(vocab, 1));    
    y_train = zeros(0, 1);
    
    for i=1:size(im_directories, 2)
        im_dir = im_directories{i};
        X = make_hists_ims(im_dir, sift_type, vocab);
        X_train(end+1:end+size(X, 1), :) = X;
        y = ones(size(X, 1), 1);
        y = i*y; % every class gets number of i as label
        y_train(end+1:end+size(y, 1), :) = y;
    end

end

% make histograms for all images
function hists = make_hists_ims(im_directory, sift_type, vocab)

    paths = get_imagepaths(im_directory, 'jpg');
    hists = zeros(0,size(vocab, 1));
    for i=1:size(paths, 1)        
        im = imread(paths{i});
        hist = make_hist_im(im, sift_type, vocab);
        hists(end+1, :) = hist;
    end             
end

% make a histogram for a single image
function hist = make_hist_im(im, sift_type, vocab)    

    if strcmp(sift_type, 'normal')
        [~, desc] = vl_sift(single(rgb2gray(im)));
        words = knnsearch(vocab, desc');
        
        hist = zeros(1, size(vocab, 1));
        for i = 1:size(words,1)
            hist(words(i)) = hist(words(i)) + 1;
        end
        hist = hist ./ size(words,1);
        
        
    end
end



function SVMModel = train_SVM(X, y)
    SVMModel = fitcsvm(X, y, 'KernelFunction', 'rbf', 'KernelScale', 'auto', 'Standardize', true);
end

