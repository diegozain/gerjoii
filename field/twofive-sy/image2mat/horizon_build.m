clear
close all
clc
% ------------------------------------------------------------------------------
% images path
image_path= 'nature-synth/images/';
mat_path  = 'nature-synth/mat-file/';
% image extention
image_exte = '.png'; % '.jpeg'; % '.png';
% images name
eps_name = 'eps-river-hori';
% load images
eps_path = strcat(image_path, eps_name, image_exte );
% read
epsi = imread(eps_path);
% uint8 to double
epsi = im2double(epsi)*255;
% squeeze to respective rgb channels
epsi = squeeze(epsi(:,:,1));
% ------------------------------------------------------------------------------
% eps sig simple
% permittivity
eps_rgb = [170; 180; 140; 190; 200; 50];
eps_rel = [6.5; 7; 6; 8; 9; 4];
% -------------
% permittivity
% -------------
p = polyfit(eps_rgb,eps_rel,numel(eps_rgb)-1);
epsi = polyval(p,epsi);
% positivity
epsi = sqrt(epsi.^2);
% ------------------------------------------------------------------------------
load(strcat(mat_path,'x.mat'));
load(strcat(mat_path,'z.mat'));
% ------------------------------------------------------------------------------
% smooth it
ax = 0.8; % 1/m
az = 0.8; % 1/m
dx=x(2)-x(1); dz=z(2)-z(1);
ax=ax*dx;az=az*dz;
epsi = smooth2d(epsi,ax,az);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z)
colormap(rainbow2(2))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial permittivity')
simple_figure()
% ------------------------------------------------------------------------------
% save
save('nature-synth/initial-guess/epsi_hori.mat','epsi')
% ------------------------------------------------------------------------------
