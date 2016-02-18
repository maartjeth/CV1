% Computer Vision Assignment 2 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function G = gaussian(sigma, kernelLength)
    mean = 0; % floor(kernelLength / 2);
    x = ceil(-0.5*kernelLength+1):floor(0.5*kernelLength);
    
    %0:kernelLength-1;
    G = normpdf(x, mean, sigma);
    G = G / sum(G);
end

