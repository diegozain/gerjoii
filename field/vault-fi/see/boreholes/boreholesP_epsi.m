close all
clear
clc
% ------------------------------------------------------------------------------
load('../../data/initial-guess/epsi_topo.mat')
epsi_ini = epsi_topo.epsi;
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me what project you want:  ';
ls('../../');
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
ls(strcat('../../',project_,'/output/'));
prompt = '    Tell me w or dc or wdc:         ';
wdc_ = input(prompt,'s');
% ------------------------------------------------------------------------------
path_ = strcat('../../',project_,'/output/',wdc_,'/');
% ------------------------------------------------------------------------------
load(strcat(path_,'epsi_topo.mat'))
x=epsi_topo.x;
z=epsi_topo.z;
epsi=epsi_topo.epsi;
% ------------------------------------------------------------------------------
z_max=nanmax(z);
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(epsi,x,z);
colormap(rainbow2(0.6))
xlabel('Length (m)');
ylabel('Depth (m)');
title('Permittivity ( )')
simple_figure()
% ------------------------------------------------------------------------------
xa1=binning(x,15.8);
xb5=binning(x,12.3);
xb2=binning(x,19.5);
% ------------------------------------------------------------------------------
% fin
A1s=epsi(:,xa1);
B2s=epsi(:,xb2);
B5s=epsi(:,xb5);
% ------------------------------------------------------------------------------
% ini
A1s_ini=epsi_ini(:,xa1);
B2s_ini=epsi_ini(:,xb2);
B5s_ini=epsi_ini(:,xb5);
% ------------------------------------------------------------------------------
load('../../data/boreholes/A1porosity_MBMP.TXT')
load('../../data/boreholes/B2porosity_MBMP.TXT')
load('../../data/boreholes/B5porosity_MBMP.TXT')
% ------------------------------------------------------------------------------
A1p=A1porosity_MBMP;
B2p=B2porosity_MBMP;
B5p=B5porosity_MBMP;
% ------------------------------------------------------------------------------
a1z=A1p(:,1)-1;
b2z=B2p(:,1)-1;
b5z=B5p(:,1)-1;
% ------------------------------------------------------------------------------
A1p=A1p(:,2);
B2p=B2p(:,2);
B5p=B5p(:,2);
% ------------------------------------------------------------------------------
% pull borehole data up
% [~,a1z_min] = nanmin(A1s);
% [~,b2z_min] = nanmin(B2s);
% [~,b5z_min] = nanmin(B5s); 
a1z_min = icount_nans(A1s);
b2z_min = icount_nans(B2s);
b5z_min = icount_nans(B5s);
% ------------------------------------------------------------------------------
a1z_min = z(a1z_min);
b2z_min = z(b2z_min);
b5z_min = z(b5z_min);
% ------------------------------------------------------------------------------
a1z = a1z+a1z_min;
b2z = b2z+b2z_min;
b5z = b5z+b5z_min;
% ------------------------------------------------------------------------------
a1z=a1z(1:binning(a1z,z_max));
b2z=b2z(1:binning(b2z,z_max));
b5z=b5z(1:binning(b5z,z_max));
% ------------------------------------------------------------------------------
A1p=A1p(1:binning(a1z,z_max));
B2p=B2p(1:binning(b2z,z_max));
B5p=B5p(1:binning(b5z,z_max));
% ------------------------------------------------------------------------------
% for domain size and grey line
% ------------------------------------------------------------------------------
A1s_=epsi(:,xa1);
B2s_=epsi(:,xb2);
B5s_=epsi(:,xb5);

A1s_ini_=epsi_ini(:,xa1);
B2s_ini_=epsi_ini(:,xb2);
B5s_ini_=epsi_ini(:,xb5);
% ------------------------------------------------------------------------------
b5z__    = find(isnan(B5s_));
[~,b5z_] = max(diff(b5z__));
b5z_     = b5z_+1;
b5z_     = z(b5z__(b5z_));
%
a1z__    = find(isnan(A1s_));
[~,a1z_] = max(diff(a1z__));
a1z_     = a1z_+1;
a1z_     = z(a1z__(a1z_));
%
b2z__    = find(isnan(B2s_));
[~,b2z_] = max(diff(b2z__));
b2z_     = b2z_+1;
b2z_     = z(b2z__(b2z_));
% ------------------------------------------------------------------------------
max_depth = max([b5z_,a1z_,b2z_]);
% ------------------------------------------------------------------------------
%        crim permittivity
% 
%  epsi_crim = ( thet.*sqrt(epsi_w) + (poro - thet).*sqrt(epsi_a) + 
%                                                   (1-poro).*sqrt(epsi_m) ).^2;
% 
%  thet = volumetric water content 
%  poro = porosity 
% ------------------------------------------------------------------------------
epsi_a = 1;   % air
epsi_w = 80;  % water
epsi_m = 4.5; % soil matrix
% ------------------------------------------------------------------------------
poro = A1p;
epsi_crim_A1p = ( poro.*sqrt(epsi_w) + (1-poro).*sqrt(epsi_m) ).^2;
poro = B2p;
epsi_crim_B2p = ( poro.*sqrt(epsi_w) + (1-poro).*sqrt(epsi_m) ).^2;
poro = B5p;
epsi_crim_B5p = ( poro.*sqrt(epsi_w) + (1-poro).*sqrt(epsi_m) ).^2;
% ------------------------------------------------------------------------------
figure;
% ------------------------------------------------------------------------------
subplot(1,3,1)
hold on;
plot(B5s_ini,z,'b-')
plot(B5s,z,'r-')
plot(epsi_crim_B5p,b5z,'k-')
hold off;
ylim([-1 max_depth+1])
axis ij
ylabel('Depth (m)')
title('B5')
simple_figure()
% ------------------------------------------------------------------------------
subplot(1,3,2)
hold on;
plot(A1s_ini,z,'b-')
plot(A1s,z,'r-')
plot(epsi_crim_A1p,a1z,'k-')
hold off;
ylim([-1 max_depth+1])
axis ij
xlabel('CRIM and recovered Permittivity ( )')
title('A1')
simple_figure()
% ------------------------------------------------------------------------------
subplot(1,3,3)
hold on;
plot(B2s_ini,z,'b-')
plot(B2s,z,'r-')
plot(epsi_crim_B2p,b2z,'k-')
hold off;
ylim([-1 max_depth+1])
axis ij
title('B2')
simple_figure()
% ------------------------------------------------------------------------------
% save?
prompt = '\n\n    do you want to save this plot? (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  fig = gcf;
  fig.PaperPositionMode = 'auto';
  print(gcf,strcat(project_,'-CRIM'),'-dpng','-r200')
  fprintf('\n\n       your figure has been saved here. \n\n\n')
else
  fprintf('\n\n       ok, your fig was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------
% 
%       normalized values
% 
% ------------------------------------------------------------------------------
%{
A1p=normali(A1p);
B2p=normali(B2p);
B5p=normali(B5p);
% ------------------------------------------------------------------------------
A1s=normali(A1s);
B2s=normali(B2s);
B5s=normali(B5s);

A1s_ini=normali(A1s_ini);
B2s_ini=normali(B2s_ini);
B5s_ini=normali(B5s_ini);
% ------------------------------------------------------------------------------
figure;
% ------------------------------------------------------------------------------
subplot(1,3,1)
hold on;
plot(B5s_ini,z,'b-')
plot(B5s,z,'r-')
plot(B5p,b5z,'k-')
% plot(B5p_,b5z,'b-')
hold off;
ylim([-1 max_depth+1])
axis ij
ylabel('Depth (m)')
title('B5')
simple_figure()
% ------------------------------------------------------------------------------
subplot(1,3,2)
hold on;
plot(A1s_ini,z,'b-')
plot(A1s,z,'r-')
plot(A1p,a1z,'k-')
% plot(A1p_,a1z,'b-')
hold off;
ylim([-1 max_depth+1])
axis ij
xlabel('Normalized porosity and Permittivity')
ylabel('Depth (m)')
title('A1')
simple_figure()
% ------------------------------------------------------------------------------
subplot(1,3,3)
hold on;
plot(B2s_ini,z,'b-')
plot(B2s,z,'r-')
plot(B2p,b2z,'k-')
% plot(B2p_,b2z,'b-')
hold off;
ylim([-1 max_depth+1])
axis ij
ylabel('Depth (m)')
title('B2')
simple_figure()
% ------------------------------------------------------------------------------
% fig = gcf;fig.PaperPositionMode = 'auto';print(gcf,'p','-dpng','-r600')
% ------------------------------------------------------------------------------
% put gray line
% ------------------------------------------------------------------------------
subplot(1,3,1)
hold on;
plot(linspace(0,1,10),b5z_*ones(10,1),'--','color',[0.5,0.5,0.5])
hold off;
subplot(1,3,2)
hold on;
plot(linspace(0,1,10),a1z_*ones(10,1),'--','color',[0.5,0.5,0.5])
hold off;
subplot(1,3,3)
hold on;
plot(linspace(0,1,10),b2z_*ones(10,1),'--','color',[0.5,0.5,0.5])
hold off;
%}
% ------------------------------------------------------------------------------
% fig = gcf;fig.PaperPositionMode = 'auto'; print(gcf,'p','-dpng','-r600')
% ------------------------------------------------------------------------------