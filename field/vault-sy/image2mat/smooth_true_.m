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
load(strcat(mat_path,'sigm.mat'));
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('True conductivity')
simple_figure()
% ------------------------------------------------------------------------------
% smooth it
ax = 0.8; % 1/m
az = 0.8; % 1/m
dx=x(2)-x(1); dz=z(2)-z(1);
ax=ax*dx;az=az*dz;
sigm = smooth2d(sigm,ax,az);
% ------------------------------------------------------------------------------
% sigm=sigm*0.5;
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Initial conductivity')
simple_figure()
% ------------------------------------------------------------------------------
% save
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  % save path
  save_path = 'nature-synth/initial-guess/';
  save(strcat( save_path , 'sigm_smooth.mat'), 'sigm' );
  fprintf('\n    ok. your project was saved in \n\n')
  fprintf('        %s\n\n',save_path)
else
  fprintf('\n ok. nothing saved. \n\n')
end
% ------------------------------------------------------------------------------