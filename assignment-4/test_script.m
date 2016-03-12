%% Deliverables for section 1

% 1 & 2
im_path1 = 'boat/img1.pgm';
im_path2 = 'boat/img2.pgm';
N = 1;
P = 10;
showplots = true;

%image_alignment(im_path1, im_path2, N, P, showplots);

% 3
N = 1000;

%[M, t] = image_alignment(im_path1, im_path2, N, P);
%do_transform_builtin(M, t, im_path1);
%do_transform_own(M, t, im_path1);

%[M, t] = image_alignment(im_path2, im_path1, N, P);
%do_transform_builtin(M, t, im_path2);
%do_transform_own(M, t, im_path2);


%% Deliverables for section 2
% (1 this script should do the trick)

% 2
im_path1 = 'left.jpg';
im_path2 = 'right.jpg';

[M, t] = image_alignment(im_path1, im_path2, N, P);
do_transform_stitching(M, t, im_path1, im_path2);