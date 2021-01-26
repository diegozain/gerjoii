close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
%
% see what the data looks like unclipped
%
% ------------------------------------------------------------------------------
f_ = 0.01;% GHz
f__= 0.5; % GHz
nf = 5000;  % number of frequency samples
it_ini = 60; % index number before which unclipping is not wanted
it_end = 300; % index number after which unclipping is not wanted
% ------------------------------------------------------------------------------
% must choose existing project:
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
% ------------------------------------------------------------------------------
fprintf('\n ------------------------------------------------------------------')
fprintf('\n   see what un-clipped data looks like for project: %s',project_name)
fprintf('\n   I will only save a picture, the data stays untouched.')
fprintf('\n ------------------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me what line you want:  ';
is = input(prompt,'s');
% ------------------------------------------------------------------------------
data_path_  = strcat('../raw/',project_name,'/w-data/','data-mat-raw/');
data_name_  = 'line';
% ------------------------------------------------------------------------------
load(strcat(data_path_,data_name_,is,'.mat'));
% ------------------------------------------------------------------------------
d   = radargram.d;
t   = radargram.t;   %        [ns]
dt  = radargram.dt;  %        [ns]
fo  = radargram.fo;  %        [GHz]
r   = radargram.r;   %        [m] x [m]
s   = radargram.s;   %        [m] x [m]
dr  = radargram.dr;  %        [m]
dsr = radargram.dsr; %        [m]
% ------------------------------------------------------------------------------
d_ = w_unclip_(d,dt,f_,f__,nf,it_ini,it_end);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(d,t,r(:,1));
axis normal
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
title('Clipped shot-gather')
simple_figure()

figure;
fancy_imagesc(d_,t,r(:,1));
axis normal
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
title('Un-clipped shot-gather')
simple_figure()

figure;
subplot(211)
hold on;
plot(t,d(:,1),'k-','linewidth',3)
plot(t,d_(:,1),'r-')
hold off;
axis tight
legend({'Observed','Un-clipped'})
ylabel('Amplitude (V/m)')
title('First receiver trace')
simple_figure()
% ------------------------------------------------------------------------------
d_filt = filt_gauss(d,dt,0.01,0.05,10);
d_filt_= filt_gauss(d_,dt,0.01,0.05,10);
% ------------------------------------------------------------------------------
subplot(212)
hold on;
plot(t,d_filt(:,1),'k-','linewidth',3)
plot(t,d_filt_(:,1),'r-')
hold off;
axis tight
legend({'Observed filtered','Un-clipped filtered'})
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
simple_figure()
% ------------------------------------------------------------------------------
figure;
subplot(211)
hold on;
plot(t(1:binning(t,400)),d(1:binning(t,400),1),'k-','linewidth',3)
plot(t(1:binning(t,400)),d_(1:binning(t,400),1),'-','color',[0.5,0.5,0.5])
hold off;
axis tight
ylabel('Amplitude (V/m)')
simple_figure()

subplot(212)
hold on;
plot(t(1:binning(t,400)),d_filt(1:binning(t,400),1),'k-','linewidth',3)
plot(t(1:binning(t,400)),d_filt_(1:binning(t,400),1),'-','color',[0.5,0.5,0.5])
hold off;
axis tight
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
simple_figure()
% ------------------------------------------------------------------------------
fig = gcf;fig.PaperPositionMode = 'auto'; print(gcf,'unclipped-smoothed','-dpng','-r600')
% ------------------------------------------------------------------------------
figure('Renderer', 'painters', 'Position', [10 10 600 200]);
hold on;
plot(t(1:binning(t,400)),d(1:binning(t,400),1),'k-','linewidth',3)
plot(t(1:binning(t,400)),d_(1:binning(t,400),1),'-','color',[0.5,0.5,0.5])
hold off;
axis tight
ylabel('Amplitude (V/m)')
xlabel('Time (ns)')
simple_figure()
% ------------------------------------------------------------------------------
fig = gcf;fig.PaperPositionMode = 'auto'; print(gcf,'unclipped','-dpng','-r600')
% ------------------------------------------------------------------------------