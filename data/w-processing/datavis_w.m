% ------------------------------------------------------------------------------
%
% apply preprocessing to gpr radargram.
%
% ------------------------------------------------------------------------------
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
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n             I will process your shot-gather.')
fprintf('\n --------------------------------------------------------\n\n')
fprintf('           Make sure you ran ss2gerjoii_w.m first\n\n')

fprintf('           You will need to either run this script for all \n')
fprintf('           lines you intend to use in the inversion, or\n')
fprintf('           run datablitz_w.m once. \n\n')
% ------------------------------------------------------------------------------
ls('../raw/');
prompt = '\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat');
% ------------------------------------------------------------------------------
y_n = 'n';
if exist(strcat('../raw/',project_name,'/w-data/pp_csg_w.m'))==2
  fprintf('\n       be careful. The file pp_csg_w.m already exists in \n')
  fprintf('\n           %s\n',strcat('../raw/',project_name,'/w-data/'))
  prompt ='\n       do you want to use that one instead? (y or n) ';
  y_n = input(prompt,'s');
end
% ------------------------------------------------------------------------------
data_name_ = 'line';
fprintf('\n   these are the ones that have been done so far...\n\n');
ls(data_path_);
prompt = '\n    tell me which line you want, eg 2       :  ';
is = input(prompt,'s');
is=str2double(is);
% ------------------------------------------------------------------------------
prompt = '    is this gerjoii synthetic data, (y or n):  ';
synthetic_ = input(prompt,'s');
% ------------------------------------------------------------------------------
fprintf('\n\n------------------------------------------------\n');
fprintf('    peak into pre-processing for shot-gather %i',is);
fprintf('\n------------------------------------------------\n\n');
% ------------------------------------------------------------------------------
y_n_ = 'n';
if exist(strcat(data_path_,'/',data_name_,num2str(is),'.mat'))==2
  
  fprintf('\n       be careful. The this line already exists in')
  fprintf('\n           %s',strcat(data_path_,'/'))
  prompt ='\n       do you want to use that one instead? (y or n) ';
  y_n_ = input(prompt,'s');
end
if strcmp(y_n_,'y')
  load(strcat(data_path_,'/',data_name_,num2str(is),'.mat'));
  % bandpass. [GHz]
  f_low = radargram.f_low;
  f_high= radargram.f_high;
  % amputate. [m]
  r_keepx_ = radargram.r_keepx_;
  r_keepx__= radargram.r_keepx__;
  % first arrival time shift & velocity. [ns] & [m/ns]
  t_fa = radargram.t_fa;
  v_fa = radargram.v_fa;
  % ground time-window & velocity. [ns] & [m/ns]
  t_ground_ = radargram.t_ground_;
  t_ground__= radargram.t_ground__;
  v_ground  = radargram.v_ground;
  % stability of wave solver. [m/ns] & [GHz]
  v_min = radargram.v_min; 
  % velocity picks from hyperbolic semblance
  v_pick = radargram.v_pick;
  to_pick= radargram.to_pick;
  % velocity for 2d transform. [m/ns]
  v_2d = radargram.v_2d;
  % linear mute
  v_mute = radargram.v_mute;
  t_mute = radargram.t_mute;
  % polarity flip
  if isfield(radargram,'flip_polarity')
    flip_polarity = radargram.flip_polarity;
  end
else
  load(strcat(data_path_,'-raw/',data_name_,num2str(is),'.mat'));
end
% load(strcat(data_path_,'s_r','.mat'));
% ------------------------------------------------------------------------------
d   = radargram.d;
t   = radargram.t;  %        [ns]
dt  = radargram.dt; %        [ns]
fo  = radargram.fo; %        [GHz]
r   = radargram.r;  %        [m] x [m]
s   = radargram.s;  %        [m] x [m]
dr  = radargram.dr; %        [m]
dsr = radargram.dsr;%        [m]rx=s_r{is,2}(:,1);
% ------------------------------------------------------------------------------
fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
% ------------------------------------------------------------------------------
if strcmp(y_n_,'y')
  f_max = 1/dt/5;
  % -- 
  v_pick  = 0.065; % [m/ns]
  to_pick = 151;  % [ns]
  % ----------------------------------
  % choose max-min velocities
  % ----------------------------------
  v__ = 0.3; % [m/ns]
  v_  = 0.03; % [m/ns] (velocity of water 0.03m/ns, rel perm~80)
  dv = (v__-v_)*0.01;   % [m/ns]
  v = v_ : dv : v__;  % [m/s] velocities to consider
  % ----------------------------------
  % choose velocity picks
  % ----------------------------------
  [t_hyper,z_pick] = v_hyperbola(v_pick,to_pick,rx,dsr);
end
% ------------------------------------------------------------------------------
%   WARNING: this part is only for synthetic data
% ------------------------------------------------------------------------------
if strcmp(synthetic_,'y')
  t = 1e+9 *t; %          [ns]
  dt= 1e+9 *dt; %        [ns]
  fo= 1e-9 *fo; %        [GHz]
end
% ------------------------------------------------------------------------------
% get rid of clipped traces! this here visualizes that.
% ------------------------------------------------------------------------------
wigb(normc(d),1,rx,t);
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Line # ',num2str(is),' raw but normalized'])
simple_figure()
% ------------------------------------------------------------------------------
% load preprocessing parameters
% ------------------------------------------------------------------------------
if ~strcmp(y_n_,'y')
  pwd_=pwd;
  if strcmp(y_n,'y')
    cd(strcat('../raw/',project_name,'/w-data/'))
    !head -n 34 pp_csg_w.m
    pp_csg_w;
    cd(pwd_);
  else
    !head -n 34 pp_csg_w.m
    pp_csg_w;
  end
  fprintf('\n parameters that were used.\n\n');
  fprintf('\n---------------- filter and 2dfy -------------------------------\n\n');
end
% ------------------------------------------------------------------------------
% flip polarity of shot-gather
% ------------------------------------------------------------------------------
if exist('flip_polarity')
  fprintf('flip polarity\n');
  d=-d;
end
% ------------------------------------------------------------------------------
%   remove wow
% ------------------------------------------------------------------------------
fprintf('dewow\n');
d = dewow(d,dt,fo);
figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['raw but dewowed line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   fourier
% ------------------------------------------------------------------------------
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
xlabel('Frequency (GHz)')
ylabel('Power')
title(['raw line # ',num2str(is)])
simple_figure()
%
figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('x (m)')
ylabel('Frequency (GHz)')
title(['raw dB data. Line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   amputate unwanted receivers
% ------------------------------------------------------------------------------
fprintf('amputation\n');
[d,r,dsr] = w_amputate(d,r,dsr,r_keepx_,r_keepx__);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
%
figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Amputated Line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   cook raw data. for "interpretation"
% ------------------------------------------------------------------------------
fprintf('bandpass\n');
% filter
d = filt_gauss(d,dt,f_low,f_high,10);
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
% -
figure;
plot(f,d_pow,'.-')
axis tight
xlabel('Frequency (GHz)')
ylabel('Power')
title(['cooked line # ',num2str(is)])
simple_figure()
%
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
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['cooked line # ',num2str(is)])
simple_figure()
%
wigb(normc(d),1,rx,t);
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Normalized cooked line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   2.5d --> 2d
% ------------------------------------------------------------------------------
%%{
fprintf('2.5d --> 2d\n');
sR = w_dsr(s,r);
filter_ = w_bleistein(t,sR,v_2d);
d = w_2_5d_2d(d,filter_);
%
figure;
fancy_imagesc(d,rx,t,0.2)
colormap(rainbow())
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['2D Line # ',num2str(is)])
simple_figure()
%%}
% ------------------------------------------------------------------------------
%   preliminary velocity analysis
% ------------------------------------------------------------------------------
fprintf('\n---------------- preliminary velocity analysis -----------------\n\n');
% ------------------------------------------
%  linear velocity semblance
% ------------------------------------------
fprintf('linear velocity semblance\n');
v_analy = v_linear(angle(hilbert(d)),t,rx,v);
%
figure('Position',[360 266 636 432]);
subplot(1,2,1)
fancy_imagesc(v_analy,v,t);
axis normal
axis square 
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Velocity (m/ns)')
title(['Linear S. Line # ',num2str(is)])
simple_figure()
%
subplot(1,2,2)
fancy_imagesc(d,rx,t);
axis normal
axis square 
caxis([-max(abs(d(:))) max(abs(d(:)))]*0.1)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_fa,'k--','linewidth',2)
plot(rx,(1/v_ground)*(rx-rx(1))+t_ground_,'g--','linewidth',2)
plot(rx,(1/v_ground)*(rx-rx(1))+t_ground__,'g--','linewidth',2)
text(rx(fix(numel(rx)*0.5)), t_ground__*3,...
 strcat(num2str(v_ground),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
% set(gca,'YTickLabel',[]);
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
%
figure;
fancy_imagesc(d,rx,t);
axis normal
axis square 
caxis([-max(abs(d(:))) max(abs(d(:)))]*0.1)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_fa,'k-.','linewidth',2)
plot(rx,(1/v_ground)*(rx-rx(1))+t_ground_,'g--','linewidth',2)
plot(rx,(1/v_ground)*(rx-rx(1))+t_ground__,'g--','linewidth',2)
text(rx(fix(numel(rx)*0.5)), t_ground__*3,...
 strcat(num2str(v_ground),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Receivers (m)')
title(['Linear Event. Line # ',num2str(is)])
simple_figure()
% ------------------------------------------
% time shift
% ------------------------------------------
fprintf('correct for time to match when source was shot\n');
[d_shift,t_shift,t_sr] = w_timeshift(d,t,v_fa,dsr,t_fa);
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
title(['Hyper S. Line # ',num2str(is)])
simple_figure()
%
subplot(1,2,2)
fancy_imagesc(d_shift,rx,t_shift);
axis normal
axis square 
caxis([-max(abs(d_shift(:))) max(abs(d_shift(:)))]*0.05)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_sr,'k--','linewidth',2)
plot(rx,t_hyper,'g--','linewidth',2)
text(rx(fix(numel(rx)*0.5)), t_hyper(end)*1.2,...
 strcat(num2str(v_pick),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
%set(gca,'YTickLabel',[]);
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
% ---
figure;
fancy_imagesc(d_shift,rx,t_shift);
axis normal
axis square 
caxis([-max(abs(d_shift(:))) max(abs(d_shift(:)))]*0.05)
hold on
plot(rx,(1/c)*(rx-rx(1))+t_sr,'k--','linewidth',2)
% plot(rx,(1/c)*(rx-rx(1))+150,'k--','linewidth',2)
plot(rx,t_hyper,'g--','linewidth',2)
text(rx(fix(numel(rx)*0.5)), t_hyper(end)*1.2,...
 strcat(num2str(v_pick),'m/ns'),'color','black','fontweight','bold')
hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Receivers (m)')
title(['Time shifted w/ hyperbolic event. Line # ',num2str(is)])
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
fprintf('---------------- computing dt and dx ---------------- \n');
% ------------------------------------------
%  compute dx, choose and compute dt_cfl
% ------------------------------------------
eps_max = (c/v_min)^2; % [ ]
eps_min = 1; % [ ]
% compute dx
dx = v_min/(nl*f_max); % [m]
% compute dt
v_max = c./(sqrt(eps_min)); % [m/ns]
dt_cfl = cf*( 1./( v_max*sqrt(2/dx^2)  ) ); % [ns]
% ------------------------------------------
%  print
% ------------------------------------------
fprintf('eps max    = %2.2d  [ ]\n',eps_max)
fprintf('f max      = %2.2d  [GHz]\n',f_max)
fprintf('dx         = %2.2d  [m]\n',dx)
fprintf('dt cfl     = %2.2d  [ns]',dt_cfl)
% ------------------------------------------------------------------------------
%   fourier interpolation
% ------------------------------------------------------------------------------
fprintf('\n----------------- fourier interpolation --------------------------\n');
[d,t] = interp_fourier(d,t,dt,dt_cfl);
fprintf('nt         = %2.2d  [# of index]\n',nt)
nt = numel(t);
dt = dt_cfl;
fprintf('nt cfl     = %2.2d  [# of index]',nt)
% ------------------------------------------------------------------------------
%   source estimation
% ------------------------------------------------------------------------------
%%{
fprintf('\n----------------- source signature estimation --------------------\n');
% ------------------------------------------
%   linear moveout
% ------------------------------------------
fprintf('linear moveout\n');
d_lmo = lmo(d,t,rx,v_ground);

figure;
fancy_imagesc(d_lmo,rx,t)
caxis([-max(abs(d_lmo(:))) max(abs(d_lmo(:)))]*0.005)
colormap(rainbow())
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['LMO with selected velocity. Line # ',num2str(is)])
simple_figure()
% ------------------------------------------
%   mute around selected event & source estimate
% ------------------------------------------
fprintf('mute and stack around selected event\n');
% ground wave 
t_  = t_ground_ ;%+ t_fa-t_sr; %   [ns]
t__ = t_ground__;%+ t_fa-t_sr; % [ns]
[s_wvlet,d_muted,gaussian_] = lmo_source(d_lmo,t,t__,t_);
% figure;plot(t,s_wvlet)
% ------------------------------------------
%   correct for time zero
% ------------------------------------------
% using velocity of propagation and dsr get time from src to first rec
t_sr = dsr/v_ground; % [ns]
% get time-zero (when src originated)
t_zero = t_ground_ - t_sr; % [ns]
% get time-sr in time-index
it_sr = binning(t,t_sr);
% shift source and gaussian up
s_wvlet( 1:(nt-it_sr+1) )  = s_wvlet( it_sr:nt );
gaussian_( 1:(nt-it_sr+1) )= gaussian_( it_sr:nt );
% ---------------------
% amplitude estimation
% ---------------------
% compute distance from source to receivers
sR = w_dsr(s,r);
sR_= (0:0.01:sR(end)).';
% get amplitudes from peak of lmo wave
[a_o,i_ao] = max(d_muted); 
a_o=a_o.';
% ---------------------
% fix amplitudes
% ---------------------
% window-mean the amplitudes
cc=2; % 5 samples to mean 
[a_o,~] = window_mean(a_o,cc);
% cut some stuff
cut_= fix(r_keepx_/dr); % # of early samples to cut due to clipping
a_o = a_o((cut_+1):end);
sR  = sR((cut_+1):end);
% ------------------------------------------------------------------------------
% fit hyperbola
[dd,bb,cc] = fit_hyperbola2(a_o,sR,[1; 1; 1]);
fprintf('hyperbola parameters are:\n')
fprintf('d=%2.2d  b=%2.2d  c=%2.2d\n',dd,bb,cc)
% amplitude at sR=0 (where source is)
a_ = dd./(bb).^cc;
% radargram.a_ = 0;
radargram.a_ = a_;
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
title(['Source for Line # ',num2str(is)])
simple_figure()

% figure;
% hold on
% plot(sR,a_o,'k.-','MarkerSize',15)
% plot(sR,a_hyper,'r.-','MarkerSize',10)
% plot(sR_,a_hyper_,'r-')
% hold off
% axis tight
% legend({'observed','hyperbolic'},'Location','best')
% ylabel('Amplitude (V/m)')
% xlabel('Source-receiver (m)')
% title(['Source amplitudes for line # ',num2str(is)])
% simple_figure()

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
% ------------------------------------------------------------------------------
%   linear mute
% ------------------------------------------------------------------------------
fprintf('linear mute\n');
[d,mute_] = linear_mute(d,dr,t,t_mute,v_mute);

figure;
fancy_imagesc(d,rx,t,0.2)
colormap(rainbow())
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Linear mute. Line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%   amputate unwanted receivers
% ------------------------------------------------------------------------------
fprintf('amputation\n');
[mute_,~,~] = w_amputate(mute_,r,dsr,r_keepx_,r_keepx__);
[d,r,dsr]   = w_amputate(d,r,dsr,r_keepx_,r_keepx__);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
%
wigb(normc(d),1,rx,t);
axis normal
xlabel('Receivers x (m)')
ylabel('Time (ns)')
title(['Amputated Line # ',num2str(is)])
simple_figure()
%%}
% ------------------------------------------------------------------------------
% save all current preprocessing parameters.
% this saves JUST the preprocessing parameters, 
% the data stays untouched.
% ------------------------------------------------------------------------------
if ~strcmp(y_n_,'y')
  prompt = '\n\n    do you want to save the preprocessing parameters? (y/n)  ';
  save_pp = input(prompt,'s');
  if strcmp(save_pp,'y')
    name = strcat(data_path_,'/',data_name_,num2str( is ),'.mat');
    save( name , 'radargram' );
    fprintf('\n    ok, line %i is saved now.\n\n',is)
  else
    fprintf('\n    ok, line %i is not saved.\n\n',is)
  end
end
% ------------------------------------------------------------------------------
