%run('D:/Computer Vision/vlfeat-0.9.20/toolbox/vl_setup')    


source_dirs = {'.\Caltech4\debug\source'};
target_dir = '.\Caltech4\debug\target';
file_format = 'jpg';
vocab_percentage = 0.5;
vocab_size = 20;
sift_type = 'ip_intensity_1';
  
prepare_features(source_dirs, target_dir, file_format, vocab_percentage, vocab_size, sift_type);