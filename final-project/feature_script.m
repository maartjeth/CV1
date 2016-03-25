%run('D:/Computer Vision/vlfeat-0.9.20/toolbox/vl_setup')    


source_dirs = {'.\Caltech4\debug\source\airplanes_train', '.\Caltech4\debug\source\cars_train', '.\Caltech4\debug\source\faces_train', '.\Caltech4\debug\source\motorbikes_train'};
target_dir = '.\Caltech4\debug\target';
file_format = 'jpg';
vocab_percentage = 0.5;
vocab_size = 20;
sift_type = 'ip_intensity_1';
test_dirs = {'.\Caltech4\debug\source'};

prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type, test_dirs);

