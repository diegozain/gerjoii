close all
clear
clc
% ------------------------------------------------------------------------------
%
% 
%
% ------------------------------------------------------------------------------
load('../../../../raw/idaho-peni/w-data/data-mat/graves.mat')
load('radar_energy.mat')
% ------------------------------------------------------------------------------
x_ = graves(:,1);
z_ = graves(:,2);
% ------------------------------------------------------------------------------
x = radar_energy.x;
z = radar_energy.z;
E = radar_energy.E;
% ------------------------------------------------------------------------------
x_ = binning(x,x_);
z_ = binning(z,z_);
x_ = x(x_);
z_ = z(z_);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(E,flip(x),z)
% colormap(rainbow2(1))
colormap(rainbow(0.3))
hold on
plot(x_,z_,'k.','markersize',40)
hold off
set(gca, 'XDir','reverse')
xlabel('Road (m)')
ylabel('Hill (m)')
title('Radar energy')
simple_figure()
% ------------------------------------------------------------------------------
% fig = gcf;fig.PaperPositionMode = 'auto'; print(gcf,'energy_graves','-dpng','-r600')
% ------------------------------------------------------------------------------