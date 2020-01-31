clear
close all
clc
% ------------------------------------------------------------------------------
% images path
image_path= 'nature-synth/images/';
mat_path  = 'nature-synth/mat-file/';
% ------------------------------------------------------------------------------
load(strcat(mat_path,'x.mat'));
load(strcat(mat_path,'z.mat'));
load(strcat(mat_path,'epsi2.mat'));
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z)
colormap(rainbow2(2))
xlabel('Length (m)')
ylabel('Depth (m)')
title('True permittivity')
simple_figure()
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
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  % save path
  save_path = 'nature-synth/initial-guess/';
  save(strcat( save_path , 'epsi_smooth6.mat'), 'epsi' );
  fprintf('\n    ok. your project was saved in \n\n')
  fprintf('        %s\n\n',save_path)
else
  fprintf('\n ok. nothing saved. \n\n')
end
% ------------------------------------------------------------------------------
