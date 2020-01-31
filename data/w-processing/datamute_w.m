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
fprintf('\n   I will mute your shot-gather.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat-fwi/');
data_name_ = 'line';
% -
ls(data_path_);
prompt = '\n\n    tell me what line you want, eg 2:  ';
is = input(prompt,'s');
is = str2double(is);
% -
prompt = '    is this gerjoii synthetic data, (y or n):  ';
synthetic_ = input(prompt,'s');
% -
% ------------------------------------------------------------------------------
fprintf('\n\n------------------------------------------------\n');
fprintf('    peak into muting for shot-gather %i',is);
fprintf('\n------------------------------------------------\n\n');
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
% load(strcat(data_path_,'s_r','.mat'));
d   = radargram.d;
t   = radargram.t; %          [ns]
dt  = radargram.dt; %        [ns]
fo  = radargram.fo; %        [GHz]
r   = radargram.r; %          [m] x [m]
s   = radargram.s; %          [m] x [m]
dr  = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
% ------------------------------------------------------------------------------
fny = 1/dt/2;
nt = numel(t);
rx = r(:,1);
rz = r(:,2);
nr = numel(rx);
% ------------------------------------------------------------------------------
%   WARNING: this part is only for synthetic data
% ------------------------------------------------------------------------------
if strcmp(synthetic_,'y')
  t = 1e+9 *t; %          [ns]
  dt= 1e+9 *dt; %        [ns]
  fo= 1e-9 *fo; %        [GHz]
end
% ------------------------------------------------------------------------------
v_mute = c;   % m/ns
t_mute = 172; % ns
% ------------------------------------------------------------------------------
d_max=max(abs(d(:)));
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(d,rx,t);
axis normal
axis square 
caxis([-d_max d_max]*0.005)
hold on
plot(rx,(1/v_mute)*(rx-rx(1))+t_mute,'y--','linewidth',2)
hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
d = linear_mute(d,dr,t,t_mute,v_mute);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(d,rx,t);
axis normal
axis square 
caxis([-d_max d_max]*0.005)
% hold on
% plot(rx,(1/v_mute)*(rx-rx(1))+t_mute,'y--','linewidth',2)
% hold off
colormap(rainbow())
colorbar('off')
ylabel('Time (ns)')
xlabel('Receivers (m)')
title(['Line # ',num2str(is)])
simple_figure()
% ------------------------------------------------------------------------------
%                           save mute values?
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save muting values for line? (y/n)  ';
src_yn = input(prompt,'s');
if strcmp(src_yn,'y')
  radargram.v_mute = v_mute;
  radargram.t_mute = t_mute;
  save(strcat(data_path_,data_name_,num2str(is),'.mat'),'radargram');
  fprintf('\n    ok, mute parameters for line %i are saved. \n\n',is)
else
  fprintf('\n    ok, mute parameters for line %i are NOTE saved.\n\n',is)
end