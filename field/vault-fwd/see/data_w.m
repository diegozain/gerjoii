clear
close all
clc
% ------------------------------------------------------------------------------
% process and visualize some radar shot-gather
% ------------------------------------------------------------------------------
ls ..
prompt = '\n\n    what project (eg, r2 or v9):  ';
path_ = input(prompt,'s');
path_ = strcat('../',path_);
path_ = strcat(path_,'/data-recovered/w/');
% ------------------------------------------------------------------------------
ls(path_)
prompt = '\n\n    what number of line (eg, 2 or 100):  ';
line_name = input(prompt,'s');
line_name = strcat('line',line_name);
line_name = strcat(line_name,'.mat');
% ------------------------------------------------------------------------------
fprintf('\n')
% ------------------------------------------------------------------------------
load(strcat(path_,line_name));
% ------------------------------------------------------------------------------
d   = radargram.d;  %        (time x receivers )
t   = radargram.t;  %        [s]
dt  = radargram.dt; %        [s]
fo  = radargram.fo; %        [Hz]
r   = radargram.r;  %        [m] x [m]
s   = radargram.s;  %        [m] x [m]
dr  = radargram.dr; %        [m]
dsr = radargram.dsr;%        [m]
% ------------------------------------------------------------------------------
fny = 1/dt/2;
nt  = numel(t);
rx  = r(:,1);
rz  = r(:,2);
nr  = numel(rx);
% ------------------------------------------------------------------------------
t = 1e+9 *t;  %         [ns]
dt= 1e+9 *dt; %         [ns]
fo= 1e-9 *fo; %         [GHz]
% ------------------------------------------------------------------------------
figure; 
fancy_imagesc(d,rx,t);
caxis([-1 1]*1e+1)
axis normal
xlabel('Receivers (m)')
ylabel('Time (ns)')
colormap(rainbow2(1))
title('Raw')
simple_figure()
% ------------------------------------------------------------------------------
fprintf(' frequency spectra\n')
% ------------------------------------------------------------------------------
for i=1:nr
  d(:,i) = d(:,i) .* tukeywin(nt,0.1);
end
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
% ------------------------------------------------------------------------------
figure;
plot(f,d_pow,'.-')
axis tight
xlabel('f (GHz)')
ylabel('d power')
title('line')
simple_figure()
% ------------------------------------------------------------------------------
% % to make two-sided be one-sided shot gather
% [~,il]=max(diff(rx));
% d(:,1:il) = [];
% rx(1:il)  = [];
% ------------------------------------------------------------------------------
fprintf(' phase velocity vs frequency \n')
% ------------------------------------------------------------------------------
f_low = 0.01; % [GHz]
f_high= 0.1;  % [GHz]
% ------------------------------------------------------------------------------
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% make velocity and frequency vectors
f_disp = (f_low) : (df) : (f_high);  % [GHz] frequencies to scan over
v__ = 0.3;                           % [m/ns]
v_  = 0.04;                          % [m/ns]
dv  = (v__-v_)*0.01;                  % [m/ns]
vp  = v_ : dv : v__;                  % [m/s] velocities to consider
sx  = 1./vp;
% ------------------------------------------------------------------------------
% masw
[disper_vxf,disper_sxf] = masw(d_,(rx-rx(1))+dsr,sx,f,f_disp);
% ------------------------------------------------------------------------------
figure; 
fancy_imagesc(disper_vxf,f_disp,vp);
xlabel('Frequency (GHz)')
ylabel('Velocity (m/ns)')
axis square 
set(gca,'YDir','normal')
colormap(rainbow2(1))
simple_figure()
% ------------------------------------------------------------------------------
fprintf(' fk filter\n')
vel_ = 0.2;
% ------------------------------------------------------------------------------
% dk and df are not the same so vel_ has to be recalibrated
[nt,nr] = size(d);
nt_= 2^nextpow2(nt); 
nr_= 2^nextpow2(nr); 
dk = 1/dr/nr_; 
df = 1/dt/nt_;
vel_=(dk/df)*vel_;
% ------------------------------------------------------------------------------
% f__=linspace(-0.13,0.13,numel(k_(k_min:k_max)));
% df__=abs(f__(2)-f__(1));
% hold on;plot(k_(k_min:k_max),-0.29*(dk/df__)*f__,'c')
% a=[-0.5,0.4]-[0.4,-0.33];a(2)/a(1)
% ------------------------------------------------------------------------------
[d, d_fk, fk_filt] = fk_filter(d,vel_,'VEL_CONE');
% ------------------------------------------------------------------------------
d_fk = abs(d_fk);
d_fk = d_fk/max(d_fk(:));
% ------------------------------------------------------------------------------
figure; 
fancy_imagesc(d,rx,t);
caxis([-1 1]*1e+1)
axis normal
xlabel('Receivers (m)')
ylabel('Time (ns)')
colormap(rainbow2(1))
title('Filtered')
simple_figure()
% ------------------------------------------------------------------------------
[nt_,nr_] = size(d_fk);
dk_ = 1/dr/nr_;
df_ = 1/dt/nt_;
k_  = (-nr_/2:nr_/2-1)*dk_;
f_  = (-nt_/2:nt_/2-1)*df_;
% ------------------------------------------------------------------------------
f_max = 0.13;
f_min = -0.13;
k_max = 0.5;
k_min = -0.5;
% ------------------------------------------------------------------------------
f_max = binning(f_,f_max);
f_min = binning(f_,f_min);
k_max = binning(k_,k_max);
k_min = binning(k_,k_min);
% ------------------------------------------------------------------------------
figure; 
fancy_imagesc(d_fk(f_min:f_max,k_min:k_max),k_(k_min:k_max),f_(f_min:f_max));
% fancy_imagesc(abs(d_fk),k_,f_);
axis normal
xlabel('Wavenumber (1/m)')
ylabel('Frequency (1/ns)')
colormap(rainbow2(1))
simple_figure()
% ------------------------------------------------------------------------------
figure; 
fancy_imagesc(fk_filt(f_min:f_max,k_min:k_max),k_(k_min:k_max),f_(f_min:f_max));
% fancy_imagesc(fk_filt,k_,f_);
axis normal
xlabel('Wavenumber (1/m)')
ylabel('Frequency (1/ns)')
colormap(rainbow2(1))
simple_figure()
% ------------------------------------------------------------------------------
fprintf('\n')
% ------------------------------------------------------------------------------
fprintf(' phase velocity vs frequency \n')
% ------------------------------------------------------------------------------
f_low = 0.01; % [GHz]
f_high= 0.1;  % [GHz]
% ------------------------------------------------------------------------------
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% make velocity and frequency vectors
f_disp = (f_low) : (df) : (f_high);  % [GHz] frequencies to scan over
v__ = 0.3;                           % [m/ns]
v_  = 0.04;                          % [m/ns]
dv  = (v__-v_)*0.01;                  % [m/ns]
vp  = v_ : dv : v__;                  % [m/s] velocities to consider
sx  = 1./vp;
% ------------------------------------------------------------------------------
% masw
[disper_vxf,disper_sxf] = masw(d_,(rx-rx(1))+dsr,sx,f,f_disp);
% ------------------------------------------------------------------------------
figure; 
fancy_imagesc(disper_vxf,f_disp,vp);
xlabel('Frequency (GHz)')
ylabel('Velocity (m/ns)')
axis square 
set(gca,'YDir','normal')
colormap(rainbow2(1))
simple_figure()
% ------------------------------------------------------------------------------
fprintf('\n')