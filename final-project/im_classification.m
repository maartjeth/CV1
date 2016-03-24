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

function im_classification()
    vocab_size = 4;
    filename = 'C:\Users\Maartje\Documents\Studie\master\cv1_git\final-project\Caltech4\FeatureData\debug.mat';
    sift_type = 'normal';
    
    desc_mat = feature_extraction('C:\Users\Maartje\Documents\Studie\master\cv1_git\final-project\Caltech4\ImageData\debug', 'normal');
    build_vis_vocab(desc_mat, vocab_size, filename);
    
    
    load(filename);
    make_hists_ims(im, sift_type, filename)
    
    
end

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

function make_hists_ims(im_directory, sift_type, vocab)

    paths = get_imagepaths(im_directory);
    for impath=paths
        im = imread(impath);
        hist = make_hist_im(im, sift_type, vocab);
    end
    

end

function hist = make_hist_im(im, sift_type, vocab)    

    if strcmp(sift_type, 'normal')
        [~, desc] = vl_sift(single(rgb2gray(im));
        word = knnsearch(desc, C);
        
    end
end

