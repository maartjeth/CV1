% Computer Vision Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function [] = photometric_stereo()
    close all
    
    % compute V

    dist = 1; % dominant distance of light source (z axis in 1, x,y in rest)
    elevation = 0; % elevation of lights 2 to 5 in z direction

    ls1 = [0, 0, dist]; % note that dim1 is horizontal, dim2 is vertical with upper left pixel at max    
    ls2 = [-dist, -dist, elevation]; 
    ls3 = [dist, -dist, elevation]; 
    ls4 = [-dist, dist, elevation]; 
    ls5 = [dist, dist, elevation]; 
    light_sources = [ls1; ls2; ls3; ls4; ls5]; % this is V

    % compute i and I
    
    sp1 = imread('sphere1.png'); 
    sp2 = imread('sphere2.png'); 
    sp3 = imread('sphere3.png'); 
    sp4 = imread('sphere4.png'); 
    sp5 = imread('sphere5.png'); 
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
    
    % check for (dp/dy-dq/dx)^2 --> we don't have a complete function, so
    % we're going to compare the differences in p and q in comparison with
    % their previous values

    mat_gradients_p = zeros(num_rows, num_cols);
    mat_gradients_q = zeros(num_rows, num_cols);
    
    % get gradients p values
    for row = 1:num_rows

        if row ~= 1 % check whether you're not at the start
            a = p_vals(row-1, :);
        else
            a = p_vals(row, :);
        end
        
        b = p_vals(row, :);
        
        if row ~= num_rows % check whether you're not at the end
            c = p_vals(row+1, :);
        else
            c = b;
        end
        
        gradient_p1 = b - a;
        gradient_p2 = c - b;
        av_gradients_p = (gradient_p1 + gradient_p2) / 2; 
        mat_gradients_p(row, :) = av_gradients_p; % add all avarage gradients to the matrix
    end

    % get gradients q values
    for col = 1:num_cols        
        if col ~= 1 % check whether you're not at the start
            k = q_vals(:, col-1);
        else
            k = q_vals(:, col);
        end
        
        l = q_vals(:, col);
        
        if col ~= num_cols % check whether you're not at the end
            m = q_vals(:, col+1);
        else
            m = l;
        end
        
        gradient_q1 = l - k;
        gradient_q2 = m - l;
        av_gradients_q = (gradient_q1 + gradient_q2) / 2;
        mat_gradients_q(:, col) = av_gradients_q; % add all avarage gradients to the matrix
    end
    
    diff_gradients = (mat_gradients_p - mat_gradients_q).^2;
    
    % change values in p and q matrix if larger than 1
    for row = 1:num_rows
        for col = 1:num_cols
           if diff_gradients(row, col) > 1
               p_vals(row, col) = 0;
               q_vals(row, col) = 0; 
           end 
        end        
    end
       
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
    
    % plot surface normals (see report for more detailed explanation)
    figure
    quiver3(res_picks, res_picks, heights_plot, -1 * normals_plot(:,:,1), -1 * normals_plot(:,:,2), normals_plot(:,:,3))

    % plot reconstructed shape
    figure
    surf(res_picks, res_picks, heights_plot)    
end