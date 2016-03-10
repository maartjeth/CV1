% Computer Vision Assignment 2 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function G = gaussian(sigma, kernel_length)
    
    % create 1D gaussian filter
    x = (1:kernel_length) - ceil(kernel_length/2);
    G = normpdf(x, 0, sigma);
    G = G / sum(G);
end

