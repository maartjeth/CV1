%run('D:/Computer Vision/vlfeat-0.9.20/toolbox/vl_setup')    

% change the file names to where it's on your pc
source_dirs = {'.\Caltech4\ImageData\airplanes_small_train', '.\Caltech4\ImageData\cars_small_train', '.\Caltech4\ImageData\faces_small_train', '.\Caltech4\ImageData\motorbikes_small_train'};

target_dir = '.\Caltech4\debug\target';
file_format = 'jpg';
vocab_percentage = double(1/3);
vocab_size = 400;
test_dirs = {'.\Caltech4\ImageData\airplanes_test', '.\Caltech4\ImageData\cars_test', '.\Caltech4\ImageData\faces_test', '.\Caltech4\ImageData\motorbikes_test'};

sift_type = 'dense_rgb_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'dense_RGB_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'ip_opponent_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'dense_opponent_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

vocab_size = 800;
sift_type = 'ip_rgb_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'ip_RGB_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'ip_opponent_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'dense_rgb_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'dense_RGB_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)

sift_type = 'dense_opponent_3';
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);
im_classification_merge(sift_type, vocab_size)