function test
    im = imread('.\Caltech4\ImageData\faces_small_train\img035.jpg');
    [frames, desc] = vl_phow(single(im), 'Color', 'rgb');
    
    size(frames)
    size(desc)
    
        
end