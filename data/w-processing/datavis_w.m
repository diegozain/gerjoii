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

% % run after ss2gerjoii_w
% ss2gerjoii_w;

% constants
cf=0.9; % []
nl=10;  % []
% c=299792458; % [m/s]
c=0.299792458; % [m/ns]

% ns  --> s  | *1e-9
% MHz --> Hz | *1e+6
% GHz --> Hz | *1e+9

% ------------------------------------------
%   read .mat time shifted data
% ------------------------------------------

data_path_ = '../raw/groningen2/w-data/data-mat/';
data_name_ = 'line'; % 'line';

% load(strcat(data_path_,'s_r','.mat'));
is = 1*2 - 1; % 9
fprintf('\n\n    peak into pre-processing for shot-gather %i\n\n',is);

load(strcat(data_path_,data_name_,num2str(is),'.mat'));
d = radargram.d;
t = radargram.t; %          [ns]
dt = radargram.dt; %        [ns]
fo = radargram.fo; %        [GHz]
r = radargram.r; %          [m] x [m]
s = radargram.s; %          [m] x [m]
dr = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);

fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);

% ------------------------------------------
%   remove wow
% ------------------------------------------
% remove wow
d = dewow(d,dt,fo);

figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
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

figure;
hold on
for i=1:nr
plot(f,d_pow(:,i),'.-')
end
hold off
axis tight
xlabel('$f\,[Hz]$')
ylabel('$d$ power')
title(['line \# ',num2str(is)])
fancy_figure()

figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('$x\,[m]$')
ylabel('$f\,[GHz]$')
title(['$\log_{10}$ $f$ data. Line \# ',num2str(is)])
fancy_figure()
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
% VHF radar signal - "Frequencies of the Ricker wavelet" Yanghua Wang
fo_ = 0.16; % [GHz]
fc = 1.059095 * fo_; % [GHz]
fb = 0.577472 * fo_; % [GHz]
f_low = fc-fb;
f_high = (fc+fb);
% % VHF radar signal - overhead line from train
% f_low = 0.175; % [GHz]
% f_high = 0.325; % [GHz]
% % overhead line from train
% f_low = 0.02; % [GHz]
% f_high = 0.1; % [GHz]

% filter
nbutter = 10;
% d = butter_butter(d,dt,f_low,f_high,nbutter);
d = filt_gauss(d,dt,f_low,f_high,nbutter);
fprintf(' freq low and high: %2.2d %2.2d [Hz]\n',f_low,f_high)

% % apply power gain
% gpow = 1.7;
% d = gain_rt(d,gpow);

% % % normalize
% % d = normc(d);
% d_max=max(d);
% d = d./repmat(d_max,[nt,1]);

% % fk domain and filter
% ar = 20*dr;   % # is in [1/m] . 13 3
% at = 2*dt;  % # is in [1/ns]
% [d, d_fk, fk_filt] = image_gaussian(d,ar,at,'LOW_PASS');
% vel_ = c; % [m/ns]
% [d, d_fk, fk_filt] = fk_filter(d,vel_,'VEL_CONE');
% 
% [nr_,nt_] = size(d_fk);
% dk_ = 1/dr/nr_;
% df_ = 1/dt/nt_;
% k_=(-nr_/2:nr_/2-1)*dk_;
% f_=(-nt_/2:nt_/2-1)*df_;
% figure;
% fancy_imagesc(log10(abs(d_fk)),k_,f_)
% colormap(hsv)
% axis normal
% xlabel('$k_x\,[1/m]$')
% ylabel('$f\,[1/ns]$')
% title(['$\log_{10}$ $fk$ data. Line \# ',num2str(is)])
% fancy_figure()
% figure;
% fancy_imagesc(fk_filt,k_,f_)
% axis normal
% xlabel('$k_x\,[1/m]$')
% ylabel('$f\,[1/ns]$')
% title('$fk$ filter')
% fancy_figure()

% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;

% figure;
% hold on
% for i=1:nr
%   plot(f,d_pow(:,i),'-')
%   % plot(f,real(d_(:,i)),'.-')
% end
% hold off
% axis tight
% xlabel('$f\,[GHz]$')
% ylabel('$|\tilde{d}|$')
% title(['$[f_{low},\,f_{high}]=[$',...
%       num2str(f_low),', ',num2str(f_high),'$]\,GHz$'])
% fancy_figure()

figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('$x\,[m]$')
ylabel('$f\,[GHz]$')
title(['$\log_{10}$ $f$ data. Line \# ',num2str(is)])
fancy_figure()

figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()

wigb(d,1,rx,t);
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
% ------------------------------------------
%   amputate unwanted receivers
% ------------------------------------------
fprintf('amputation\n');
r_keepx_  = rx(1);    % [m]
r_keepx__ = rx(1)+1.5;  % [m] % +1
ir_keep_  = binning(rx,r_keepx_);
ir_keep__ = binning(rx,r_keepx__);
rx = rx(ir_keep_:ir_keep__);
rz = rz(ir_keep_:ir_keep__);
r = [rx,rz];
d = d(:,ir_keep_:ir_keep__);

figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()

wigb(d,1,rx,t);
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
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
% % ------------------------------------------
% %   instantaneous phase
% % ------------------------------------------
% fprintf('instantaneous phase\n')
% d_anal = hilbert(d);
% inst_phase = angle(d_anal);
% inst_ampli = abs(d_anal);
% 
% figure;
% fancy_imagesc(abs(inst_phase),rx,t);
% axis normal
% colormap(bone)
% xlabel('receivers $x\,[m]$')
% ylabel('$t\,[ns]$')
% title(['absolute value of instantaneous phase for line \# ',num2str(is)])
% fancy_figure()
% 
% % figure;
% % fancy_imagesc(abs(inst_phase),rx,t);
% % axis normal
% % colormap(bone)
% % xlabel('receivers $x\,[m]$')
% % ylabel('$t\,[ns]$')
% % title(['absolute value of instantaneous phase for line \# ',num2str(is)])
% % fancy_figure()
% % v_ = 0.045;
% % to = 52;
% % z_ = v_*sqrt( (to/2)^2 - (dsr/2/v_)^2 );
% % eps_ = (c/v_)^2;
% % fprintf('to=%2.2d v=%2.2d z=%2.2d eps=%2.2d\n',to,v_,z_,eps_);
% % sR = rx-rx(1) + dsr;
% % hyper_ = 2 * sqrt( (sR./2/v_).^2 + (z_/v_)^2 );
% % hold on
% % plot(rx,hyper_,'r-','Linewidth',3);
% % hold off
% % v_ = 0.055;
% % to = 62;
% % z_ = v_*sqrt( (to/2)^2 - (dsr/2/v_)^2 );
% % eps_ = (c/v_)^2;
% % fprintf('to=%2.2d v=%2.2d z=%2.2d eps=%2.2d\n',to,v_,z_,eps_);
% % sR = rx-rx(1) + dsr;
% % hyper_ = 2 * sqrt( (sR./2/v_).^2 + (z_/v_)^2 );
% % hold on
% % plot(rx,hyper_,'r-','Linewidth',3);
% % hold off
% % % v_ = 0.055;
% % % to = 72;
% % % z_ = v_*sqrt( (to/2)^2 - (dsr/2/v_)^2 );
% % % eps_ = (c/v_)^2;
% % % fprintf('to=%2.2d v=%2.2d z=%2.2d eps=%2.2d\n',to,v_,z_,eps_);
% % % sR = rx-rx(1) + dsr;
% % % hyper_ = 2 * sqrt( (sR./2/v_).^2 + (z_/v_)^2 );
% % % hold on
% % % plot(rx,hyper_,'r-','Linewidth',3);
% % % hold off
% % v_ = 0.055;
% % to = 87;
% % z_ = v_*sqrt( (to/2)^2 - (dsr/2/v_)^2 );
% % eps_ = (c/v_)^2;
% % fprintf('to=%2.2d v=%2.2d z=%2.2d eps=%2.2d\n',to,v_,z_,eps_);
% % sR = rx-rx(1) + dsr;
% % hyper_ = 2 * sqrt( (sR./2/v_).^2 + (z_/v_)^2 );
% % hold on
% % plot(rx,hyper_,'r-','Linewidth',3);
% % hold off
%%{
% ------------------------------------------
%   choose t_fa, v_min, eps_max, eps_min and f_max
% ------------------------------------------
fprintf('dt and dx\n');
t_fa = 33.2; % [ns] groningen 30 28.5. groningen2 23, 33.2
v_min = 0.055; % [m/ns] 0.055
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
% ------------------------------------------
%  choose times of linear arrivals
% ------------------------------------------
% % groningen
% t_air = 16;
% t_ground_  = 28;
% t_ground__ = 46;
% v_ground = 0.055;
% groningen2
t_air = 22;
t_ground_  = 33;
t_ground__ = 40;
v_ground = 0.072;
% ------------------------------------------
%  linear velocity semblance
% ------------------------------------------
fprintf('linear velocity semblance\n');
% choose velocities
v__ = 0.15; % 0.1; % [m/ns]
v_  = 0.03; % 0.01; % [m/ns]
dv = (v__-v_)*0.01;   % [m/ns]
v = v_ : dv : v__;  % [m/s] velocities to consider
v_analyn = v_anal_lin(angle(hilbert(d)),t,dr,v);

figure;
fancy_imagesc(v_analyn,v,t); 
axis normal 
colormap(jet)
ylabel('$t\,[ns]$')
xlabel('$v\,[m/ns]$')
title(['linear vel. semblance line \# ',num2str(is)])
fancy_figure()
%%{
% ------------------------------------------
%   velocity analysis
% ------------------------------------------
fprintf('velocity analysis\n');
% % linear mute (remove ground wave)
% to_ = 45; % [ns]
% vel_ = 0.055; % [ns]
% d_hmo = linear_mute(d,dr,t,to_,vel_);
% % hmo
% vel_ = 0.01; % [m/ns]
% to_ = 52;     % [ns]
% [d_hmo,t_h] = hmo(d,t,dr,dsr,vel_,to_);
% % vel analysis
% % v_analy = sum(d_hmo,2)/size(d_hmo,2);
% choose max-min velocities
v__ = 0.15; % 0.1; % [m/ns]
v_  = 0.03; % 0.01; % [m/ns]
dv = (v__-v_)*0.01;   % [m/ns]
v = v_ : dv : v__;  % [m/s] velocities to consider
% for linear mute
to = 0; % t_fa; % [ns] groningen 45. groningen2 43.4
vo = 0.072; % vel_; % [ns] groningen 0.055. groningen2 0.072
tic;
v_analy = v_analysis(angle(hilbert(d)),t,dr,dsr,v,to,vo);
toc;

% gpow = 1.7;
% v_analy = gain_rt(v_analy,gpow);

% figure;
% fancy_imagesc(d,rx,t,0.2)
% axis normal
% hold on
% plot(rx,t_h,'k.-','MarkerSize',10)
% hold off
% figure;
% fancy_imagesc(d_hmo,rx,t,0.2)
% axis normal
% xlabel('receivers $x\,[m]$')
% ylabel('$t\,[ns]$')
% title(['hmo line \# ',num2str(is)])
% fancy_figure()

figure; 
% fancy_imagesc(v_analy(binning(t,to):end,:),v,t(binning(t,to):end));
fancy_imagesc(v_analy,v,t); 
axis normal 
colormap(jet)
% hold on
% curve = max_mat(v_analy(binning(t,to):end,:).',t(binning(t,to):end),v);
% plot(curve(:,1),curve(:,2),'-')
% hold off
ylabel('$t\,[ns]$')
xlabel('$v\,[m/ns]$')
title(['hyper vel. semblance line \# ',num2str(is)])
fancy_figure()
% ------------------------------------------
%  mute unwanted linear events
% ------------------------------------------
fprintf('linear mute\n');
% ground
to = t_ground_; %   [s]        48; % 
% % air
% to = 16; % [ns]
% vel_ = c; % [m/ns]
d = linear_mute(d,dr,t,to,v_ground);

figure;
fancy_imagesc(d,rx,t,0.5)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['linear mute line \# ',num2str(is)])
fancy_figure()

wigb(d,1,rx,t);
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['linear mute line \# ',num2str(is)])
fancy_figure()
% ------------------------------------------
%   ftan - group velocity over frequencies
% ------------------------------------------
fprintf('ftan \n')
v__ = 0.05; % 0.29; % [m/ns]
v_  = 0.02; % 0.05; % [m/ns] 0.017. 0.02
dv = (v__-v_)*1e-4;   % [m/ns]
% make velocity and frequency vectors
f_disper = (f_low/1.5) : (df/2) : (f_high*1.5);  % [GHz] frequencies to scan over
v = v_ : dv : v__;  % [m/s] velocities to consider
% choose width of gaussian ftan filter
alph = 8; % 8
% receiver in meters 
rec_ = 2; % 25.75
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
title(['line \# ',num2str(is), ' trace ',num2str(rec_),'$m$']);
fancy_figure()

figure;
subplot(3,2,[1,2])
plot(t,dro,'k-')
axis tight
ylabel('amp');
title(['line \# ',num2str(is), ' trace ',num2str(rec_),'$m$']);
fancy_figure()
subplot(3,2,[3,4,5,6])
fancy_imagesc(abs(disper_g_ft), t, f_disper);
colormap(hsv)
axis normal;
ylabel('$f \; [GHz]$'); 
xlabel('$t \; [ns]$');
fancy_figure()

figure;
subplot(2,3,[1,2,3])
plot(f_disper,fvg_curve(:,1),'k-')
axis tight
xlabel('$f \; [GHz]$'); 
ylabel('$v_g \; [m/ns]$');
title(['line \# ',num2str(is), ' trace ',num2str(rec_),'$m$']);
fancy_figure()
subplot(2,3,[4,5,6])
plot(t,ft_curve(:,1),'k-')
axis tight
xlabel('$t \; [ns]$'); 
ylabel('$f \; [GHz]$');
fancy_figure()

% figure;
% plot(f_disper, sum(disper_g_vf,1)/size(disper_g_vf,1) ,'k-')
% axis tight;
% xlabel('$f \; [GHz]$'); 
% fancy_figure()
% 
% figure;
% plot(v, sum(disper_g_vf,2)/size(disper_g_vf,2) ,'k-')
% axis tight;
% xlabel('$v_g \; [m/ns]$'); 
% fancy_figure()
% ------------------------------------------
%   masw
% ------------------------------------------
fprintf('masw\n');
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% make velocity and frequency vectors
f_disp = (f_low/1.5) : (df) : (f_high);  % [GHz] frequencies to scan over
v__ = 0.2; % 0.1; % [m/ns]
v_  = 0.03; % 0.02; % [m/ns]
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
xlabel('$f\,[GHz]$')
ylabel('$v_p\,[m/ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
%%{
% ------------------------------------------
%   linear moveout
% ------------------------------------------
fprintf('linear moveout\n');
d_lmo = lmo(d,t,dr,v_ground);

figure;
fancy_imagesc(d_lmo,rx,t,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['lmo line \# ',num2str(is)])
fancy_figure()
% ------------------------------------------
%   mute around selected event & source estimate
% ------------------------------------------
fprintf('mute around selected event\n');
% ground wave 
t_ = t_ground_; % [ns]
t__ = t_ground__; % [ns]
% % air wave
% t_ = 16; % [ns]
% t__ = 28; % [ns]
[s,d_muted,gaussian_] = lmo_source(d_lmo,t,t__,t_);
s_ = integrate(s,dt,0);
s_ = gaussian_.*s_;
figure;
fancy_imagesc(d_muted,rx,t,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['window mute line \# ',num2str(is)])
fancy_figure()
wigb(d_muted,1,rx,t);
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['window mute line \# ',num2str(is)])
fancy_figure()

figure;
hold on
plot(t,s,'k-','LineWidth',3);
plot(t,s_,'r-');
hold off
axis tight
legend({'source','Yee-source'},'Location','best')
xlabel('$t\,[ns]$')
title(['source for line \# ',num2str(is)])
fancy_figure()

fprintf('t_        = %2.2d  [ns]\n',t_)
fprintf('t__       = %2.2d  [ns]\n',t__)
%%}
% ------------------------------------------
% source signature
% ------------------------------------------
%{
fprintf('source signature estimation\n');
% % ------------
% % CMP
% % ------------
% % in case data is common midpoint,
% % a quick and dirty way to get the source signature
% s = sum(d,2)/nr;
% % this would be the source to input into the Yee grid
% % (since it is staggered in time)
% s_ = integrate(s,dt,0);
% 
% figure;
% hold on
% plot(t,s,'k-','Linewidth',2)
% plot(t,s_,'r-','Linewidth',2)
% hold off
% axis tight
% legend('source','anti-derivative')
% xlabel('$t\,[ns]$')
% fancy_figure();

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
%
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
% % -----
% % offset hyperbola+exponential
% % -----
% %
% % get amplitudes from peak of lmo wave
% [a_o,i_ao] = max(d_muted); a_o=a_o.';
% [dd,bb,cc] = fit_hyperexp(a_o,sR);
% fprintf('d=%2.2d  b=%2.2d  c=%2.2d\n',dd,bb,cc)
% % amplitude at sR=0 (where source is)
% a_ = ( 1./(bb) );
% % observations only
% a_hyper = ( 1./(sR+bb) ).*exp(-cc*(sR+bb));
% % full domain
% a_hyper_ = ( 1./(sR_+bb) ).*exp(-cc*(sR_+bb));


% correct for amplitude
s = a_ * (s/max(s));
fprintf('\n amplitude at dsR=0 is %2.2d\n',a_)

% integrate for Yee grid
s_ = integrate(s,dt,0);
s_ = - gaussian_.*s_;

figure;
fancy_imagesc(d_muted,rx,t,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
wigb(d_muted,1,rx,t);
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()

figure;
hold on
plot(t,s,'k-','LineWidth',3);
plot(t,s_,'r-');
hold off
axis tight
legend({'source','Yee-source'},'Location','best')
xlabel('$t\,[ns]$')
title(['source for line \# ',num2str(is)])
fancy_figure()

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
title(['source amplitudes for line \# ',num2str(is)])
fancy_figure()

figure;
hold on
plot(sR,a_o,'k.-','MarkerSize',15)
plot(sR,a_hyper,'r.-','MarkerSize',10)
hold off
axis tight
legend({'observed','hyperbolic'},'Location','best')
ylabel('$u\;[V/m]$')
xlabel('$\Delta sR\;[m]$')
title(['source amplitudes for line \# ',num2str(is)])
fancy_figure()

%}
%}