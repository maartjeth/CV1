function get_imagepaths(directory, file_ending)
    
    general_path = strcat(directory, '/*.', file_ending);
    files = dir(general_path);
    
    paths = cell(size(files, 1), 1);
    
    for idx = 1:size(files, 1)
        paths{idx} = files(idx).name;
    end
    
    paths
end

