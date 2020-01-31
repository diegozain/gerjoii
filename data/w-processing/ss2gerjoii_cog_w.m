% ------------------------------------------------
%
% take field radargrams and turn them into .mat
%
%
%
% ------------------------------------------------ 

close all
clear all
clc

addpath('read-data')

% ------------------------------------------------------------------------------
% Loop through done survey lines and save all of the data to .mat in disk.
% Also save r and t as r_all and t_all in memory.
% ------------------------------------------------------------------------------

fprintf('\n saving common offset gather to .mat file\n')

data_path = '../raw/groningen2/w-data/';
data_name = 'LINE';
data_path_ = '../raw/groningen2/w-data/data-mat/';
data_name_ = 'cog-'; % 'cog'; 'line';

% groningen:
% cog: 4, 5. line: (6:35)
%
% groningen2:
% cog: 0, 66. line: (1:59)
source_no = 66; % cog: 4, 5.
cog_      = 'rs'; % cog: 0m, 1_4m.
dsr = 0; %        [m] % cog: 0, 1.4. line: 0.9

% % this was the set up for groningen:
fo = 250; %       [MHz]
ds = 0.02; %      [m] % groningen 0.03. groningen2 0.02

% correct for LINE04 instead of LINE4
if source_no < 10
  no = strcat(  num2str( 0 ) , num2str( source_no ) );
else 
  no = num2str( source_no );
end
d_path = strcat( data_path,data_name,no );
[d,r,t,header,skips] = ekko2mat_pro(d_path);
radargram = struct;
radargram.d = d;          % [ns] x [m]
radargram.r = r;          % [m]
radargram.t = t.';        % [ns]
radargram.dt = t(2)-t(1); % [ns]
radargram.dr = r(2)-r(1); % [m]
radargram.dsr = dsr; %      [m]
radargram.fo = fo; %        [MHz]
name = strcat(data_path_,data_name_,cog_,'.mat');
save( name , 'radargram' );

%%{
% ------------------------------------------------------------------------------
% Loop over all saved lines: time shift, unit convert and s_r store
% ------------------------------------------------------------------------------
fprintf('\n time-zero, and unit convertion \n')

load(strcat(data_path_,data_name_,cog_,'.mat'));
% extract values
d = radargram.d;
t = radargram.t; %          [ns]
dt = radargram.dt; %        [ns]
fo = radargram.fo; %        [Hz]
r = radargram.r; %          [m]
dr = radargram.dr; %        [m]
dsr = radargram.dsr; %      [m]
% remove negative time nonsense
t = t - t(1);
% overwrite
radargram.t = t;
% GHz
radargram.fo = fo*1e-3; % [GHz]
name = strcat(data_path_,data_name_,cog_,'.mat');
save( name , 'radargram' );

% ------------------------------------------------------------------------------
% see if we actually did this right
% ------------------------------------------------------------------------------


load(strcat(data_path_,data_name_,cog_,'.mat'));
d=radargram.d;
t=radargram.t;
rx=radargram.r;
figure;
fancy_imagesc(d,rx,t,0.2)
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['common offset gather ',num2str(dsr),'$m$'])
fancy_figure()

%}