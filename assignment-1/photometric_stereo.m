function [] = photometric_stereo()

    % compute V

    dist = 1; % dominant distance of light source (z axis in 1, x,y in rest)
    elevation = 0; % elevation of lights 2 to 5 in z direction

    ls1 = [0, 0, dist]; % note that dim1 is horizontal and dim2 is vertical with upper left pixel at max
    ls2 = [-dist, -dist, elevation]; % lower right
    ls3 = [dist, -dist, elevation]; % lower left
    ls4 = [-dist, dist, elevation]; % upper right
    ls5 = [dist, dist, elevation]; % upper left
    light_sources = [ls1; ls2; ls3; ls4; ls5]; % this is V

    % compute I

    sp1 = imread('sphere1.png'); % frontal light source
    sp2 = imread('sphere2.png'); 
    sp3 = imread('sphere3.png'); 
    sp4 = imread('sphere4.png'); 
    sp5 = imread('sphere5.png'); 
    spheres = {sp1; sp2; sp3; sp4; sp5};
    
    image_values = zeros(size(spheres,1), size(spheres,1));% this is I
    image_val_vec = zeros(size(spheres, 1), 1); % this is i
    
    num_rows = size(sp1, 1);
    num_cols = size(sp1, 2);
    
    normals = zeros(num_rows, num_cols, 3); % 3 for 3 spacial dims
    albedos = zeros(num_rows, num_cols);
    for row = 1:num_rows
        for col = 1:num_cols % go through all pixels
            
            for idx = 1:size(spheres)
                sp = spheres{idx};
                image_values(idx, idx) = sp(row, col);
                image_val_vec(idx) = sp(row, col);
            end
            
            warning('off','MATLAB:rankDeficientMatrix')
            surface_prop = (image_values * light_sources) \ (image_values * image_val_vec);
            warning('on','MATLAB:rankDeficientMatrix')           
            
            albedo = norm(surface_prop);
            albedos(row, col) = albedo;
            
            if albedo == 0
                normals(row, col, :) = [0; 0; 1];
            else
                normals(row, col, :) = surface_prop / albedo;
            end
        end
    end
    
    % get p and q values for each pixel
    p_vals = normals(:,:,1) ./ normals(:,:,3);
    q_vals = normals(:,:,2) ./ normals(:,:,3);
    
    % get height map
    heights = zeros(num_rows, num_cols);
    
    for row = 2:num_rows % get heights for leftmost column
        heights(row, 1) = heights(row-1, 1) + q_vals(row, 1); 
    end
    
    for row = 1:num_rows % go through rows
        for col = 2:num_cols % get heights for each row
            heights(row, col) = heights(row, col-1) + p_vals(row, col);
        end
    end
    
    % resize arrays for plotting
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
    quiver3(res_picks, res_picks, heights_plot,-1 * normals_plot(:,:,1),-1 * normals_plot(:,:,2),normals_plot(:,:,3))
    
    
    % plot reconstructed shape
    figure
    surf(res_picks, res_picks, heights_plot)
    
    % plot the reconstructed albedos
    figure
    imshow(mat2gray(albedos));
end
