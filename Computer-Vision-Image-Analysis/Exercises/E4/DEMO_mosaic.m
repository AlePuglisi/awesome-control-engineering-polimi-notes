%% Image Mosaickng/Stitching via Synchronization
% 1) Estimate pairwise homographies to stich togheter two images
% 2) Globally optimize all the homographies to get a unique mosaic
%
% References:
% - Schroeder et al. Closed-Form Solutions to Multiple-View Homography
% Estimation. WACV 2011
% - Santellani et al. Seamless image mosaicking via synchronization. ISPRS 2018
% - Arrigoni et al. Synchronization problems in computer vision with
% closed-form solutions. IJCV 2020
%
% .\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.
%
% Image Analysis and Computer Vision
% Politecnico di Milano
%
% Federica Arrigoni - federica.arrigoni@polimi.it
%
% .\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.\\°//.

clear,clc,close all
addpath(genpath('./'))

%% Load images

scale=0.5;
img_path='data1/'; format_img='jpg'; % path and format

imnames = dir(strcat(img_path,'*.',format_img)); % image names
nimages=length(imnames); % number of images

for i=1:nimages
    current_im = imread(strcat(img_path,imnames(i).name)); % load the current image
    im{i} = imresize(current_im,scale); % resize image for efficiency
end

%% Load matches 

load([img_path 'matches.mat']);

%% plot correspondences for a selected pair

i=2; j=3; % choose an image pair

% load the left/right images
im1=im{i}; 
im2=im{j}; 

% load matches
m1=matches{i,j}.m1; 
m2=matches{i,j}.m2;

npoints=size(m1,2); % number of points
col=rand(npoints,3); % colors to use (random)

figure; 
subplot(1,2,1);
imshow(im1);
hold on;
for k=1:size(m1,2)
    plot(m1(1,k),m1(2,k),'+','MarkerSize',15,'Linewidth',4,'Color',col(k,:));
end
title(['Image ' num2str(i)])
subplot(1,2,2);
imshow(im2);
hold on;
for k=1:size(m2,2)
    plot(m2(1,k),m2(2,k),'+','MarkerSize',15,'LineWidth',4,'Color',col(k,:));
end
title(['Image ' num2str(j)])

%% Compute pairwise homographies

% initialize the block matrix containing pairwise homographies
Z=eye(3*nimages);
E=zeros(nimages); % error
for i=1:nimages
    for j=i+1:nimages % current image pair [i,j]

        % load matches
        m1=matches{i,j}.m1;
        m2=matches{i,j}.m2;

        % preconditioning
        [m1_cond,T1] = precondition(m1);
        [m2_cond,T2] = precondition(m2);

        % compute the homography via DLT
        H0 = dlt_homography(m1_cond,m2_cond); % H0*m1 ~ m2

        % Apply the inverse transformations
        H0 = T2\H0*T1;

        % Compute the inverse
        invH0=inv(H0);

        % save the homography in a big block matrix
        Z(3*i-2:3*i,3*j-2:3*j)=H0/nthroot(det(H0),3);
        Z(3*j-2:3*j,3*i-2:3*i)=invH0/nthroot(det(invH0),3);

        npoints=size(m1,2); % number of points 
        % Compute the average error
        E(i,j)=sum(get_transfer_errors(H0,m1,m2))/npoints;
        E(j,i)=sum(get_transfer_errors(invH0,m2,m1))/npoints;

        % E(i,j)=transfer_error_H(m1,m2,H0)/npoints;
        % E(j,i)=transfer_error_H(m2,m1,invH0)/npoints;

    end
end

% visualize average transfer error
figure, imagesc(E), colorbar

%% Visualize the singular values

[U,S,V]=svd(Z);

figure
semilogy(diag(S),'o','MarkerSize',15,'Linewidth',4)
grid on
set(gca,'FontSize',15)

%% Perform homography synchronization

A=ones(nimages); % adjacency matrix
H = hom_synch(Z,A); % synchronization

%% Visualize the final mosaic

for i=1:nimages
    tforms{i}=projtform2d(H{i});
end

[panorama] = create_panorama(tforms,im);
figure,imshow(panorama)



