% ------------------------------------------------------------------------------
% 
% surface wave analysis on passive data from Grenoble
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
% name of array
array_name = 'C_78_405'; %'C_78_405';% 'C_26_78'; 'C_45_135';
CN_IR = 'CN';
num = '01';
component = 'E';
data_path = strcat('../../data/raw/AVA_GRENOBLE_SAC/GRENOBLE_SAC/GRE_',...
array_name,'/');
data_name = strcat('GRE_',array_name,'_',CN_IR,num,'_',component,'.sac');
fprintf('\n we are looking at: %s\n\n',data_name);
station_name = strcat(CN_IR,num,' ',component);
data_read = strcat(data_path,data_name);
data=rdsac(data_read);
% ------------------------------------------------------------------------------
% get the data
d=data.d;
dt=data.HEADER.DELTA; % [s]
t=0:(numel(data.t)-1);t=t.'*dt;
nr=1; 
nt = numel(t);
% quick see
figure;
plot(t,d,'k-');
axis tight
xlabel('Time (s)')
ylabel('(nm/s)')
title(strcat('Station',{' '},station_name))
simple_figure()
% ------------------------------------------------------------------------------
% quick fourier
fprintf('fourier\n');
d=detrend(d);
d_mean=mean(d);
d=d-d_mean;
% taper edges to zero
% before fourier
%
for i=1:nr
  d(:,i) = d(:,i) .* tukeywin(nt,0.01);
end
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
figure;
plot(f,log10(d_pow/max(abs(d_pow))),'.-')
axis tight
box on
xlabel('Frequency (Hz)')
ylabel('Log10 of power spectra - raw')
title(strcat('station',{' '},station_name))
simple_figure()
% ------------------------------------------------------------------------------
% quick bandpass
fprintf('bandpass\n');
f_low = 2; % [Hz]
f_high = 20;  % [Hz]
% filter
nbutter = 10;
% d = butter_butter(d,dt,f_low,f_high,nbutter);
d = filt_gauss(d,dt,f_low,f_high,nbutter);
fprintf(' freq low and high: %2.2d %2.2d [Hz]\n',f_low,f_high)
% d(t,s) -> d(f,s)
[d_,f,df] = fourier_rt(d,dt);
% power
d_pow = abs(d_).^2 / nt^2;
figure;
plot(f,log10(d_pow/max(abs(d_pow))),'.-')
axis tight
box on
xlabel('Frequency (Hz)')
ylabel('Log10 of power spectra - cooked')
title(strcat('Station',{' '},station_name))
simple_figure()
figure;
plot(t,d,'k-');
axis tight
xlabel('Time (s)')
ylabel('(nm/s)')
title(strcat('Station',{' '},station_name))
simple_figure()
%{
% ------------------------------------------------------------------------------
%
% beamformer
%
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
%
% interferate
%
% ------------------------------------------------------------------------------
% window the data
% windows data d(t,r) for ns slices of time samples,
% ns is an integer -> # of sources.
d_windowed = window_d(d,ns);
% windows data d(t,r) for equal slices of time T_,
% T_ is a real number.
[d_windowed,ns] = window_dT(d,T_,dt);
% ------------------------------------------------------------------------------
% cross correlation
% ---------------
% Bs: shot gather with sources s and receivers b
% a: index of receiver a
% dt: obvious.
% ---------------
% Ba: shot gather with source a and receivers b
% cg_a: correlation gather with source a and receivers b
% t_corr: correlation time of size 2t-1.
% ---------------
[Ba, cg_a, t_corr] = ifm_xcorr(Bs,a,dt);
% ------------------------------------------------------------------------------
% deconvolution
% ---------------
% Bs: shot gather with sources s and receivers b
% As: shot gather with sources s and receivers a (could be == Bs)
% c: indicies of receivers (could be == 1:nr)
% f: range of frequencies to do
% dt: obvious.
% ---------------
% BAf_: cube of size (nf x nb x na).
%       virtual gather Ba (in the frequency domain) is BAf_(:,:,a).
% t_decon: deconvolution time of size 2t+1.
% ---------------
[BAf_,t_decon,Ba] = ifm_decon(Bs,As,c,f,dt,a);
% ------------------------------------------------------------------------------
%}