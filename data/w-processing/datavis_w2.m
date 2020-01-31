% ------------------------------------------------
%
% apply preprocessing and 
% image in time with gain-bandpass 
% a gpr radargram.
%
% ------------------------------------------------ 
% read data
% dewow
% fourier to see
% bandpass
% amputate receivers
% 2.5d --> 2d
% ----- preliminary velocity analysis -----
% instantaneous phase
% linear semblance velocity
% choose times of linear arrivals
% hyperbolic semblance velocity
% ----- get fwi discretization parameters -----
% choose t_fa, v_min, eps_max, eps_min and f_max
% compute dx, choose and compute dt_cfl
% ----- dispersion analysis -----
% linear mute
% ftan
% masw
% ----- source estimation -----
% linear moveout
% mute around selected event
% source estimation
% correct for time to
% correct for amplitude
% ------------------------------------------------------------------------------
close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
% WARNING:
% run after ss2gerjoii_w
% ss2gerjoii_w;
% ------------------------------------------------------------------------------
% constants
cf=0.9; % []
nl=10;  % []
% c=299792458; % [m/s]
c=0.299792458; % [m/ns]
% ns  --> s  | *1e-9
% MHz --> Hz | *1e+6
% GHz --> Hz | *1e+9
% ------------------------------------------------------------------------------
%   read .mat time shifted data
% ------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will process your shot-gather.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat/');
data_name_ = 'line';
% -
ls(data_path_);
prompt = '\n\n    tell me what line you want, eg 2:  ';
is = input(prompt,'s');
is=str2double(is);
% -
prompt = '    is this gerjoii synthetic data, (y or n):  ';
synthetic_ = input(prompt,'s');
% -
% ------------------------------------------------------------------------------
fprintf('\n\n------------------------------------------------\n');
fprintf('    peak into pre-processing for shot-gather %i',is);
fprintf('\n------------------------------------------------\n\n');
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
% load(strcat(data_path_,'s_r','.mat'));
d = radargram.d;
t = radargram.t; %          [ns]
dt = radargram.dt; %        [ns]
fo = radargram.fo; %        [GHz]
r = radargram.r; %          [m] x [m]
s = radargram.s; %          [m] x [m]
dr = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
% ------------------------------------------------------------------------------
fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
% ------------------------------------------------------------------------------
%   WARNING: this part is only for synthetic data
% -----------------------------------------------
if strcmp(synthetic_,'y')
  t = 1e+9 *t; %          [ns]
  dt = 1e+9 *dt; %        [ns]
  fo = 1e-9 *fo; %        [GHz]
end
% ------------------------------------------------------------------------------
% load preprocessing parameters
% ------------------------------------------------------------------------------
!head -n 25 pp_csg_w.m
fprintf('\n parameters that were used.\n\n');
pp_csg_w;
% ------------------------------------------------------------------------------
%   remove wow
% ------------------------------------------
fprintf('dewow\n');
d = dewow(d,dt,fo);
figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['raw but dewowed line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
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
%
figure;
plot(f,d_pow,'.-')
axis tight
xlabel('f (Hz)')
ylabel('d power')
title(['raw line # ',num2str(is)])
simple_figure()
%
figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('x (m)')
ylabel('f (GHz)')
title(['raw dB data. Line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   cook raw data. for "interpretation"
% ------------------------------------------
fprintf('bandpass\n');
% % UHF ambient signal (tv, garage remote, military, etc)
% f_low = 0.26; % [GHz]    0.26  0.33
% f_high = 0.46; % [GHz]   0.46  0.53
% % VHF radar signal
% f_low = 0.05; % [GHz]
% f_high = 0.3; % [GHz]
% VHF radar signal - "Frequencies of the Ricker wavelet" Yanghua Wang
% fo_ = fo*0.8; % [GHz]
% fc = 1.059095 * fo_; % [GHz]
% fb = 0.577472 * fo_; % [GHz]
% f_low = (fc-fb)/pi;
% f_high = (fc+fb)*(pi);
% % VHF radar signal - overhead line from train
% f_low = 0.175; % [GHz]
% f_high = 0.325; % [GHz]
% % overhead line from train
% f_low = 0.02; % [GHz]
% f_high = 0.1; % [GHz]
% ----
% filter
d = filt_gauss(d,dt,f_low,f_high,10);
% ---
% % apply power gain
% gpow = 1.7;
% d = gain_rt(d,gpow);
% ---
% % % normalize
% % d = normc(d);
% d_max=max(d);
% d = d./repmat(d_max,[nt,1]);
% ---
% fk domain and filter
% ar = 200*dr;   % # is in [1/m] . 13 3
% at = 2*dt;  % # is in [1/ns]
% [d, d_fk, fk_filt] = image_gaussian(d,ar,at,'LOW_PASS');
% vel_ = c; % [m/ns]
% [d, d_fk, fk_filt] = fk_filter(d,vel_,'VEL_CONE');
% % 
% [nr_,nt_] = size(d_fk);
% dk_ = 1/dr/nr_;
% df_ = 1/dt/nt_;
% k_=(-nr_/2:nr_/2-1)*dk_;
% f_=(-nt_/2:nt_/2-1)*df_;
% figure;
% fancy_imagesc(log10(abs(d_fk)),k_,f_)
% colormap(hsv)
% axis normal
% xlabel('k_x (1/m)')
% ylabel('f (1/ns)')
% title(['dB f-k data. Line # ',num2str(is)])
% simple_figure()
% figure;
% fancy_imagesc(fk_filt,k_,f_)
% axis normal
% xlabel('k_x (1/m)')
% ylabel('f (1/ns)')
% title('f-k filter')
% simple_figure()
% ---
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
% ---
% figure;
% hold on
% for i=1:nr
%   plot(f,d_pow(:,i),'-')
%   % plot(f,real(d_(:,i)),'.-')
% end
% hold off
% axis tight
% xlabel('f (GHz)')
% ylabel('$|\tilde{d}|$')
% title(['$[f_{low},\,f_{high}]=[$',...
%       num2str(f_low),', ',num2str(f_high),'$]\,GHz$'])
% simple_figure()
% -
figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('x (m)')
ylabel('f (GHz)')
title(['cooked dB data. Line # ',num2str(is)])
simple_figure()
%
figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['cooked line # ',num2str(is)])
simple_figure()
%
wigb(normc(d),1,rx,t);
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   amputate unwanted receivers
% ------------------------------------------
%{
fprintf('amputation\n');
% ----------------------------------
[d,r,dsr] = w_amputate(d,r,dsr,r_keepx_,r_keepx__);
rx=r(:,1);
%
figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['amputated line # ',num2str(is)])
simple_figure()
%}
% ------------------------------------------------------------------------------
%   2.5d --> 2d
% ------------------------------------------
%%{
fprintf('2.5d --> 2d\n');
v_ = 0.13;%0.055; % v_min; [m/ns]
sR = w_dsr(s,r);
filter_ = w_bleistein(t,sR,v_2d);
d = w_2_5d_2d(d,filter_);
%
figure;
fancy_imagesc(d,rx,t,0.2)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['2d line # ',num2str(is)])
simple_figure()
%%}
% ------------------------------------------------------------------------------
%   instantaneous phase
% ------------------------------------------
%{
fprintf('instantaneous phase\n')
d_anal = hilbert(d);
inst_phase = angle(d_anal);
inst_ampli = abs(d_anal);
figure;
fancy_imagesc(abs(inst_phase),rx,t);
axis normal
colormap(bone)
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['absolute value of instantaneous phase for line # ',num2str(is)])
simple_figure()
%}
% ------------------------------------------------------------------------------
%   preliminary velocity analysis
% ------------------------------------------------------------------------------
fprintf('\n---------------- preliminary velocity analysis -----------------\n\n');
% ------------------------------------------
% time shift
% ------------------------------------------
fprintf('correct for time to match when source was shot\n');
[d_shift,t_shift,t_sr] = w_timeshift(d,t,v_fa,dsr,t_fa);
% ------------------------------------------
%  linear velocity semblance for ALL shots
% ------------------------------------------
%{
fprintf('linear velocity semblance for all lines\n');
ns = 4; % 59
[v_analy_,d_last] = v_linear_(v,ns,nt,data_path_,data_name_);
%
figure;
subplot(1,2,1)
fancy_imagesc(v_analy_,v,t); 
axis normal;
axis square;
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Velocity (m/ns)')
title(['Linear s. All lines '])
simple_figure()
%
subplot(1,2,2)
fancy_imagesc(d_last,rx,t);
axis normal
axis square 
caxis([-max(abs(d_last(:))) max(abs(d_last(:)))]*0.1)
hold on
% plot(rx,t_hyper,'k--','linewidth',2)
% text(rx(fix(numel(rx)*0.5)), t_hyper(end)*1.2,...
%  strcat(num2str(v_pick),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
set(gca,'YTickLabel',[]);
xlabel('Receivers (m)')
title('Last line')
simple_figure()
%}
% ------------------------------------------
%  linear velocity semblance
% ------------------------------------------
fprintf('linear velocity semblance\n');
v_analy = v_linear(angle(hilbert(d_shift)),t_shift,rx,v);
%
figure('Position',[360 266 636 432]);
subplot(1,2,1)
fancy_imagesc(v_analy,v,t_shift);
axis normal
axis square 
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Velocity (m/ns)')
title(['Linear s. Line # ',num2str(is)])
simple_figure()
%
subplot(1,2,2)
fancy_imagesc(d_shift,rx,t_shift);
axis normal
axis square 
caxis([-max(abs(d_shift(:))) max(abs(d_shift(:)))]*0.1)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_sr,'k--','linewidth',2)
% plot(rx,t_hyper,'k--','linewidth',2)
% text(rx(fix(numel(rx)*0.5)), t_hyper(end)*1.2,...
%  strcat(num2str(v_pick),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
set(gca,'YTickLabel',[]);
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
% ------------------------------------------
%  choose times of linear arrivals
% ------------------------------------------
% % groningen
% t_air = 16;
% t_ground_  = 28;
% t_ground__ = 46;
% v_ground = 0.055;
% % groningen2
% t_air = 22;
% t_ground_  = 33; % 32; %<-line 21. % 34; %<-line 39. % 33; %<-line 1.
% t_ground__ = 41; % 40; %<-line 21. % 43; %<-line 39. % 40; %<-line 1.
% v_ground = 0.072; % 0.098; %<-line 21. % 0.09; %<-line 39. % 0.072; %<-line 1.
% % hat ranch
% t_air = 5;
% t_ground_  = 5; % 5;
% t_ground__ = 25; % 25;
% v_ground = 0.29;
% % box-simple
% t_air = 5;
% t_ground_  = 3;
% t_ground__ = 15; 
% v_ground = 0.149;
% % idaho-penitentiary
% t_air = 26;
% t_ground_  = 30;
% t_ground__ = 38; 
% v_ground = 0.09;
% ------------------------------------------
%   velocity analysis
% ------------------------------------------
fprintf('hyperbolic velocity analysis\n');
fprintf('  you can change the velocity picks in pp_csg_w.m\n');
fprintf('  time = %2.2d\n',to_pick);
fprintf('  velo = %2.2d\n',v_pick);
fprintf('  type & see file hyper_picks_w;\n');
fprintf('  and play with picks\n');
tic;
v_analy = v_hyperbolic(angle(hilbert(d_shift)),t_shift,rx,dsr,v,0);
toc;
[t_hyper,z_pick] = v_hyperbola(v_pick,to_pick,rx,dsr);
% hold on; plot(rx,t_hyper,'k--','linewidth',2);hold off
%
figure('Position',[360 266 636 432]);
subplot(1,2,1)
fancy_imagesc(v_analy,v,t_shift);
axis normal
axis square 
% hold on
% plot(v,15*ones(size(v)),'k--','linewidth',5)
% hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Velocity (m/ns)')
title(['Hyper s. Line # ',num2str(is)])
simple_figure()
%
subplot(1,2,2)
fancy_imagesc(d_shift,rx,t_shift);
axis normal
axis square 
caxis([-max(abs(d_shift(:))) max(abs(d_shift(:)))]*0.005)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_sr,'k--','linewidth',2)
plot(rx,t_hyper,'k--','linewidth',2)
text(rx(fix(numel(rx)*0.5)), t_hyper(end)*1.2,...
 strcat(num2str(v_pick),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
% ylabel('Time (ns)')
set(gca,'YTickLabel',[]);
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
% ---
figure;
fancy_imagesc(d_shift,rx,t_shift);
axis normal
axis square 
caxis([-max(abs(d_shift(:))) max(abs(d_shift(:)))]*0.005)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_sr,'k--','linewidth',2)
plot(rx,t_hyper,'k--','linewidth',2)
text(rx(fix(numel(rx)*0.5)), t_hyper(end)*1.2,...
 strcat(num2str(v_pick),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
%{
% ------------------------------------------
%   beamformer
% ------------------------------------------
fprintf('beamformer\n');
v_min = 0.05;
v_max = 0.299792458;
fo_ = linspace(f_low,f_high,100); % [Hz]
v = linspace(v_min,v_max,500);
theta = linspace(0,2*pi,100);
b = beamformer_thetav(fo_,r,d_,f,v,theta);
% b = beamformer_(30,locs,squeeze(d_(:,1,:)),f,v,theta);
b=abs(b).^2;
b=b/max(b(:));

% beamformer.b = b;
% beamformer.v = v;
% beamformer.theta = theta;
% beamformer.fo_ = fo_;
% beamformer.f = f;
% beamformer.d_ = d_;
% save(strcat('beamformer',num2str(is),'.mat'),'beamformer')

figure;
subplot(1,2,2)
fancy_polar(b.',v,theta)
% colorbar('off')
colormap(rainbow2(1))
simple_figure();
subplot(1,2,1)
imagesc(v,theta,b);
colormap(rainbow2(1))
axis square
xlabel('Velocity (m/s)')
ylabel('Angle (rad)')
title('Beamformer')
simple_figure();
%}
%{
% ------------------------------------------
%   choose t_fa, v_min, eps_max, eps_min and f_max
% ------------------------------------------
fprintf('computing dt and dx\n');
% groningen 30 28.5. 
% groningen2 23, 33.2
t_fa = 33.2; % [ns] 
% groningen 0.055
% groningen2 0.055
% box-simple 0.068
v_min = 0.068; % [m/ns] 
eps_max = (c/v_min)^2; % [ ]
eps_min = 1; % [ ]
f_max = 0.32; % [GHz]
% ------------------------------------------
%  compute dx, choose and compute dt_cfl
% ------------------------------------------
% compute dx
dx = v_min/(nl*f_max); % [m]
% compute dt
v_max = c./(sqrt(eps_min)); % [m/ns]
dt_cfl = cf*( 1./( v_max*sqrt(2/dx^2)  ) ); % [ns]
% ------------------------------------------
%  print
% ------------------------------------------
fprintf('\n')
fprintf('t fa       = %2.2d        [ns]\n',t_fa)
fprintf('vel max    = %2.2d  [m/ns]\n',v_max)
fprintf('eps min    = %2.2d        [ ]\n',eps_min)
fprintf('vel min    = %2.2d  [m/ns]\n',v_min)
fprintf('eps max    = %2.2d  [ ]\n',eps_max)
fprintf('f max      = %2.2d  [GHz]\n',f_max)
fprintf('dx         = %2.2d  [m]\n',dx)
fprintf('dt cfl     = %2.2d  [ns]\n\n',dt_cfl)
%}
%{
% ------------------------------------------------------------------------------
%   dispersion analysis
% ------------------------------------------------------------------------------
fprintf('\n-------------------- dispersion analysis -----------------------\n');
% ------------------------------------------
%  mute unwanted linear events
% ------------------------------------------
fprintf('linear mute\n');
% ground
to = t_ground_; %   [ns]
% % air
% to = 16; % [ns]
% vel_ = c; % [m/ns]
d = linear_mute(d,dr,t,to,v_ground);

figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['linear mute line # ',num2str(is)])
simple_figure()

wigb(d,1,rx,t);
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['linear mute line # ',num2str(is)])
simple_figure()
%}
%{
% ------------------------------------------
%   ftan - group velocity over frequencies
% ------------------------------------------
fprintf('ftan \n')
v__ = 0.4; % 0.18; % 0.29; % [m/ns]
v_  = 0.1; % 0.02; % 0.05; % [m/ns] 0.017. 0.02
dv = (v__-v_)*1e-4;   % [m/ns]
% make velocity and frequency vectors
f_disper = (f_low/1.5) : (df/2) : (f_high*1.5);  % [GHz] frequencies to scan over
v = v_ : dv : v__;  % [m/s] velocities to consider
% choose width of gaussian ftan filter
alph = 8; % 8
% receiver in meters 
rec_ = 12; % 5; % 2; % 25.75
% choose receiver to process
dro = d(:,binning(rx,rec_));
% distance from source to rec
dsr_ = dsr + abs(rec_-rx(1)); 
% ftan this guy
[disper_g_vf, disper_g_ft, dro_snr] = ftan(dro,dt,f_disper,v,alph,dsr_);
% (f,vg) curve picker
fvg_curve = max_mat(disper_g_vf, f_disper, v);
% NOTE:
% do a picker for (f,t) curve. this is what john does (kinda)
ft_curve = max_mat(abs(disper_g_ft), t, f_disper);

figure;
fancy_imagesc(disper_g_vf, f_disper, v);
colormap(hsv)
axis square;
% hold on
% curve = max_mat(disper_g_vf.', v, f_disper);
% plot(curve(:,1),curve(:,2),'k-','Linewidth',5)
% hold off
xlabel('$f \; [GHz]$'); 
ylabel('$v_g \; [m/ns]$');
title(['line # ',num2str(is), ' trace ',num2str(rec_),'$m$']);
simple_figure()

figure;
subplot(3,2,[1,2])
plot(t,dro,'k-')
axis tight
ylabel('amp');
title(['line # ',num2str(is), ' trace ',num2str(rec_),'$m$']);
simple_figure()
subplot(3,2,[3,4,5,6])
fancy_imagesc(abs(disper_g_ft), t, f_disper);
colormap(hsv)
axis normal;
ylabel('$f \; [GHz]$'); 
xlabel('$t \; [ns]$');
simple_figure()

figure;
subplot(2,3,[1,2,3])
plot(f_disper,fvg_curve(:,1),'k-')
axis tight
xlabel('$f \; [GHz]$'); 
ylabel('$v_g \; [m/ns]$');
title(['line # ',num2str(is), ' trace ',num2str(rec_),'$m$']);
simple_figure()
subplot(2,3,[4,5,6])
plot(t,ft_curve(:,1),'k-')
axis tight
xlabel('$t \; [ns]$'); 
ylabel('$f \; [GHz]$');
simple_figure()
%}
% ------------------------------------------
%   masw
% ------------------------------------------
%{
fprintf('masw\n');
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% make velocity and frequency vectors
f_disp = (f_low/1.5) : (df) : (f_high);  % [GHz] frequencies to scan over
v__ = 0.4; % 0.29; % 0.2; % 0.1; % [m/ns]
v_  = 0.2; % 0.05; % 0.02; % [m/ns]
dv = (v__-v_)*0.01;   % [m/ns]
vp = v_ : dv : v__;  % [m/s] velocities to consider
sx = 1./vp;
% masw
[disper_vxf,disper_sxf] = masw(d_,(rx-rx(1))+dsr,sx,f,f_disp);

figure; 
fancy_imagesc(disper_vxf,f_disp,vp); 
axis square 
colormap(jet)
% hold on
% curve = max_mat(disper_vxf,f_disp,vp);
% plot(curve(:,2),curve(:,1),'k-','Linewidth',5)
% hold off
xlabel('f (GHz)')
ylabel('$v_p\,[m/ns]$')
title(['line # ',num2str(is)])
simple_figure()
%}
% ------------------------------------------------------------------------------
%   source estimation
% ------------------------------------------------------------------------------
%%{
fprintf('\n----------------- source signature estimation ------------------\n');
% ------------------------------------------
%   linear moveout
% ------------------------------------------
fprintf('linear moveout\n');
d_lmo = lmo(d,t,rx,v_ground);

figure;
fancy_imagesc(d_lmo,rx,t)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['lmo line # ',num2str(is)])
simple_figure()
% ------------------------------------------
%   mute around selected event & source estimate
% ------------------------------------------
fprintf('mute around selected event\n');
% ground wave 
t_ = t_ground_; %   [ns]
t__ = t_ground__; % [ns]
[s_wvlet,d_muted,gaussian_] = lmo_source(d_lmo,t,t__,t_);
% ------------------------------------------
%   correct for time zero
% ------------------------------------------
% using velocity of propagation and dsr get time from src to first rec
t_sr = dsr/v_ground; % [ns]
% get time-zero (when src originated)
t_zero = t_ground_ - t_sr; % [ns]
% get time-zero in time-index
it_zero = binning(t,t_zero);
% shift source and gaussian up
s_wvlet( 1:nt-it_zero+1 ) = s_wvlet( it_zero:nt );
gaussian_( 1:nt-it_zero+1 ) = gaussian_( it_zero:nt );
% ---------------------
% amplitude estimation
% ---------------------
% compute distance from source to receivers
sR = w_dsr(s,r);
sR_ = (0:0.01:sR(end)).';
% get amplitudes from peak of lmo wave
[a_o,i_ao] = max(d_muted); a_o=a_o.';
% ------------------------------------------------------------------------------
% fix amplitudes
% ------------------------------------------------------------------------------
% window-mean the amplitudes
c=8; % 5 samples to mean 
[a_o,~] = window_mean(a_o,c);
% cut some stuff
cut_ = 15; % # of early samples to cut
a_o = a_o(cut_:end);
sR  = sR(cut_:end);
% ------------------------------------------------------------------------------
% fit hyperbola
[dd,bb,cc] = fit_hyperbola2(a_o,sR,[1; 1; 1]);
fprintf('hyperbola parameters are:\n')
fprintf('d=%2.2d  b=%2.2d  c=%2.2d\n',dd,bb,cc)
% amplitude at sR=0 (where source is)
a_ = dd./(bb).^cc;
% observations only
a_hyper = dd./(sR+bb).^cc;
% full domain
a_hyper_ = dd./(sR_+bb).^cc;

% correct for amplitude
s_wvlet = a_ * (s_wvlet/max(s_wvlet));
fprintf('amplitude at dsR=0 is %2.2d\n',a_)
% yee grid source
s_wvlet_ = integrate(s_wvlet,dt,0);
s_wvlet_ = - gaussian_.*s_wvlet_;

figure;
hold on
plot(t(1:fix(nt*0.3)),s_wvlet(1:fix(nt*0.3)),'k-','LineWidth',3);
plot(t(1:fix(nt*0.3)),s_wvlet_(1:fix(nt*0.3)),'r-');
hold off
axis tight
legend({'source','Yee-source'},'Location','best')
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
title(['Source for line # ',num2str(is)])
simple_figure()

figure;
hold on
plot(sR,a_o,'k.-','MarkerSize',15)
plot(sR,a_hyper,'r.-','MarkerSize',10)
plot(sR_,a_hyper_,'r-')
hold off
axis tight
legend({'observed','hyperbolic'},'Location','best')
ylabel('Amplitude (V/m)')
xlabel('Source-receiver (m)')
title(['Source amplitudes for line # ',num2str(is)])
simple_figure()

figure;
hold on
plot(sR,a_o,'k.-','MarkerSize',15)
plot(sR,a_hyper,'r.-','MarkerSize',10)
hold off
axis tight
legend({'observed','hyperbolic'},'Location','best')
ylabel('Amplitude (V/m)')
xlabel('Source-receiver (m)')
title(['Source amplitudes for line # ',num2str(is)])
simple_figure()
%%}


%{
% ------------------------------------------
% source signature
% ------------------------------------------
fprintf('source signature estimation\n');
% ------------
% shot-gather
% ------------
vel_ = 0.055; % 0.055; % [m/ns]
% % linear mute
% d = linear_mute(d,dr,t,30,vel_);
% get lmo 
d_lmo = lmo(d,t,dr,vel_);
% mute everything but lmo wave 
t_ = 30; % t_fa-2; % [ns]
t__ = 46; % 46; % [ns]
[s,d_muted,gaussian_] = lmo_source(d_lmo,t,t__,t_);
% using velocity of propagation and dsr get time from src to first rec
t_sr = dsr/vel_; % [ns]
% get time-zero (when src originated)
t_zero = t_ - t_sr; % [ns]
% get time-zero in time-index
it_zero = binning(t,t_zero);
% shift source and gaussian up
s( 1:nt-it_zero+1 ) = s( it_zero:nt );
gaussian_( 1:nt-it_zero+1 ) = gaussian_( it_zero:nt );
% ---------------------
% amplitude estimation
% ---------------------
sR_ = (0:0.01:sR(end)).';
% -----
% offset hyperbola
% -----
% get amplitudes from peak of lmo wave
[a_o,i_ao] = max(d_muted); a_o=a_o.';
[dd,bb,cc] = fit_hyperbola(a_o,sR);
fprintf('d=%2.2d  b=%2.2d  c=%2.2d\n',dd,bb,cc)
% amplitude at sR=0 (where source is)
a_ = dd./(bb).^cc;
% observations only
a_hyper = dd./(sR+bb).^cc;
% full domain
a_hyper_ = dd./(sR_+bb).^cc;

% correct for amplitude
s = a_ * (s/max(s));
fprintf('\n amplitude at dsR=0 is %2.2d\n',a_)

% integrate for Yee grid
s_ = integrate(s,dt,0);
s_ = - gaussian_.*s_;

figure;
fancy_imagesc(d_muted,rx,t,0.2)
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['line # ',num2str(is)])
simple_figure()
wigb(d_muted,1,rx,t);
axis normal
xlabel('receivers x (m)')
ylabel('Time (ns)')
title(['line # ',num2str(is)])
simple_figure()

figure;
hold on
plot(t,s,'k-','LineWidth',3);
plot(t,s_,'r-');
hold off
axis tight
legend({'source','Yee-source'},'Location','best')
xlabel('Time (ns)')
title(['source for line # ',num2str(is)])
simple_figure()

figure;
hold on
plot(sR,a_o,'k.-','MarkerSize',15)
plot(sR,a_hyper,'r.-','MarkerSize',10)
plot(sR_,a_hyper_,'r-')
hold off
axis tight
legend({'observed','hyperbolic'},'Location','best')
ylabel('$u\;[V/m]$')
xlabel('$\Delta sR\;[m]$')
title(['source amplitudes for line # ',num2str(is)])
simple_figure()

figure;
hold on
plot(sR,a_o,'k.-','MarkerSize',15)
plot(sR,a_hyper,'r.-','MarkerSize',10)
hold off
axis tight
legend({'observed','hyperbolic'},'Location','best')
ylabel('$u\;[V/m]$')
xlabel('$\Delta sR\;[m]$')
title(['source amplitudes for line # ',num2str(is)])
simple_figure()

%}
% ------------------------------------------------------------------------------
% save all current preprocessing parameters.
% this saves JUST the preprocessing parameters, 
% the data stays untouched.
% ------------------------------------------------------------------------------
% name = strcat(data_path_,data_name_,num2str( is ),'.mat');
% save( name , 'radargram' );
% load(strcat(data_path_,data_name_,num2str(is),'.mat'));