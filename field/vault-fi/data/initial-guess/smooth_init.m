% ------------------------------------------------------------------------------
% 
% take a model and make it smoother
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
load('../w/parame_.mat');
% ------------------------------------------------------------------------------
% load('epsi_linear.mat');
load('epsi_2l.mat');
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,parame_.x,parame_.z);
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Permittivity ( )')
simple_figure();
% ------------------------------------------------------------------------------
lo = parame_.w.c/( sqrt( parame_.w.eps_max ))/parame_.w.fo;
% round to nearest-bigger decimal (e.g. 0.561924 -> 0.6)
lo = ceil( lo/0.1 )*0.1;
ax = 1/(lo*10); % *15);
fprintf('\n   the smoothing was done with a gaussian filter of bandwidth %2.2d (1/m)\n',ax)
az = ax;
ax = 2*ax*parame_.dx;
az = 2*az*parame_.dx;
% ------------------------------------------------------------------------------
nx_pad = 800;
nz_pad = 400;
epsi = image_gaussian_pad(epsi,ax,az,'LOW_PASS',nx_pad,nz_pad);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,parame_.x,parame_.z);
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Permittivity Smooth ( )')
simple_figure();
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save this permittivity? (y/n)  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  save('epsi','epsi');
  fprintf('\n      ok, permittivity is saved now.\n\n    remember to overwrite parame_.mat with the one in\n\n     data/raw/PROJECT/w-data/data-mat-fwi/ \n\n    then you will have to run the fwd models to get an\n    amplitude correction for the source wavelet with \n\n                   src_amps.m\n\n')
else
  fprintf('\n    ok, permittivity is not saved.\n\n')
end
% ------------------------------------------------------------------------------