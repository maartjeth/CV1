% Computer Vision Assignment 3 Part 3
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function tracker(directory, file_ending, sigma, kernel_length, k, neighbour_length, threshold, region_size)

    directory = 'pingpong';
    file_ending = 'jpeg';
    sigma = 3;
    kernel_length = 11;
    k = 0.05;
    neighbour_length = 10;
    threshold = 0.01;

    region_size = 15;
    
    % retrieve relevant image paths
    paths = get_imagepaths(directory, file_ending);
    
    
    % create structure for storing images
    im = imread(paths{1});
    frames = zeros(size(im,1), size(im,2), 3, size(paths, 1));
    
    % detect corners in first image save as interest points
    [r, c] = harris_corner(paths{1}, sigma, kernel_length, k, neighbour_length, threshold, false);
    ip = [r, c];    
   
    % for each pair of consecutive images compute flow and update interest points (make plot)
    for idx = 1:size(paths,1)-1
        
        V = optical_flow(paths{idx}, paths{idx+1}, sigma, kernel_length, region_size, ip, false);

        im = imread(paths{idx});
        fig = figure('visible','off');
        imshow(im);
        hold on
        scatter(ip(:,2), ip(:,1), 'filled');
        quiver(ip(:,2), ip(:,1), V(:,1), V(:,2), 'AutoScale', 'off');
        hold off

        F = getframe(fig);
        frames(:,:,:,idx) = double(F.cdata) / 255;
        
        % make new interest points
        ip = ip + fliplr(V);
    end
    
    % make final frame
    im = imread(paths{end});
    fig = figure('visible','off');
    imshow(im);
    hold on
    scatter(ip(:,2), ip(:,1), 'filled');
    hold off
    F = getframe(fig);
    frames(:,:,:,end) = double(F.cdata) / 255;
    
    % take all plots, make movie    
    mov = immovie(frames);
    implay(mov);
    
end
    
function paths = get_imagepaths(directory, file_ending)
    % getting all paths to images in the movie
    general_path = strcat(directory, '/*.', file_ending);
    files = dir(general_path);

    paths = cell(size(files, 1), 1);
    for idx = 1:size(files, 1)
        paths{idx} = strcat(directory, '/', files(idx).name);
    end
end
