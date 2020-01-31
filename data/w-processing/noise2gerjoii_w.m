% ------------------------------------------------
%
% take field synthetic .mat and give 'em noise.
%
%
%
% ------------------------------------------------ 

close all
clear all
clc

% ------------------------------------------------------------------------------
% Loop through done survey lines and save all of the data to .mat in disk.
% Also save r and t as r_all and t_all in memory.
% ------------------------------------------------------------------------------

fprintf('\n saving survey to .mat files\n')

data_path = '../raw/synthetic2/w-data/'; 
data_name = 'line';
data_path_ = '../raw/synthetic2/w-data/data-mat/';
data_name_ = 'line'; % 'cog'; 'line';
% synthetic2: 
% line: (1:3)
source_no = (1:3); 
ns = numel(source_no);
t_all = cell(1,ns);
r_all = cell(1,ns);

fprintf('    # of lines = %i\n',ns)

for is=1:ns;
  load(strcat(data_path,data_name,num2str(is),'.mat'));
  % extract values
  d = radargram.d;
  t = radargram.t; %          [s]
  dt = radargram.dt; %        [s]
  fo = radargram.fo; %        [Hz]
  r = radargram.r; %          [m]
  dr = radargram.dr; %        [m]
  dsr = radargram.dsr; %      [m]
  %
  nt = numel(t);
  rx = r(:,1);
  rz = r(:,2);
  nr = numel(rx);
  %
  prcent = 0.05;
  noise_amp = mean(d(:)) + prcent*std(d(:)); % 1e+2;
  noise = (2*rand(nt,nr)-1) * noise_amp;
  radargram.d = d + noise;
  %
  name = strcat(data_path_,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end