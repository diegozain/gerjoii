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
fprintf('           Make sure you ran ss2gerjoii_w.m first!!\n\n')

fprintf('           This script will give all lines the same parameters. \n')
fprintf('           If you want different parameters for each line,  \n')
fprintf('           run datavis_w.m.\n\n')
fprintf('           Whatever you decide, run datavis_w.m first to have\n')
fprintf('           an idea of what is going on with the data.\n\n')
fprintf('\n --------------------------------------------------------')
fprintf('\n    make sure the file pp_csg_w.m is the one you want')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
ls('../raw/');
prompt = '\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat');
% ------------------------------------------------------------------------------
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% ------------------------------------------------------------------------------
source_no = (iline_:iline__); 
ns = numel(source_no);
fprintf('\n    # of lines = %i\n\n',ns)
data_name_ = 'line';
% ------------------------------------------------------------------------------
for is=1:ns
  % ----------------------------------------------------------------------------
  fprintf('    saving pre-processing parameters for shot-gather %i\n',is);
  % ----------------------------------------------------------------------------
  load(strcat(data_path_,'-raw/',data_name_,num2str(is),'.mat'));
  % ----------------------------------------------------------------------------
  d   = radargram.d;
  t   = radargram.t;  %        [ns]
  dt  = radargram.dt; %        [ns]
  fo  = radargram.fo; %        [GHz]
  r   = radargram.r;  %        [m] x [m]
  s   = radargram.s;  %        [m] x [m]
  dr  = radargram.dr; %        [m]
  dsr = radargram.dsr;%        [m]rx=s_r{is,2}(:,1);
  
  rx = r(:,1);
  rz = r(:,2);
  % ----------------------------------------------------------------------------
  % load preprocessing parameters into radargram struct
  % ----------------------------------------------------------------------------
  pp_csg_w;
  % ----------------------------------------------------------------------------
  if exist('flip_polarity')
    radargram.d=-d;
  end
  % ----------------------------------------------------------------------------
  % save all current preprocessing parameters.
  % this saves JUST the preprocessing parameters, 
  % the data stays untouched.
  % ----------------------------------------------------------------------------
  name = strcat(data_path_,'/',data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end
% ------------------------------------------------------------------------------
