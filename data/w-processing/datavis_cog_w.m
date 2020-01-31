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

% % run after ss2gerjoii_cog_w
% ss2gerjoii_cog_w;

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
% groningen:
% 'cog-0m'; 'cog-1_4m';
%
% groningen2:
% 'cog-sr'; 'cog-rs';
data_name_ = 'cog-sr'; 

load(strcat(data_path_,data_name_,'.mat'));
d = radargram.d;
t = radargram.t; %          [ns]
dt = radargram.dt; %        [ns]
fo = radargram.fo; %        [GHz]
r = radargram.r; %          [m] x [m]
dr = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);

fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
nr = numel(rx);

fprintf('\n\n    peak into pre-processing for common-offset-gather %2.2d\n\n',dsr);
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
ylabel('$[V/m]$')
xlabel('$t\,[ns]$')
title('background trace')
fancy_figure()

figure;
fancy_imagesc(d,rx,t,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['common offset gather ',num2str(dsr),'$m$'])
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
xlabel('$f\,[Hz]$')
ylabel('$\tilde{d}$ power')
title(['common offset gather ',num2str(dsr),'$m$'])
fancy_figure()

figure;
fancy_imagesc(log10(d_pow),rx,f);
axis normal
colormap(hsv)
xlabel('$x\,[m]$')
ylabel('$f\,[GHz]$')
title(['$\log_{10}$ $f$ data. cog ',num2str(dsr),'$m$'])
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
f_high = fc+fb;
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
fprintf(' freq low and high: %2.2d %2.2d [GHz]\n',f_low,f_high)

% % apply power gain
% gpow = 5;
% d = gain_rt(d,gpow);

% % normalize
% d = normc(d);
d_max=max(d);
d = d./repmat(d_max,[nt,1]);

% % fk domain and filter.
% % smaller # -> bigger smudge
% ar = 27*dr;   % # is in [1/m] . 13 3
% at = 25*dt;  % # is in [1/ns]
% [d, d_fk, fkfilter] = image_gaussian(d,ar,at,'LOW_PASS');

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
% title('$\log_{10}$ $fk$ data')
% fancy_figure()
% figure;
% fancy_imagesc(fkfilter,k_,f_)
% axis normal
% xlabel('$k_x\,[1/m]$')
% ylabel('$f\,[1/ns]$')
% title('$fk$ filter')
% fancy_figure()
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
xlabel('$x\,[m]$')
ylabel('$f\,[GHz]$')
title(['$\log_{10}$ $f$ data. cog ',num2str(dsr),'$m$'])
fancy_figure()

figure;
fancy_imagesc(d,rx,t,1)
% fancy_imagesc(d(binning(t,40):binning(t,80),:),rx,...
% t(binning(t,40):binning(t,80)),0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['common offset gather ',num2str(dsr),'$m$'])
fancy_figure()
% ------------------------------------------
%   svd filter
% ------------------------------------------
% d=zeros(size(d));
% d(fix(nt/3):fix(nt/2),:)=1;
% d(fix(2*nt/3):fix(3*nt/4),:)=1;
% d(:,fix(2*nr/3):fix(3*nr/4))=1;

[V,E,Q]=svd(d);
cut_off = 2;
E(1:cut_off,1:nr)=zeros(cut_off,nr);
% E(cut_off:nt,1:nr)=zeros(nt-cut_off+1,size(E,2));
d__ = V*E*Q';
d__ = d__./repmat(max(d__),[nt,1]);

figure;
fancy_imagesc(d__,rx,t,1)%,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['common offset gather ',num2str(dsr),'$m$'])
fancy_figure()
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