clc
close all
clear
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will show you the data!')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
path_ ='../../data/boreholes/';
path__='../../data/w/';
project_ ='../../b38/output/wdc/'
% ------------------------------------------------------------------------------
epsi_a = 1;   % air
epsi_w = 80;  % water
epsi_m = 4.5; % soil matrix
% ------------------------------------------------------------------------------
% volumetric water content
thet_ = linspace(0,1,5e+2);
% ------------------------------------------------------------------------------
% porosity logs
load(strcat(path_,'A1P_MBMP.TXT'));
load(strcat(path_,'B2P_MBMP.TXT'));
load(strcat(path_,'B5P_MBMP.TXT'));
% ------------------------------------------------------------------------------
load(strcat(path__,'parame_.mat'));
load(strcat(project_,'epsi.mat'));
% ------------------------------------------------------------------------------
A1 = A1P_MBMP;
B2 = B2P_MBMP;
B5 = B5P_MBMP;
% ------------------------------------------------------------------------------
B5_x=12.3; % m
A1_x=15.8; % m
B2_x=19.5; % m
% ------------------------------------------------------------------------------
B5_z=B5(:,1); % m
A1_z=A1(:,1)-1.2; % m
B2_z=B2(:,1); % m
% ------------------------------------------------------------------------------
x=parame_.x;
z=parame_.z;
x_push=5; % m
% ------------------------------------------------------------------------------
x_ = 6;  % m
x__= 41; % m
z_ = 0;  % m
z__= 8;%15;  % m
% ------------------------------------------------------------------------------
x_ = binning(x,x_);
x__= binning(x,x__);
z_ = binning(z,z_);
z__= binning(z,z__);
% ------------------------------------------------------------------------------
epsi = epsi(z_:z__,x_:x__);
epsi_A1 = epsi(:,binning(x,A1_x));
% ------------------------------------------------------------------------------
z=z(z_:z__);
x=x(x_:x__)-x_push;
% ------------------------------------------------------------------------------
poro=A1(:,2);
thet=poro;
epsi_crim = ( poro.*sqrt(epsi_w) + (1-poro).*sqrt(epsi_m) ).^2;
% epsi_crim=(thet.*sqrt(epsi_w)+(poro-thet).*sqrt(epsi_a)+(1-poro).*sqrt(epsi_m)).^2;
% ------------------------------------------------------------------------------
figure;
plot(epsi_crim,A1_z);
axis ij
xlabel('Permittivity')
ylabel('Depth (m)')
title('Well A1')
simple_figure()
% ------------------------------------------------------------------------------
epsi_crim=epsi_crim(1:binning(A1_z,8));
% epsi_crim=epsi_crim(1:binning(A1_z,8),binning(thet_,0.24):binning(thet_,0.255));
A1_z = A1_z(1:binning(A1_z,8));
% ------------------------------------------------------------------------------
figure;
hold on
plot(epsi_crim,A1_z,'k-');
plot(epsi_A1,z,'r-','linewidth',5)
hold off
legend({'black: CRIM','red: JENX inversion'})
axis ij;
xlabel('Permittivity ( )')
ylabel('Depth (m)')
title('Well A1')
simple_figure()





