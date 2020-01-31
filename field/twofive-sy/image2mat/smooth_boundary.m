clear
close all
clc
% ------------------------------------------------------------------------------
% images path
image_path= 'nature-synth/images/';
mat_path  = 'nature-synth/mat-file/';
ini_path  = 'nature-synth/initial-guess/';
% ------------------------------------------------------------------------------
load(strcat(mat_path,'x.mat'));
load(strcat(mat_path,'z.mat'));
load(strcat(mat_path,'sigm.mat'));
load(strcat(mat_path,'epsi.mat'));
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z)
caxis([4 9])
colormap(rainbow2(0.7))
xlabel('Length (m)')
ylabel('Depth (m)')
title('ñ')
simple_figure()

figure;
plot(epsi,z,'b-'); axis ij
% ------------------------------------------------------------------------------
epsi_ = load(strcat(ini_path,'epsi_smooth_.mat'));
epsi_ = epsi_.epsi;
% ------------------------------------------------------------------------------
epsi_ = epsi_*0.96;
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi_,x,z)
caxis([4 9])
colormap(rainbow2(0.7))
xlabel('Length (m)')
ylabel('Depth (m)')
title('ñ')
simple_figure()
% ------------------------------------------------------------------------------
epsi(epsi>4) = 1;
epsi(epsi==4)= 0;
% ------------------------------------------------------------------------------
epsi = epsi_ .* epsi;
epsi(epsi==0) = 4;
% ------------------------------------------------------------------------------
% % smooth it
% ax = 2.5; % 1/m
% az = 2.5; % 1/m
% dx=x(2)-x(1); dz=z(2)-z(1);
% ax=ax*dx;az=az*dz;
% epsi = smooth2d(epsi,ax,az);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z)
caxis([4 9])
colormap(rainbow2(0.7))
xlabel('Length (m)')
ylabel('Depth (m)')
title('ñ')
simple_figure()
% ------------------------------------------------------------------------------
% save
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  % save path
  save_path = 'nature-synth/initial-guess/';
  save(strcat( save_path , 'epsi_smooth8.mat'), 'epsi' );
  fprintf('\n    ok. your project was saved in \n\n')
  fprintf('        %s\n\n',save_path)
else
  fprintf('\n ok. nothing saved. \n\n')
end
% ------------------------------------------------------------------------------