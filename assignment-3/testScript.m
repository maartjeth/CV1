%% Part 5 Deliverables 
% to reproduce the results we submitted in the report, comment out the
% function calls in the respective sections.

%% Section 1
sigma = 3;
kernel_length = 11;
k = 0.05;
neighbour_length = 10;
threshold = 0.01;

im_path = 'person_toy/00000001.jpg';   
%harris_corner(im_path, sigma, kernel_length, k, neighbour_length, threshold);

im_path = 'pingpong/0000.jpeg';
%harris_corner(im_path, sigma, kernel_length, k, neighbour_length, threshold);


%% Section 3
region_size = 15;

im_path1 = 'sphere1.ppm';
im_path2 = 'sphere2.ppm';
%optical_flow(im_path1, im_path2, region_size);

im_path1 = 'synth1.pgm';
im_path2 = 'synth2.pgm';
%optical_flow(im_path1, im_path2, region_size);


%% Section 4
directory = 'pingpong';
file_ending = 'jpeg';
%tracker(directory, file_ending, sigma, kernel_length, k, neighbour_length, threshold, region_size);

directory = 'person_toy';
file_ending = 'jpg';
%tracker(directory, file_ending, sigma, kernel_length, k, neighbour_length, threshold, region_size);