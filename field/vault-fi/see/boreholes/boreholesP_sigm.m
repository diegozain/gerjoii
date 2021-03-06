close all
clear
clc
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
load(strcat(path_,'sigm_topo.mat'))
x=sigm_topo.x;
z=sigm_topo.z;
sigm=sigm_topo.sigm;
% ------------------------------------------------------------------------------
z_max=nanmax(z);
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(sigm*1e+3,x,z);
colormap(rainbow2(2))
xlabel('Length (m)');
ylabel('Depth (m)');
title('Conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
xa1=binning(x,15.8);
xb5=binning(x,12.3);
xb2=binning(x,19.5);
% ------------------------------------------------------------------------------
A1s=sigm(:,xa1);
B2s=sigm(:,xb2);
B5s=sigm(:,xb5);
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
A1p=normali(A1p);
B2p=normali(B2p);
B5p=normali(B5p);
% ------------------------------------------------------------------------------
% % ax = 6.25e-01 1/m
% steep=8;
% f_high=2e-1;
% f_low =-f_high;
% % ----------------------------------------------------------------------------
% dz=min(diff(a1z));
% A1p_=filt_gauss(A1p,dz,f_low,f_high,steep);
% dz=min(diff(b2z));
% B2p_=filt_gauss(B2p,dz,f_low,f_high,steep);
% dz=min(diff(b5z));
% B5p_=filt_gauss(B5p,dz,f_low,f_high,steep);
% ------------------------------------------------------------------------------
A1s=normali(A1s);
B2s=normali(B2s);
B5s=normali(B5s);
% ------------------------------------------------------------------------------
figure;
% ------------------------------------------------------------------------------
subplot(1,3,1)
hold on;
plot(B5s,z,'r-')
plot(B5p,b5z,'k-')
% plot(B5p_,b5z,'b-')
hold off;
ylim([-1 z_max+1])
axis ij
ylabel('Depth (m)')
title('B5')
simple_figure()
% ------------------------------------------------------------------------------
subplot(1,3,2)
hold on;
plot(A1s,z,'r-')
plot(A1p,a1z,'k-')
% plot(A1p_,a1z,'b-')
hold off;
ylim([-1 z_max+1])
axis ij
xlabel('Normalized porosity and our conductivity')
ylabel('Depth (m)')
title('A1')
simple_figure()
% ------------------------------------------------------------------------------
subplot(1,3,3)
hold on;
plot(B2s,z,'r-')
plot(B2p,b2z,'k-')
% plot(B2p_,b2z,'b-')
hold off;
ylim([-1 z_max+1])
axis ij
ylabel('Depth (m)')
title('B2')
simple_figure()
% ------------------------------------------------------------------------------
% fig = gcf;fig.PaperPositionMode = 'auto';print(gcf,'p','-dpng','-r600')
% ------------------------------------------------------------------------------
% put gray line
% ------------------------------------------------------------------------------
A1s_=sigm(:,xa1);
B2s_=sigm(:,xb2);
B5s_=sigm(:,xb5);
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
% ------------------------------------------------------------------------------
% fig = gcf;fig.PaperPositionMode = 'auto'; print(gcf,'p','-dpng','-r600')
% ------------------------------------------------------------------------------