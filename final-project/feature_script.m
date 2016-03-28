%run('D:/Computer Vision/vlfeat-0.9.20/toolbox/vl_setup')    

% change the file names to where it's on your pc
<<<<<<< HEAD
source_dirs = {'.\Caltech4\subset150\airplanes_train', '.\Caltech4\subset150\cars_train', '.\Caltech4\subset150\faces_train', '.\Caltech4\subset150\motorbikes_train'};

target_dir = '.\Caltech4\FeatureData';
file_format = 'jpg';
vocab_percentage = double(2/3);
vocab_size = 400
test_dirs = {'.\Caltech4\ImageData\airplanes_test', '.\Caltech4\ImageData\cars_test', '.\Caltech4\ImageData\faces_test', '.\Caltech4\ImageData\motorbikes_test'};


sift_type = 'dense_normrgb_3';
display(sift_type)
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
%im_classification_merge(sift_type, vocab_size)

vocab_size = 800
sift_type = 'dense_normrgb_3';
=======
source_dirs = {'.\Caltech4\ImageData\airplanes_small_train', '.\Caltech4\ImageData\cars_small_train', '.\Caltech4\ImageData\faces_small_train', '.\Caltech4\ImageData\motorbikes_small_train'};

target_dir = '.\Caltech4\debug\target';
file_format = 'jpg';
vocab_percentage = double(2/3);
test_dirs = {'.\Caltech4\ImageData\airplanes_test', '.\Caltech4\ImageData\cars_test', '.\Caltech4\ImageData\faces_test', '.\Caltech4\ImageData\motorbikes_test'};

% vocab_size = 400;
% 
% display('vocab size 400')
% sift_type = 'ip_normrgb_3';
% display(sift_type)
% prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)

vocab_size = 800;

display('vocab size 800')
sift_type = 'ip_normrgb_3';
>>>>>>> 76d22e82fed2c42914008fae0bb08267929459ee
display(sift_type)
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
%im_classification_merge(sift_type, vocab_size)

% sift_type = 'ip_opponent_3';
% display(sift_type)
% prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)

% sift_type = 'ip_RGB_3';
% display(sift_type)
% prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'ip_opponent_3';
% display(sift_type)
% prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)

% sift_type = 'ip_RGB_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'dense_opponent_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'dense_rgb_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% display('vocab size 800')
% vocab_size = 800;
% sift_type = 'ip_rgb_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'ip_RGB_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
%  
% sift_type = 'ip_opponent_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'dense_rgb_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'dense_RGB_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'dense_opponent_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% display('vocab size 1600')
% vocab_size = 1600;
% sift_type = 'ip_rgb_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'ip_RGB_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
%  
% sift_type = 'ip_opponent_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% display('vocab size 2000')
% vocab_size = 2000;
% sift_type = 'ip_rgb_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
% 
% sift_type = 'ip_RGB_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)
%  
% sift_type = 'ip_opponent_3';
% %prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
% im_classification_merge(sift_type, vocab_size)