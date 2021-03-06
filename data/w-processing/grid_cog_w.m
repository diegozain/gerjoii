close all
clear
clc
% ------------------------------------------------------------------------------
%
% 
%
% ------------------------------------------------------------------------------
load('pics/idaho-penitentiary/cog/energy_h.mat')
x=energy.rx;
Eh=energy.E;
load('pics/idaho-penitentiary/cog/energy_v.mat')
Ev=energy.E;
z=energy.rx; 
% ------------------------------------------------------------------------------
Ev=Ev.';
% x=energy.rx; % from Eh
% z=energy.rx; % from Ev
% ------------------------------------------------------------------------------
[nz,ncogv] = size(Ev);
[ncogh,nx] = size(Eh);
% ------------------------------------------------------------------------------
zl=((0:2:(2*ncogh-1))+1).';
xl=(0:(ncogv-1)).';
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
xE = repmat(x.',[ncogh,1]);
zE = zl*ones(1,numel(x));
zE = zE.'; zE = zE(:);
% ------------------------------------------------------------------------------
E_ = zeros(numel(xE),3);
E_(:,1:2) = [xE,zE];
% E = [];
% ------------------------------------------------------------------------------
for i_=1:ncogh
  E_( ((i_-1)*numel(x)+1):(i_*numel(x)) ,3) = Eh(i_,:).';
  % E = [E ; Eh(i_,:).'];
end
% E_(:,3) = E;
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
zE = repmat(z.',[ncogv,1]);
xE = xl*ones(1,numel(z));
xE = xE.'; xE = xE(:);
% ------------------------------------------------------------------------------
E__ = zeros(numel(zE),3);
E__(:,1:2) = [xE,zE];
% E = [];
% ------------------------------------------------------------------------------
for i_=1:ncogv
  E__( ((i_-1)*numel(z)+1):(i_*numel(z)) ,3) = Ev(:,i_);
  % E = [E ; Ev(:,i_)];
end
% E__(:,3) = E;
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% list of (x,y) pts and their value in energy for
% both vertical and horizontal arrays.
E = [E_ ; E__];
% ------------------------------------------------------------------------------
fprintf(' I am going to interpolate now \n\n')
[xq,yq] = meshgrid(x, z);
E= griddata(E(:,1),E(:,2),E(:,3),xq,yq);
fprintf(' ...finished. \n\n')
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(E,x,z)
colormap(rainbow2(1))
xlabel('Road (m)')
ylabel('Hill (m)')
title('Radar energy')
simple_figure()
% ------------------------------------------------------------------------------
E(isnan(E)==1) = 0;
% ------------------------------------------------------------------------------
dx=x(2)-x(1);
dz=z(2)-z(1);
ax=1.3*dx;
az=1.3*dz;
E_ = smooth2d(E,ax,az);
% ------------------------------------------------------------------------------
E_ = normali(E_);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(E_,x,z)
% colormap(rainbow2(1))
colormap(rainbow())
grid on
xlabel('Road (m)')
ylabel('Hill (m)')
title('Radar energy')
simple_figure()
% ------------------------------------------------------------------------------
radar_energy = struct;
radar_energy.x = x;
radar_energy.z = z;
radar_energy.E = E_;
% ------------------------------------------------------------------------------
% save
prompt = '\n\n    do you want to save? (y or no):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  % save path
  save_path = 'pics/idaho-penitentiary/cog/';
  save(strcat( save_path , 'radar_energy.mat'), 'radar_energy' );
  fprintf('\n    ok. your project was saved in \n\n')
  fprintf('        %s\n\n',save_path)
else
  fprintf('\n ok. nothing saved. \n\n')
end
% ------------------------------------------------------------------------------
