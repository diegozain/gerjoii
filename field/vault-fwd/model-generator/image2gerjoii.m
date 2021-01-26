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
mat_path   = 'nature-synth/mat-file/';
% image extention
image_exte = '.png'; % '.jpeg'; % '.png';
% ------------------------------------------------------------------------------
% images name
ls(image_path)
prompt = '\n\n    what last name (eg, -2 or whatever):  ';
last_name = input(prompt,'s');
% ------------------------------------------------------------------------------
eps_name = strcat('epsi',last_name);
sig_name = strcat('sigm',last_name);
% ------------------------------------------------------------------------------
% load images
eps_path = strcat(image_path, eps_name, image_exte );
sig_path = strcat(image_path, sig_name, image_exte );
% read
epsi = imread(eps_path);
sigm = imread(sig_path);
% uint8 to double
epsi = im2double(epsi)*255;
sigm = im2double(sigm)*255;
% squeeze to respective rgb channels
epsi = squeeze(epsi(:,:,1));
sigm = squeeze(sigm(:,:,2));
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
eps_rgb = [10; 240];
eps_rel = [4;  24];
% conductivity
sig_rgb = [10; 50];
sig_ele = [1;  5]*1e-3;
% ------------------------------------------------------------------------------
% permittivity
% ------------------------------------------------------------------------------
p = polyfit(eps_rgb,eps_rel,numel(eps_rgb)-1);
epsi = polyval(p,epsi);
% positivity
epsi = sqrt(epsi.^2);
% % just zeros and ones (for shapes)
% % comment possitivity first
% epsi_min = min(epsi(:));
% epsi(epsi>0) = 1;
% epsi(epsi<=0) = 0;
% check
eps_rgb = linspace(min(eps_rgb(:)),max(eps_rgb(:)),100);
eps_rel = sqrt(polyval(p,eps_rgb).^2);
% ------------------------------------------------------------------------------
% conductivity
% ------------------------------------------------------------------------------
p = polyfit(sig_rgb,sig_ele,numel(sig_rgb)-1);
sigm = polyval(p,sigm);
% positivity
sigm = sqrt(sigm.^2);
% check
sig_rgb = linspace(min(sig_rgb(:)),max(sig_rgb(:)),100);
sig_ele = sqrt(polyval(p,sig_rgb).^2);
% ------------------------------------------------------------------------------
% % smooth it
% load('nature-synth/mat-file/x.mat')
% load('nature-synth/mat-file/z.mat')
% dx=x(2)-x(1);dz=z(2)-z(1);
% ax = 0.8; % 1/m
% az = 0.8; % 1/m
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
% load(strcat(mat_path,'x.mat'));
% load(strcat(mat_path,'z.mat'));
% % save for fancy figure file
% figure;
% fancy_imagesc(epsi,x,z)
% colormap(rainbow2(1))
% % colormap(summer)
% xlabel('Length (m)')
% ylabel('Depth (m)')
% title('True permittivity ( )')
% simple_figure()
% figure;
% fancy_imagesc(1e+3*sigm,x,z)
% colormap(rainbow2(1))
% % colormap(summer)
% xlabel('Length (m)')
% ylabel('Depth (m)')
% title('True conductivity (mS/m)')
% simple_figure()
% ------------------------------------------------------------------------------
% after checking all above steps, you can now save a .mat file
% ------------------------------------------------------------------------------
% save
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  prompt = '\n\n    which subproject? (eg r1, v4):  ';
  project_ = input(prompt,'s');
  % save path
  save_path = 'nature-synth/mat-file/';
  save_path = strcat(save_path,strcat(project_,'/'));
  mkdir(save_path)
  save(strcat( save_path , 'epsi.mat'), 'epsi' );
  save(strcat( save_path , 'sigm.mat'), 'sigm' );
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
