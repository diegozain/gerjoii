% ------------------------------------------------------------------------------
%
% take field radargrams and turn them into .mat
% 
% this one is only for COG!!
% (common offset gathers)
% ------------------------------------------------------------------------------
close all
clear all
clc
addpath('read-data')
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will make your data usable for gerjoii.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path = strcat('../raw/',project_name,'/w-data/');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat/');
prompt = '\n    tell me rs or sr for naming cog, eg rs:  ';
cog_ = input(prompt,'s');
% ------------------------------------------------------------------------------
ls(data_path);
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% ------------------------------------------------------------------------------
prompt = '\n    tell me source-receiver distance in meters, eg 0.02:  ';
dsr = input(prompt,'s'); 
dsr=str2double(dsr);
prompt = '\n    tell me frequency used in MHz, eg 250:  ';
fo = input(prompt,'s');
fo = str2double(fo);
% ------------------------------------------------------------------------------
fprintf('\n ok, gonna save survey to .mat files\n')
% ------------------------------------------------------------------------------
cog_no = (iline_:iline__); 
ncog = numel(cog_no);
fprintf('    # of lines = %i\n',ncog)
% ------------------------------------------------------------------------------
data_name = 'LINE';
data_name_ = 'cog-';
% ------------------------------------------------------------------------------
% Loop through done survey lines and save all of the data to .mat in disk.
% Also save r and t as r_all and t_all in memory.
% ------------------------------------------------------------------------------
for icog=1:ncog;
  % correct for LINE04 instead of LINE4
  if cog_no(icog) < 10
    no = strcat(  num2str( 0 ) , num2str( cog_no(icog) ) );
  else 
    no = num2str( cog_no(icog) );
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
  radargram.fo = fo*1e-3;   % [GHz]
  % ----------------------------------------------------------------------------
  % Loop over all saved lines: time shift, unit convert and s_r store
  % ----------------------------------------------------------------------------
  % fprintf('\n time-zero, and unit convertion \n')
  % remove negative time nonsense
  t = t - t(1);
  % overwrite
  radargram.t = t;
  % ----------------------------------------------------------------------------
  name = strcat(data_path_,data_name_,cog_,'-',num2str(cog_no(icog)),'.mat');
  save( name , 'radargram' );
  fprintf(' saved common-offset gather #%i \n',cog_no(icog))
end
% ------------------------------------------------------------------------------
% see if we actually did this right
% ------------------------------------------------------------------------------
load(strcat(data_path_,data_name_,cog_,'-',num2str(cog_no(icog)),'.mat'));
d=radargram.d;
t=radargram.t;
rx=radargram.r;
figure;
fancy_imagesc(d,rx,t,0.2)
axis normal
xlabel('receivers x (m)')
ylabel('time (ns)')
title(['common offset gather ',num2str(dsr),'m'])
simple_figure()
%}