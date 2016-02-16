function [] = photometric_stereo()

    % compute V

    dist = 1; % dominant distance of light source (z axis in 1, x,y in rest)
    elevation = 0;%0.01; % elevation of lights 2 to 5 in z direction

    ls1 = [0, 0, dist]; % note that dim1 is vertical, dim2 is horizontal, dim3 is pointing in    %% why not elevation
    ls2 = [-dist, -dist, elevation]; % lower right  %% upper right?
    ls3 = [dist, -dist, elevation]; % lower left  %% lower left?
    ls4 = [-dist, dist, elevation]; % upper right %% lower right?
    ls5 = [dist, dist, elevation]; % upper left %% lower left?
    light_sources = [ls1; ls2; ls3; ls4; ls5]; % this is V

    % compute I

    sp1 = imread('sphere1.png'); % frontal
    sp2 = imread('sphere2.png'); % upper left  %% lower right?
    sp3 = imread('sphere3.png'); % upper right %% lower left?
    sp4 = imread('sphere4.png'); % lower left  %% upper right? 
    sp5 = imread('sphere5.png'); % lower right %% upper left?
    spheres = {sp1; sp2; sp3; sp4; sp5};
    
    image_val_vec = zeros(size(spheres, 1), 1); % this is i
    image_values = zeros(size(spheres,1), size(spheres,1)); % this is I
    
    num_rows = size(sp1, 1);
    num_cols = size(sp1, 2);
    
    normals = zeros(num_rows, num_cols, 3); % matrix for suface normals (3 in z direction for 3 spacial dims)
    
    for row = 1:num_rows
        for col = 1:num_cols % go through all pixels
            
            for idx = 1:size(spheres) % go through all images and fill in i and I
                sp = spheres{idx};
                image_val_vec(idx) = sp(row, col);
                image_values(idx, idx) = sp(row, col);
            end
            
            warning('off','MATLAB:rankDeficientMatrix')
            surface_prop = (image_values * light_sources) \ (image_values * image_val_vec); % using backslash instead of inv(A)*b
            warning('on','MATLAB:rankDeficientMatrix')           
            
            albedo = norm(surface_prop);
            
            if albedo == 0
                normals(row, col, :) = [0; 0; 1];
            else
                normals(row, col, :) = surface_prop / albedo;
            end
        end
    end
    
    % get p and q values for each pixel
    p_vals = normals(:,:,1) ./ normals(:,:,3); % angle in vertical direction
    q_vals = normals(:,:,2) ./ normals(:,:,3); % angle in horizontal direction
    
    % get height map
    heights = zeros(num_rows, num_cols);
    
    for row = 2:num_rows % get heights for leftmost column
        heights(row, 1) = heights(row-1, 1) + q_vals(row, 1); % note: we interchanged p and q in comparison to the algorithm 
    end
    
    for row = 1:num_rows % go through rows
        for col = 2:num_cols % get heights for each row
            heights(row, col) = heights(row, col-1) + p_vals(row, col);
        end
    end
    
    % resize arrays for plotting, i.e. don't plot every single normal
    % vector
    res = 10;
    res_picks = res:res:num_rows;
    
    heights_plot = zeros(size(res_picks));
    normals_plot = zeros(size(res_picks,1), size(res_picks,1), 3);
    
    for row = res_picks
        for col = res_picks
            heights_plot(row/res, col/res) = heights(row, col);
            normals_plot(row/res, col/res, :) = normals(row, col, :);            
        end
    end
    
    % plot surface normals
    quiver3(res_picks, res_picks, heights_plot, -1 * normals_plot(:,:,1), -1 * normals_plot(:,:,2), normals_plot(:,:,3))
    % still not much of a clue why the dimensions don't work out naturally
    
    % plot reconstructed shape
    figure
    surf(res_picks, res_picks, heights_plot)    
end
