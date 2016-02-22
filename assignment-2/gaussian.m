% Computer Vision Assignment 2 Part 1
% Frederik Harder - 10986847 - frederikharder@gmail.com
% Maartje ter Hoeve - 10190015 - maartje.terhoeve@student.uva.nl

function G = gaussian(sigma, kernelLength)
    x = (1:kernelLength) - ceil(kernelLength/2);
    G = normpdf(x, 0, sigma);
    G = G / sum(G);
end

