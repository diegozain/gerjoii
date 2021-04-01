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
load(strcat(mat_path,'epsi.mat'));
% ------------------------------------------------------------------------------
% smooth it
ax = 0.8; % 1/m
az = 0.8; % 1/m
dx=x(2)-x(1); dz=z(2)-z(1);
ax=ax*dx;az=az*dz;
epsi = smooth2d(epsi,ax,az);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('True conductivity')
simple_figure()
% ------------------------------------------------------------------------------
% MANUAL STEP 2
% 
% eps_rel = [6.5;   7; 6; 8; 9; 4];
% sig_ele = [1.5; 1.8; 2; 4; 5; 1]*1e-3;
% ------------------------------------------------------------------------------
% eps sig simple
% permittivity
eps_ = [7; 6; 9; 4];
sig_ = [2; 1.5; 5; 1]*1e-3;
% -------------
% permittivity
% -------------
p = polyfit(eps_,sig_,numel(eps_)-1);
sigm = polyval(p,epsi);
% positivity
% sigm = sqrt(sigm.^2);
% ------------------------------------------------------------------------------
% check
eps_ = linspace(min(eps_(:)),max(eps_(:)),100);
sig__ = sqrt(polyval(p,eps_).^2);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm,x,z)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Smooth conductivity')
simple_figure()
% ------------------------------------------------------------------------------
figure;
plot(eps_,sig__,'.-');
axis tight
xlabel('Permittivity ( )')
ylabel('Conductivity (mS/m) - interpolated')
simple_figure()
% ------------------------------------------------------------------------------
% save
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  % save path
  save_path = 'nature-synth/initial-guess/';
  save(strcat( save_path , 'sigm_smooth5.mat'), 'sigm' );
  fprintf('\n    ok. your project was saved in \n\n')
  fprintf('        %s\n\n',save_path)
else
  fprintf('\n ok. nothing saved. \n\n')
end
% ------------------------------------------------------------------------------