close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
data_name_ = 'line';
data_path_ = '../raw/bhrs/w-data/data-mat/';
ns = 30;
ds = 1;
% ------------------------------------------------------------------------------
s_r = cell(ns,2);
for is=1:ns;
  load(strcat(data_path_,data_name_,num2str(is),'.mat'));
  dr = radargram.dr; %        [m]
  dsr = radargram.dsr; %      [m]
  d = radargram.d;          % [ns] x [m]
  % sources in real coordinates
  sx = (is-1)*ds;
  sz = 0;
  s_r{is,1} = [sx sz];
  % --
  [~,nr] = size(d);
  r_all = (0:dr:((nr-1)*dr)).';
  rx = (is-1)*ds + dsr + r_all;
  rz = zeros(numel(rx),1);
  s_r{is,2} = [rx rz];
  % record new src-receivers on shot gather structure
  radargram.r = [rx rz];
  radargram.s = [sx sz];
  % overwrite
  name = strcat(data_path_,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end
% s_r is a cell where, (in real coordinates)
% s_r{shot #, 1}(:,1) is sx
% s_r{shot #, 1}(:,2) is sz
% s_r{shot #, 2}(:,1) is rx
% s_r{shot #, 2}(:,2) is rz
name = strcat(data_path_,'s_r','.mat');
save( name , 's_r' );
% ------------------------------------------------------------------------------
% plot src-rec done
figure;
hold on
for is=1:ns
  plot(s_r{is,1}(:,1)+1,s_r{is,1}(:,2)+is,'r.','MarkerSize',25)
  plot(s_r{is,2}(:,1)+1,s_r{is,2}(:,2)+is,'k.','MarkerSize',10)
end
hold off
axis tight
xlabel('Survey length x (m)')
ylabel('Shot #')
title('Sources and receivers')
grid on
simple_figure()
