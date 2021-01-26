% ------------------------------------------------------------------------------
% 
% make a 2d model from flat topography with a first layer
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
epsi_up  = 4;
epsi_down=20;
% ------------------------------------------------------------------------------
load('../w/parame_.mat');
topo_=load('../bhrs-topo.txt');
% ------------------------------------------------------------------------------
x=parame_.x;
z=parame_.z;
z_=topo_(:,2).';
x_=topo_(:,1).';
m=(z_(end)-z_(1))/(x_(end)-x_(1));
% ------------------------------------------------------------------------------
nx=numel(x);
nz=numel(z);
epsi=epsi_down*ones(nz,nx);
% ------------------------------------------------------------------------------
zi=m*x-m+1;
for ix=1:nx
epsi(1:binning(z,zi(ix)),ix)=epsi_up;
end
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(epsi,x,z);
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Permittivity ( )')
simple_figure();
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save this permittivity? (y/n)  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  save('epsi_2l','epsi');
  fprintf('\n      ok, permittivity is saved now.\n\n    remember to overwrite parame_.mat with the one in\n\n     data/raw/PROJECT/w-data/data-mat-fwi/ \n\n    then you will have to run the fwd models to get an\n    amplitude correction for the source wavelet with \n\n                   src_amps.m\n\n')
else
  fprintf('\n    ok, permittivity is not saved.\n\n')
end
% ------------------------------------------------------------------------------
