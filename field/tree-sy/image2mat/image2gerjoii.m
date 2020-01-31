clear
close all
clc
% ------------------------------------------------------------------------------
% puts rgb image of material properties in gerjoii format 
% for wave and dc propagation.
% 
% there is a manual step of choosing which rgb values are 
% mapped to which material properties physical values.
% ------------------------------------------------------------------------------
% images path
image_path = 'nature-synth/images/';
mat_path = 'nature-synth/mat-file/';
% image extention
image_exte = '.png'; % '.jpeg'; % '.png';
% ------------------------------------------------------------------------------
% images name
eps_name = 'eps-tree';
sig_name = 'sig-tree';
shape_name='eps-tree-init';
% ------------------------------------------------------------------------------
% load images
eps_path = strcat(image_path, eps_name, image_exte );
sig_path = strcat(image_path, sig_name, image_exte );
shape_path= strcat(image_path, shape_name, image_exte );
% read
epsi = imread(eps_path);
sigm = imread(sig_path);
shape= imread(shape_path);
% uint8 to double
epsi = im2double(epsi)*255;
sigm = im2double(sigm)*255;
shape= im2double(shape)*255;
% squeeze to respective rgb channels
epsi = squeeze(epsi(:,:,1));
sigm = squeeze(sigm(:,:,2));
shape= squeeze(shape(:,:,1));
% ------------------------------------------------------------------------------
% MANUAL STEP 1
% 
% check rgb values in bottom plot that are to be mapped to physical values.
% ------------------------------------------------------------------------------
figure;
subplot(3,3,[1,2,3,4,5,6])
fancy_imagesc(epsi)
colormap(rainbow2(1))
xlabel('$n_x$')
ylabel('$n_z$')
title('relative permittivity')
fancy_figure()
subplot(3,3,[7,8,9])
plot(epsi(:),'.','Markersize',5)
axis tight
xlabel('$n_x\cdot n_z$')
ylabel('rgb value')
title('relative permittivity')
fancy_figure()
% ------------------------------------------------------------------------------
figure;
subplot(3,3,[1,2,3,4,5,6])
fancy_imagesc(sigm)
colormap(rainbow2(1))
xlabel('$n_x$')
ylabel('$n_z$')
title('conductivity')
fancy_figure()
subplot(3,3,[7,8,9])
plot(sigm(:),'.','Markersize',5)
axis tight
xlabel('$n_x\cdot n_z$')
ylabel('rgb value')
title('conductivity')
fancy_figure()
% ------------------------------------------------------------------------------
% MANUAL STEP 2
% 
% choose physical values that will transform the existing rgb values.
% ------------------------------------------------------------------------------
% eps sig simple
% permittivity
eps_rgb = [10; 150; 200; 250];
eps_rel = [1; 2; 3.5; 5];
% conductivity
sig_rgb = [0; 150; 200; 250];
sig_ele = [0; 0.8; 2; 5]*1e-3;
% shape
shape_rgb = [10; 250];
shape_rel = [-1; 1];
% -------------
% shape
% -------------
p = polyfit(shape_rgb,shape_rel,numel(shape_rgb)-1);
shape = polyval(p,shape);
% % positivity
% shape = sqrt(shape.^2);
% just zeros and ones (for shapes)
shape_min = min(shape(:));
shape(shape>0) = 1;
shape(shape<=0)= 0;
% check
shape_rgb = linspace(min(shape_rgb(:)),max(shape_rgb(:)),100);
shape_rel = sqrt(polyval(p,shape_rgb).^2);
% -------------
% permittivity
% -------------
p = polyfit(eps_rgb,eps_rel,numel(eps_rgb)-1);
epsi = polyval(p,epsi);
% positivity
epsi = sqrt(epsi.^2);
% check
eps_rgb = linspace(min(eps_rgb(:)),max(eps_rgb(:)),100);
eps_rel = sqrt(polyval(p,eps_rgb).^2);
% -------------
% conductivity
% -------------
p = polyfit(sig_rgb,sig_ele,numel(sig_rgb)-1);
sigm = polyval(p,sigm);
% positivity
sigm = sqrt(sigm.^2);
% check
sig_rgb = linspace(min(sig_rgb(:)),max(sig_rgb(:)),100);
sig_ele = sqrt(polyval(p,sig_rgb).^2);
% ------------------------------------------------------------------------------
% % smooth it
% dx=x(2)-x(1);dz=z(2)-z(1);
% ax = 5; % 1/m
% az = 5; % 1/m
% ax=ax*dx;az=az*dz;
% epsi = smooth2d(epsi,ax,az);
% sigm = smooth2d(sigm,ax,az);
% ------------------------------------------------------------------------------
% save for full (rgb -> physical units) transform
figure;
subplot(3,3,[1,2,3,4,5,6])
fancy_imagesc(epsi)
colormap(rainbow2(1))
% colormap(summer)
xlabel('$n_x$')
ylabel('$n_z$')
title('relative permittivity $[\;]$')
fancy_figure()
subplot(3,3,[7,8,9])
plot(eps_rgb,eps_rel,'.');
axis tight
xlabel('rgb value')
ylabel('$\varepsilon \; [\;]$')
fancy_figure()
figure;
subplot(3,3,[1,2,3,4,5,6])
fancy_imagesc(1e+3*sigm)
colormap(rainbow2(1))
% colormap(summer)
xlabel('$n_x$')
ylabel('$n_z$')
title('conductivity $[mS/m]$')
fancy_figure()
subplot(3,3,[7,8,9])
plot(sig_rgb,1e+3*sig_ele,'.');
axis tight
xlabel('rgb value')
ylabel('$\sigma \; [mS/m]$')
fancy_figure()
% ------------------------------------------------------------------------------
load(strcat(mat_path,'x.mat'));
load(strcat(mat_path,'z.mat'));
% save for fancy figure file
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z)
colormap(rainbow2(1))
% colormap(summer)
xlabel('Length (m)')
ylabel('Depth (m)')
title('True permittivity ( )')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(1e+3*sigm,x,z)
colormap(rainbow2(1))
% colormap(summer)
xlabel('Length (m)')
ylabel('Depth (m)')
title('True conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(shape,x,z)
colormap(rainbow2(1))
% colormap(summer)
xlabel('Length (m)')
ylabel('Depth (m)')
title('Shape')
simple_figure()
% ------------------------------------------------------------------------------
% after checking all above steps, you can now save a .mat file
% ------------------------------------------------------------------------------
% save
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  % save path
  save_path = 'nature-synth/mat-file/';
  save(strcat( save_path , 'epsi.mat'), 'epsi' );
  save(strcat( save_path , 'sigm.mat'), 'sigm' );
  save(strcat( save_path , 'shape.mat'),'shape');
  fprintf('\n    ok. your project was saved in \n\n')
  fprintf('        %s\n\n',save_path)
else
  fprintf('\n ok. nothing saved. \n\n')
end
% % ----------------------------------------------------------------------------
% % example of usage outside this script
% % ----------------------------------------------------------------------------
% 
% % check it worked
% clear all
% % load path
% load_path = 'nature-synth/mat-file/';
% % .mat file name
% eps_name = 'eps-scatt';
% sig_name = 'sig-scatt';
% load(strcat( load_path, eps_name ,'.mat'));
% load(strcat( load_path, sig_name ,'.mat'));
% 
% figure; fancy_imagesc(epsi); axis tight; colormap(summer)
% figure; fancy_imagesc(sigm); axis tight; colormap(summer)
