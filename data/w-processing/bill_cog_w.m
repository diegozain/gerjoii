% ------------------------------------------------
%
% apply preprocessing and 
% image in time with gain-bandpass 
% a gpr radargram.
%
% ------------------------------------------------ 
close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will quick-process your COG to impress Tate.')
fprintf('\n --------------------------------------------------------\n\n')
fprintf('you have to run this after ss2gerjoii2_cog_w.m!!\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat/');
ls(data_path_);
prompt = '    tell me cog-rs-# or cog-sr-#, eg rs-1:  ';
cog_ = input(prompt,'s');
data_name_ = strcat('cog-',cog_(1:3),cog_(4:end));
% ------------------------------------------------------------------------------
load(strcat(data_path_,data_name_,'.mat'));
d  = radargram.d;
t  = radargram.t; %          [ns]
dt = radargram.dt; %        [ns]
fo = radargram.fo; %        [GHz]
r  = radargram.r; %          [m] x [m]
dr = radargram.dr; %        [m]
dsr= radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
fny= 1/dt/2;
nt = numel(t);
rx = r(:,1);
nr = numel(rx);
fprintf('\n\n ----------------------------------------------------------')
fprintf('\n   peak into pre-processing for common-offset-gather %2.2d',dsr);
fprintf('\n\n ----------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
% load preprocessing parameters
% ------------------------------------------------------------------------------
!head -n 22 pp_cog_w.m
fprintf('\n parameters that would be used.\n\n');
prompt = ' do you want to use them? maybe they are in radargram! (y or n) ';
parame_load_ = input(prompt,'s');
if strcmp(parame_load_,'y')
  pp_cog_w;
elseif strcmp(parame_load_,'n')
  % bandpass. [GHz]
  f_low = radargram.f_low;
  f_high = radargram.f_high;
  % fk-filter. [1/m] & [1/ns]
  ar = radargram.ar;
  at = radargram.at;
  % first arrival time shift & velocity. [ns] & [m/ns]
  t_fa = radargram.t_fa;
  v_fa = radargram.v_fa;
  % svd filter 
  cut_off = radargram.cut_off;
  % amputate. [m]
  r_keepx_ = radargram.r_keepx_;
  r_keepx__= radargram.r_keepx__;
end
% ------------------------------------------------------------------------------
% ------------------------------------------
%   remove wow
% ------------------------------------------
% remove wow
d = dewow(d,dt,fo);
% background trace
bg_trace = sum(d,2)/size(d,2);
% remove back-ground trace
for r_=1:size(d,2)
d(:,r_) = d(:,r_) - bg_trace;
end
figure;
plot(t,bg_trace,'k-');
axis tight
ylabel('(V/m)')
xlabel('Time (ns)')
title('background trace')
simple_figure()

figure;
fancy_imagesc(d,rx,t,0.2)
axis normal
colormap(rainbow())
colorbar('off')
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['COG #',cog_(4:end),' raw. ',num2str(fo*1e+3),'MHz'])
simple_figure()
% ------------------------------------------
%   fourier
% ------------------------------------------
fprintf('fourier\n');
% taper edges to zero
% before fourier
%
for i=1:nr
  d(:,i) = d(:,i) .* tukeywin(nt,0.1);
end
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
% % normalize
% d_max_=max(d_pow);
% d_pow = d_pow./repmat(d_max_,[numel(f),1]);
figure;
hold on
for i=1:nr
plot(f,d_pow(:,i),'.-')
end
hold off
axis tight
xlabel('f (GHz)')
ylabel('power')
title(['COG ',num2str(fo*1e+3),'MHz'])
simple_figure()

figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('x (m)')
ylabel('f (GHz)')
title(['dB data. Cog ',num2str(fo*1e+3),'MHz'])
simple_figure()
% ------------------------------------------
%   cook raw data. for "interpretation"
% ------------------------------------------
fprintf('bandpass\n');
% % UHF ambient signal (tv, garage remote, military, etc)
% f_low = 0.26; % [GHz]    0.26  0.33
% f_high = 0.46; % [GHz]   0.46  0.53
% % VHF radar signal
% f_low = 0.05; % [GHz]
% f_high = 0.3; % [GHz]
% % VHF radar signal - "Frequencies of the Ricker wavelet" Yanghua Wang
% fo_ = 0.1; % [GHz]
% fc = 1.059095 * fo_; % [GHz]
% fb = 0.577472 * fo_; % [GHz]
% f_low = fc-fb;
% f_high = fc+fb;
% % VHF radar signal - overhead line from train
% f_low = 0.175; % [GHz]
% f_high = 0.325; % [GHz]
% % overhead line from train
% f_low = 0.02; % [GHz]
% f_high = 0.1; % [GHz]
% -------
% filter
d = filt_gauss(d,dt,f_low,f_high,10);
% -------
% % apply power gain
% gpow = 5;
% d = gain_rt(d,gpow);

% % normalize
% d = normc(d);
d_max=max(d);
d = d./repmat(d_max,[nt,1]);

% fk domain and filter.
% smaller # -> bigger smudge
fprintf('fk filter\n');
ar = ar*dr;   % # is in [1/m] . 13 3
at = at*dt;  % # is in [1/ns]
[d, d_fk, fkfilter] = image_gaussian(d,ar,at,'LOW_PASS');
[nr_,nt_] = size(d_fk);
dk_ = 1/dr/nr_;
df_ = 1/dt/nt_;
k_=(-nr_/2:nr_/2-1)*dk_;
f_=(-nt_/2:nt_/2-1)*df_;

figure;
subplot(1,2,1)
fancy_imagesc(log10(abs(d_fk)),k_,f_)
colorbar('off')
colormap(hsv)
axis normal
axis square
xlabel('x (1/m)')
ylabel('f (1/ns)')
title('dB fk-data')
freezeColors();
simple_figure()
subplot(1,2,2)
fancy_imagesc(fkfilter,k_,f_)
colorbar('off')
axis normal
axis square
xlabel('x (1/m)')
% ylabel('f (1/ns)')
set(gca,'YTickLabel',[]);
title('fk-filter')
freezeColors();
simple_figure()

% % normalize
% d = normc(d);
% d_max=max(d);
% d = d./repmat(d_max,[nt,1]);

% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;

figure;
fancy_imagesc(log10(d_pow),rx,f);
colormap(hsv)
axis normal
xlabel('x (m)')
ylabel('f (GHz)')
title(['cooked dB data. Cog ',num2str(fo*1e+3),'MHz'])
simple_figure()

figure;
fancy_imagesc(d,rx,t,1)
axis normal
colormap(rainbow())
colorbar('off')
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['COG #',cog_(4:end),' bandpassed. ',num2str(fo*1e+3),'MHz'])
simple_figure()
% ------------------------------------------------------------------------------
% time shift
% ------------------------------------------------------------------------------
fprintf('correct for time to match when source was shot\n');
[d,t,t_sr] = w_timeshift(d,t,v_fa,dsr,t_fa);

figure;
fancy_imagesc(d,rx,t,1)
% fancy_imagesc(d(1:binning(t,300),:),rx,t(1:binning(t,300)),1)
axis normal
colormap(rainbow())
colorbar('off')
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Common offset-gather # ',cog_(4:end)])
simple_figure()
% ------------------------------------------------------------------------------
%   svd filter
% ------------------------------------------------------------------------------
fprintf('svd filter\n');
[nt,nr]=size(d);
[V,E,Q]=svd(d);
E(1:cut_off,1:nr)=zeros(cut_off,nr);
d = V*E*Q';
d = d./repmat(max(d),[nt,1]);

figure;
fancy_imagesc(d,rx,t,0.7)
axis normal
colormap(rainbow())
colorbar('off')
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['COG #',cog_(4:end),' svd. ',num2str(fo*1e+3),'MHz'])
simple_figure()
% % ------------------------------------------
% %   ftan - group velocity over frequencies
% % ------------------------------------------
% fprintf('ftan \n')
% v_  = 0.005; % 0.05; % [m/ns]
% v__ = 0.03; % 0.29; % [m/ns]
% dv = (v__-v_)*0.01;   % [m/ns]
% % make velocity and frequency vectors
% f_disper = (f_low/1.5) : (df/2) : (f_high*1.5);  % [GHz] frequencies to scan over
% v = v_ : dv : v__;  % [m/s] velocities to consider
% % choose width of gaussian ftan filter
% alph = 8;
% % receiver in meters 
% rec_ = 10.1; % 25.75;
% % choose receiver to process
% dro = d(:,binning(rx,rec_));
% % distance from source to rec
% dsr_ = 0.3; % 0.3 , 1.4; % dsr; % [m]
% % ftan this guy
% [disper_g_vf, disper_g_ft, dro_snr] = ftan(dro,dt,f_disper,v,alph,dsr_); 
% 
% % % 
% % d_rt = d_cog_f(d,dt,f_disper,v,alph,dsr_);
% % figure;
% % fancy_imagesc(d_rt,rx,t,1)
% % axis normal
% % xlabel('receivers $x\,[m]$')
% % ylabel('$t\,[ns]$')
% % title(['common offset gather ',num2str(dsr),'$m$'])
% % fancy_figure()
% 
% figure;
% fancy_imagesc(disper_g_vf, f_disper, v);
% colormap(hsv)
% axis square;
% % hold on
% % curve = max_mat(disper_g_vf.', v, f_disper);
% % plot(curve(:,1),curve(:,2),'k-','Linewidth',5)
% % hold off
% xlabel('$f \; [GHz]$'); 
% ylabel('$v_g \; [m/ns]$');
% title(['cog ',num2str(dsr), ' trace ',num2str(rec_),'$ [m]$']);
% fancy_figure()
% 
% figure;
% subplot(3,2,[1,2])
% plot(t,dro,'k-')
% axis tight
% ylabel('amp');
% title(['cog ',num2str(dsr), ' trace ',num2str(rec_),'$ [m]$']);
% fancy_figure()
% subplot(3,2,[3,4,5,6])
% fancy_imagesc(abs(disper_g_ft), t, f_disper);
% colormap(hsv)
% axis normal;
% ylabel('$f \; [GHz]$'); 
% xlabel('$t \; [ns]$');
% fancy_figure()
% % ------------------------------------------
% %   2.5d --> 2d
% % ------------------------------------------
% fprintf('2.5d --> 2d\n');
% v_ = 0.055; % v_min; [m/ns]
% sR = w_dsr(s,r);
% filter_ = w_bleistein(t,sR,v_);
% d = w_2_5d_2d(d,filter_);
% 
% figure;
% fancy_imagesc(d,rx,t,0.2)
% axis normal
% xlabel('receivers $x\,[m]$')
% ylabel('$t\,[ns]$')
% title(['2d line \# ',num2str(is)])
% fancy_figure()
% 
% wigb(d,1,rx,t);
% axis normal
% xlabel('receivers $x\,[m]$')
% ylabel('$t\,[ns]$')
% title(['2d line \# ',num2str(is)])
% fancy_figure()

% ------------------------------------------------------------------------------
% save all current preprocessing parameters.
% this saves JUST the preprocessing parameters, 
% the data stays untouched.
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save all current preprocessing parameters? (y or n):  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  name = strcat(data_path_,data_name_,'.mat');
  save( name , 'radargram' );
  load(strcat(data_path_,data_name_,'.mat'));
end