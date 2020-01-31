close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
data_name_ = 'line';
data_path_ = '../raw/bhrs/w-data/data-mat/';
csg_i = 7;
% ------------------------------------------------------------------------------
ns = 30;
ds = 1;
dr = 0.5;
nt = 717;
rx = (0:(ds+csg_i*dr):(ns-1)).';
d_cog = zeros(nt,ns);
% ------------------------------------------------------------------------------
for is=1:ns;
  load(strcat(data_path_,data_name_,num2str(is),'.mat'));
  dsr = radargram.dsr; %      [m]
  d = radargram.d;          % [ns] x [m]
  t = radargram.t; %          [ns]
  dt = radargram.dt; %        [ns]
  fo = radargram.fo; %        [GHz]
  % get first receiver
  d_cog(:,is) = d(:,csg_i+1);
end
% ------------------------------------------------------------------------------
clear radargram;
radargram = struct;
radargram.d = d_cog;
radargram.r = rx;
radargram.t = t;
radargram.dt = dt;
radargram.dr = ds;
radargram.dsr = dsr+csg_i*dr;
radargram.fo = fo;
% ------------------------------------------------------------------------------
name = strcat(data_path_,'cog-rs-',num2str(csg_i),'.mat');
save( name , 'radargram' );
% ------------------------------------------------------------------------------
% plot cog
figure;
fancy_imagesc(d_cog,rx,t)
colormap(rainbow())
axis normal
xlabel('Receivers (m)')
ylabel('Time (ns)')
title('Common offset-gather')
simple_figure()
