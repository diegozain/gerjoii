clear
close all
clc
% ------------------------------------------------------------------------------
% 
load('../c1/output/dc/sigm.mat')
load('../c1/output/dc/x.mat')
load('../c1/output/dc/z.mat')
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(2))
xlabel('Length (m)')
ylabel('Depth (m)')
title('ER conductivity')
simple_figure()
% ------------------------------------------------------------------------------
% smooth it
ax = 0.7; % 1/m
az = 0.7; % 1/m
dx=x(2)-x(1); dz=z(2)-z(1);
ax=ax*dx;az=az*dz;
sigm = smooth2d(sigm,ax,az);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(2))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial conductivity')
simple_figure()
% ------------------------------------------------------------------------------
% save
save('../image2mat/nature-synth/initial-guess/sigm.mat','sigm')
% ------------------------------------------------------------------------------
