% ------------------------------------------------
%
% apply preprocessing and 
% image in time with gain-bandpass 
% a gpr radargram.
%
% ------------------------------------------------ 
% read data
% dewow
% probability stuff

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

% ------------------------------------------
%   read .mat time shifted data
% ------------------------------------------

data_path_ = '../raw/groningen2/w-data/data-mat/';
% data_path_ = '../raw/vinyard-hat/w-data/data-mat/';
data_name_ = 'line'; % 'line';

% load(strcat(data_path_,'s_r','.mat'));
is = 10*2 - 1; % 9
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

% choose trace number to process
trn = 50;

% ------------------------------------------
%   remove wow
% ------------------------------------------
% remove wow
d = dewow(d,dt,fo);
% store trace to process
d_nature = d(:,trn);

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
% ------------------------------------------
%   probability on frequencies
% ------------------------------------------
%{
fprintf('probability on amplitude (f)\n');
data_real = linspace(min(real(d_(:))),max(real(d_(:))),5e+2);
f_kde_real = zeros(numel(f),numel(data_real));
data_imag = linspace(min(imag(d_(:))),max(imag(d_(:))),5e+2);
f_kde_imag = zeros(numel(f),numel(data_imag));
for i_=1:size(d_,1)
  % compute kernel density function
  data=real(d_(i_,:));
  kde_real = ksdensity(data,data_real); % ,'Bandwidth',2e+3); % std(data)*0.5);
  f_kde_real(i_,:) = kde_real;
  data=imag(d_(i_,:));
  kde_imag = ksdensity(data,data_imag); % ,'Bandwidth',2e+3); % std(data)*0.5);
  f_kde_imag(i_,:) = kde_imag;
end

figure;
fancy_imagesc(log10(f_kde_real),data_real,f);
colormap(jet)
axis normal
xlabel('sampled $f\;[GHz]$')
ylabel('data $f\;[GHz]$')
title('$\log_{10}$ kde for all $f$ (real)')
fancy_figure()
figure;
fancy_imagesc(log10(f_kde_imag),data_imag,f);
colormap(jet)
axis normal
xlabel('sampled $f\;[GHz]$')
ylabel('data $f\;[GHz]$')
title('$\log_{10}$ kde for all $f$ (imaginary)')
fancy_figure()
%}
% ------------------------------------------
%   probability on time
% ------------------------------------------
fprintf('probability on amplitude (t)\n');
data = d(:);
d_kde = linspace(min(data),max(data),5e+2);
% d_kde = linspace(1e+4,max(data),5e+2);
kde = ksdensity(data,d_kde ,'Bandwidth', std(data)*0.5);

figure;
subplot(1,2,1)
plot( data,'k.','MarkerSize',10 );
axis tight
ylabel('amplitude $[V/m]$')
xlabel('index \#')
fancy_figure()
subplot(1,2,2)
plot(kde,d_kde,'k.-','MarkerSize',10)
axis tight
ylabel('amplitude $[V/m]$')
xlabel('density')
fancy_figure()
% ------------------------------------------
%   probability on noise
% ------------------------------------------
fprintf('probability on noise (t)\n');
% take real data and make it 'synthetic' data
nbutter = 10;
fo_ = 0.16; % [GHz]
fc = 1.059095 * fo_; % [GHz]
fb = 0.577472 * fo_; % [GHz]
f_low = fc-fb;
f_high = (fc+fb);
d=d(:,trn);
d_noisefree = filt_gauss(d,dt,f_low,f_high,nbutter);
d=max(d_noisefree)*(d/max(d));
d_nature=max(d_noisefree)*(d_nature/max(d_nature));
% --
% generate noise vector
prcent = 0.5;
noise_amp = mean(d) + prcent*std(d); % 1e+2;
noise = (2*rand(nt,1)-1) * noise_amp; 
% noise = awgn(zeros(nt,1),1);
d_kde = linspace(min(noise),max(noise),5e+2);
kde = ksdensity(noise,d_kde ,'Bandwidth', std(noise)*0.5);

figure;
subplot(4,5,[1,2,6,7])
plot( noise,'r.','MarkerSize',10 );
axis tight
ylabel('noise $[V/m]$')
xlabel('index \#')
fancy_figure()
subplot(4,5,[4,5,9,10])
plot(kde,d_kde,'r.-','MarkerSize',10)
axis tight
ylabel('noise $[V/m]$')
xlabel('density')
fancy_figure()
subplot(4,5,[16,17,18,19,20])
plot(t,noise,'r-','MarkerSize',10)
axis tight
ylabel('noise $[V/m]$')
xlabel('$t\;[ns]$')
fancy_figure()

% [noise_,f,df] = fourier_rt(noise,dt);
% nbutter = 10;
% f_low = 0;
% f_high = 0.2;
% noise__ = filt_gauss(noise,dt,f_low,f_high,nbutter);
% figure;
% subplot(3,2,[1,2])
% plot(t,noise,'r')
% axis tight
% subplot(3,2,[3,4])
% axis tight
% plot(f,abs(noise_).^2,'b')
% axis tight
% subplot(3,2,[5,6])
% plot(t,noise__,'r')
% axis tight
% fancy_figure()

% t_=binning(t,30);
% t__=binning(t,50);
t_=binning(t,130);
t__=binning(t,t(nt));

figure;
subplot(3,2,[1,2,3,4])
hold on
plot(t(t_:t__),d_nature(t_:t__),'k')
plot(t(t_:t__),noise(t_:t__)+d_noisefree(t_:t__),'b')
plot(t(t_:t__),d_noisefree(t_:t__),'g','linewidth',5)
hold off
ylabel('amp $[V/m]$')
legend({'nature noise','synthetic noise','noise free'},...
'location','best')
axis tight
title('giving noise')
fancy_figure()
% set(gca,'XTick',[])
subplot(3,2,[5,6])
plot(t,noise,'r')
ylabel('noise')
xlabel('$t\;[ns]$')
legend({['noise amp is $\mu+$' num2str(prcent) '$\sigma$']})
axis tight
fancy_figure()
% % ------------------------------------------
% %   probability convolution
% % ------------------------------------------
% fprintf('probability convolution (t)\n');
% percent=0.1;
% % dh=percent*t(nt);
% dh=10;
% nh=fix(dh/dt);
% h = (dt*ones(nh,1) / dh) ;
% meanconv = conv(d,h,'same');
% noise_amp = meanconv; % *0.5
% noise = (2*rand(nt,1)-1) .* noise_amp; 
% 
% figure;
% subplot(3,2,[1,2,3,4])
% hold on
% plot(t,d_noisefree,'k')
% plot(t,noise+d_noisefree,'b')
% hold off
% ylabel('amp $[V/m]$')
% legend({'noise free','with noise'})
% axis tight
% title('giving noise')
% fancy_figure()
% % set(gca,'XTick',[])
% subplot(3,2,[5,6])
% plot(t,noise,'r')
% ylabel('noise')
% xlabel('$t\;[ns]$')
% legend({'noise amp is the moving mean'})
% axis tight
% fancy_figure()
