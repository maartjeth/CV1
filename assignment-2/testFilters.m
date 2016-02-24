function testFilters(im_path, sigma)

    close all

    %% Part 1
    
    G = gaussian(3, 11);
    H = fspecial('gaussian', 11, sigma);
    
    GH_diff = G' * G - H;
    max_diff = abs(max(max(GH_diff)));
    display(max_diff);
    
    
    %% Part 2
    
    im = imread(im_path);
    %figure('Name','original image'), imshow(im);
    
    conv_options = {'full', 'same', 'valid'};
    
    for option = conv_options
        im = gaussianConv(im_path, sigma, sigma, 11, char(option));
        %figure('Name',['gaussian with ' char(option) ' option']), imshow(im);
    end
    
    filter_x = gaussian(sigma, 11);
    filter_y = gaussian(sigma, 11)';
    filter_xy = filter_y * filter_x;
    im2 = imread(im_path);
    im2 = rgb2gray(im2)/ 255;
    
    step1 = conv2(im2, filter_x, 'valid');
    step2 = conv2(step1, filter_y, 'valid');
    step12 = conv2(im2, filter_xy, 'valid');
    figure, imshow(step1);
    figure, imshow(step2);
    figure, imshow(step12);
    
    max_diff = max(max(abs(step12 - step2)));
    display(max_diff);
    %% Part 3
    
    x = (-5*sigma):(5*sigma);
    G = normpdf(x, 0, sigma);
    G = -x / sigma^2 .* G;
    
    %figure('Name','gaussian derivative plot'), plot(x,G);
    
    G = gaussian(sigma, 11);
    im = gaussianDer(im_path, G, sigma);
    
    %figure('Name',['derivative filtered image sigma = ' num2str(sigma)]), imshow(im);
        
    for sig = [0.1 1 3 10]
        im = gaussianDer(im_path, gaussian(sig, 11), sig);
        %figure('Name',['derivative filtered image sigma = ' num2str(sig)]), imshow(im);
    end
    
end