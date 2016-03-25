function divide_data()
    source_dirs = {'.\Caltech4\ImageData\airplanes_train', '.\Caltech4\ImageData\cars_train', '.\Caltech4\ImageData\faces_train', '.\Caltech4\ImageData\motorbikes_train'};
    target_dirs_code = {'.\Caltech4\ImageData\airplanes_small_code', '.\Caltech4\ImageData\cars_small_code', '.\Caltech4\ImageData\faces_small_code', '.\Caltech4\ImageData\motorbikes_small_code'};
    target_dirs_train = {'.\Caltech4\ImageData\airplanes_small_train', '.\Caltech4\ImageData\cars_small_train', '.\Caltech4\ImageData\faces_small_train', '.\Caltech4\ImageData\motorbikes_small_train'};
    visual_dict_size = 100;
    train_size = 50;

    for i=1:size(source_dirs, 2)
        im_dir = source_dirs{i};
        paths = get_imagepaths(im_dir, 'jpg');
        
        for j=1:visual_dict_size
            im = imread(paths{j});
            imwrite(im, target_dirs_code{j}, 'jpg');
        end        
        
        for k=visual_dict_size+1:train_size
            im = imread(paths{k});
            imwrite(im, target_dirs_train{k}, 'jpg');
        end
    end
end


