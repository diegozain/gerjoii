clear
close all
clc
% ------------------------------------------------------------------------------
% images path
image_path= 'nature-synth/images/';
mat_path  = 'nature-synth/mat-file/';
% image extention
image_exte = '.png';
% images name
sig_name = 'sig-river-initial2'; % 'sig-river-hori2'
% load images
sig_path = strcat(image_path, sig_name, image_exte );
% read
sigm = imread(sig_path);
% uint8 to double
sigm = im2double(sigm)*255;
% squeeze to respective rgb channels
sigm = squeeze(sigm(:,:,2));
% ------------------------------------------------------------------------------
% conductivity
sig_rgb = [15; 18; 20; 40; 50; 10];
sig_ele = [1.5; 1.8; 2; 4; 5; 1]*1e-3;
% -------------
% conductivity
% -------------
p = polyfit(sig_rgb,sig_ele,numel(sig_rgb)-1);
sigm = polyval(p,sigm);
% positivity
sigm = sqrt(sigm.^2);
% ------------------------------------------------------------------------------
load(strcat(mat_path,'x.mat'));
load(strcat(mat_path,'z.mat'));
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial conductivity (S/m) - no smooth')
simple_figure()
% ------------------------------------------------------------------------------
% smooth it
ax = 0.8; % 1/m
az = 0.8; % 1/m
dx=x(2)-x(1); dz=z(2)-z(1);
ax=ax*dx;az=az*dz;
sigm = smooth2d(sigm,ax,az);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial conductivity (S/m)')
simple_figure()
% ------------------------------------------------------------------------------
% save
% save('nature-synth/initial-guess/sigm_hori2.mat','sigm')
save('nature-synth/initial-guess/sigm_smooth2.mat','sigm')
% ------------------------------------------------------------------------------
