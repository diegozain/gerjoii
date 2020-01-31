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

% data_path_ = '../raw/groningen2/w-data/data-mat/';
% data_path_ = '../raw/vinyard-hat/w-data/data-mat/';
data_path_ = '../raw/synthetic2/w-data/data-mat/';
data_name_ = 'line'; % 'line';

% load(strcat(data_path_,'s_r','.mat'));
is = 2; % 9
fprintf('\n\n    peak into pre-processing for shot-gather %i\n\n',is);

load(strcat(data_path_,data_name_,num2str(is),'.mat'));
d = radargram.d;
t = radargram.t; %          [s]
dt = radargram.dt; %        [s]
fo = radargram.fo; %        [Hz]
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
fancy_imagesc(d(binning(t,1e-8):binning(t,5*1e-8),:),rx,...
t(binning(t,1e-8):binning(t,5*1e-8))*1e+9,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
figure;
fancy_imagesc( d(binning(t,7*1e-8):nt,:) ,rx,...
t(binning(t,7*1e-8):nt)*1e+9,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
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
% generate noise vector
% ------------------------------------------
prcent = 0.05;
noise_amp = mean(d(:)) + prcent*std(d(:)); % 1e+2;
noise = (2*rand(nt,nr)-1) * noise_amp;

d_noise = d + noise;

figure;
fancy_imagesc(d_noise(binning(t,1e-8):binning(t,5*1e-8),:),rx,...
t(binning(t,1e-8):binning(t,5*1e-8))*1e+9,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()
figure;
fancy_imagesc( d_noise(binning(t,7*1e-8):nt,:) ,rx,...
t(binning(t,7*1e-8):nt)*1e+9,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['line \# ',num2str(is)])
fancy_figure()