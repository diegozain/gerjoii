close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
%
% prepare ss2gerjoii_w data to use with fwi scheme
%
% ------------------------------------------------------------------------------
% WARNING:
% run after datavis_w3.m, field_w.m & swvlets_w.m
% ------------------------------------------------------------------------------
% must choose existing project:
project_name = 'bhrs';
% ------------------------------------------------------------------------------
fprintf('\n ------------------------------------------------------------------')
fprintf('\n   prepare GPR data to use with fwi scheme for project: %s',project_name)
fprintf('\n ------------------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
% load field_ structure
load(strcat('../raw/',project_name,'/w-data/',project_name,'_w.mat'));
% ------------------------------------------------------------------------------
% constants
cf = field_.w.cf;
nl = field_.w.nl;
c  = field_.w.c;
% ns  --> s  | *1e-9
% MHz --> Hz | *1e+6
% GHz --> Hz | *1e+9
% ------------------------------------------------------------------------------
% domain
% begining of x & z domain. first source or some other number (m)
aa = field_.aa;
% ending of x domain. last receiver or some other number (m)
% has to be larger or equal than last receiver + x_push
bb = field_.bb;
% ending of z domain. (m)
cc = field_.cc;
% ------------------------------------------------------------------------------
f_low  = field_.w.f_low;
f_high = field_.w.f_high;
f_max  = field_.w.f_max;
v_min  = field_.w.v_min;
v_2d   = field_.w.v_2d;
t_o    = field_.w.t_o;
nt     = field_.w.nt;
eps_max= field_.w.eps_max;
eps_min= field_.w.eps_min;
v_max  = field_.w.v_max;
dr     = field_.w.dr;
x_push = field_.x_push;
% --
MUTE  = field_.w.MUTE;
% --
wvlet  = field_.w.wvlet;
wvlet_ = field_.w.wvlet_;
gaussian_=field_.w.gaussian_;
% ------------------------------------------------------------------------------
%  compute dx, choose and compute dt_cfl
% ------------------------------------------------------------------------------
% compute dx
dx = v_min/(nl*f_max); % [m]
dx = dr / ceil(dr/dx); %     to not alias receivers
dz = dx;
fprintf('\n dx is %d [m]\n',dx)
% compute dt
dt_cfl = cf*( 1./( v_max*sqrt(2/dx^2)  ) ); % [ns]
% ------------------------------------------------------------------------------
%  print
% ------------------------------------------------------------------------------
fprintf('vel max    = %2.2d  [m/ns]\n',v_max)
fprintf('eps min    = %2.2d        [ ]\n',eps_min)
fprintf('vel min    = %2.2d  [m/ns]\n',v_min)
fprintf('eps max    = %2.2d  [ ]\n',eps_max)
fprintf('f max      = %2.2d  [GHz]\n',f_max)
fprintf('dx         = %2.2d  [m]\n',dx)
fprintf('dt cfl     = %2.2d  [ns]\n\n',dt_cfl)
% ------------------------------------------------------------------------------
data_path_  = strcat('../raw/',project_name,'/w-data/','data-mat/');
data_path__ = strcat('../raw/',project_name,'/w-data/','data-mat-fwi/');
data_name_  = 'line';
% ------------------------------------------------------------------------------
%  init src & recs
% ------------------------------------------------------------------------------
% s_r is a cell where,
%
% s_r{shot #, 1}(:,1) is sx
% s_r{shot #, 1}(:,2) is sz
% s_r{shot #, 2}(:,1) is rx
% s_r{shot #, 2}(:,2) is rz
load(strcat(data_path_,'s_r','.mat'));
ns = size(s_r,1);
s_r_ = cell(ns,2); % s_r;
% ------------------------------------------------------------------------------
% build domain
% ------------------------------------------------------------------------------
% build x and z
x  = aa:dx:bb;
z  = aa:dz:cc;
% ------------------------------------------------------------------------------
%   source wavelets
% ------------------------------------------------------------------------------
wvlets_ = zeros(numel(wvlet_),ns);
gaussians_ = zeros(numel(gaussian_),ns);
% ------------------------------------------------------------------------------
%   main loop
% ------------------------------------------------------------------------------
for is=1:ns;
  % ------------------------------------------
  %   read .mat time shifted data
  % ------------------------------------------
  fprintf('    processing shot-gather %i\n',is);
  load(strcat(data_path_,data_name_,num2str(is),'.mat'));
  d   = radargram.d;
  t   = radargram.t;   %        [ns]
  dt  = radargram.dt;  %        [ns]
  fo  = radargram.fo;  %        [GHz]
  r   = radargram.r;   %        [m] x [m]
  s   = radargram.s;   %        [m] x [m]
  dr  = radargram.dr;  %        [m]
  dsr = radargram.dsr; %        [m]
  % ----------------------------------------------------------------------------
  t_ground_  = radargram.t_ground_;
  t_ground__ = radargram.t_ground__;
  v_ground   = radargram.v_ground;
  r_keepx_   = radargram.r_keepx_;
  r_keepx__  = radargram.r_keepx__;
  % ----------------------------------------------------------------------------
  if isfield(radargram,'v_mute')
    v_mute = radargram.v_mute; % m/ns
    t_mute = radargram.t_mute; % ns
  end
  % ----------------------------------------------------------------------------
  t_fa = radargram.t_fa; %       [ns]
  % ----------------------------------------------------------------------------
  fny = 1/dt/2;
  nt = numel(t);
  rx = r(:,1);
  rz = r(:,2);
  nr = numel(rx);
  % ----------------------------------------------------------------------------
  % dewow
  d = dewow(d,dt,fo);
  % ----------------------------------------------------------------------------
  % filter
  d = filt_gauss(d,dt,f_low,f_high,10);
  % ----------------------------------------------------------------------------
  % % mute unwanted events
  % % NOTE: this shouldn't be here. it is already in datamute_w.m!!!
  % if strcmp(MUTE,'yes_MUTE')
  %   d = linear_mute(d,dr,t,t_mute,v_mute);
  % end
  % ----------------------------------------------------------------------------
  % 2.5d -> 2d
  sR = w_dsr(s,r);
  filter_ = w_bleistein(t,sR,v_2d);
  d = w_2_5d_2d(d,filter_);
  % ----------------------------------------------------------------------------
  % fourier interpolation
  [d,t] = interp_fourier(d,t,dt,dt_cfl);
  nt = numel(t);
  dt = dt_cfl;
  % ----------------------------------------------------------------------------
  %   amputate unwanted receivers
  % ----------------------------------------------------------------------------
  [d,r,dsr] = w_amputate(d,r,dsr,r_keepx_,r_keepx__);
  rx = r(:,1);
  rz = r(:,2);
  nr = numel(rx);
  % ----------------------------------------------------------------------------
  % trim time
  it_o = binning(t,t_o);
  if it_o~=1
    d( 1:it_o,: )       = [];
    t((end-it_o+1):end) = [];
    nt = numel(t);
  end
  % ----------------------------------------------------------------------------
  t_fa       = t_fa-t_o;
  t_ground_  = t_ground_-t_o;
  t_ground__ = t_ground__-t_o;
  % ----------------------------------------------------------------------------
  % source wavelet
  % NOTE: same source for all.
  
  % ----------------------------------------------------------------------------
  % standard deviation
  [nt,nr] = size(d);
  std_ = ones(nt*nr,1);
  % ----------------------------------------------------------------------------
  % push all receivers x_push to give the fwd solver some room
  rx = rx+x_push;
  r  = [rx,rz];
  sx = s(:,1);
  sz = s(:,2);
  sx = sx+x_push;
  s  = [sx,sz];
  % ----------------------------------------------------------------------------
  %   overwrite
  % ----------------------------------------------------------------------------
  radargram.r = r;           % [m] real numbers
  radargram.s = s;           % [m] real numbers
  radargram.d = d;           % [ns] x [m]
  radargram.fo = fo;         % [GHz]
  radargram.f_low  = f_low;  % [GHz]
  radargram.f_high = f_high; % [GHz]
  radargram.t = t;           % [ns]
  radargram.dx = dx;         % [m]
  radargram.std_ = std_;
  radargram.wvlet  = wvlet;
  radargram.wvlet_ = wvlet_;
  % ----------------------------------------------------------------------------
  radargram.t_fa       = t_fa;
  radargram.t_ground_  = t_ground_;
  radargram.t_ground__ = t_ground__;
  % ----------------------------------------------------------------------------
  % store wvlets_
  % ----------------------------------------------------------------------------
  wvlets_(:,is) = wvlet_;
  gaussians_(:,is) = gaussian_;
  % ----------------------------------------------------------------------------
  %   binned-real and binned-indices of new r and s
  % ----------------------------------------------------------------------------
  s_r{is, 2} = r;
  s_r{is, 1}(:,1) = sx;
  s_r{is, 1}(:,2) = sz;
  receivers = [uint32(binning(x,rx)) , uint32(binning(z,rz))];
  s_r_{is, 2} = receivers;
  % s_r_{is, 2}((nr+1):end,:) = [];
  sources = [uint32(binning(z,sz)) , uint32(binning(x,sx))];
  s_r_{is, 1} = sources;
  % ----------------------------------------------------------------------------
  %   save to disk
  % ----------------------------------------------------------------------------
  % overwrite
  name = strcat(data_path__,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end
% ----------------------------------------------------------------------------
%   parameters
% ----------------------------------------------------------------------------
parame_ = struct;
% domain
parame_.aa = aa;
parame_.bb = bb;
parame_.cc = cc;
% GIVEN by nature and gpr system
parame_.w.eps_0 = 8.854187817e-12;   % [F/m]             
parame_.w.mu_0  = 4*pi*1e-7;         % [H/m]
parame_.w.c     = 1/sqrt(parame_.w.mu_0*parame_.w.eps_0); % [m/s]
parame_.w.fo    = fo * 1e+9; % [Hz]
% INTERPRETED by human analysis
parame_.w.fo      = fo*1e+9;   % [Hz]
% parame_.w.t_ground_  = t_ground_*1e-9;  % [s]
% parame_.w.t_ground__ = t_ground__*1e-9; % [s]
% parame_.w.v_ground   = v_ground*1e+9;  % [m/s]
parame_.w.v_min   = v_min*1e+9; % [m/s]
parame_.w.v_max   = v_max*1e+9; % [m/s]
parame_.w.eps_max = eps_max;    % [ ]
parame_.w.eps_min = eps_min;    % [ ]
parame_.w.f_max   = f_max*1e+9; % [Hz]
parame_.w.f_low   = f_low*1e+9; % [Hz]
parame_.w.f_high  = f_high*1e+9; % [Hz]
parame_.w.MUTE    = MUTE;
% DERIVED
parame_.x  = x;          % [m]
parame_.z  = z;          % [m]
parame_.dx = dx;         % [m]
parame_.dz = dz;         % [m]
parame_.w.dt = dt_cfl * 1e-9; % [s]
parame_.w.t  = t * 1e-9; % [s]
parame_.w.nt = numel(t);
% ------------------------------------------------------------------------------
%   size of wave cube
% ------------------------------------------------------------------------------
fprintf('\n\nwave cube will be of size (no pml, no air) %1d [Gb]\n\n',...
          numel(x)*numel(z)*numel(t)*8*1e-9);
% ------------------------------------------------------------------------------
%   wavelets
% ------------------------------------------------------------------------------
parame_.w.wvlets_    = wvlets_;
parame_.w.gaussians_ = gaussians_;
% ------------------------------------------------------------------------------
name = strcat(data_path__,'parame_','.mat');
save( name , 'parame_' );
% ------------------------------------------------------------------------------
%   sources and receivers
% ------------------------------------------------------------------------------
% binned
name = strcat(data_path__,'s_r_','.mat');
save( name , 's_r_' );
% real
name = strcat(data_path__,'s_r','.mat');
save( name , 's_r' );
% ------------------------------------------------------------------------------
fprintf('\n\n     just saved parame_, s_r and s_r_ in data-mat-fwi.\n')
% ------------------------------------------------------------------------------
%
%
%  										see if we actually did this right
%
%
% ------------------------------------------------------------------------------
clear
% ------------------------------------------------------------------------------
% must choose existing project:
project_name = 'bhrs';
data_path__ = strcat('../raw/',project_name,'/w-data/','data-mat-fwi/');
data_name_  = 'line';
% ------------------------------------------------------------------------------
load(strcat(data_path__,'s_r','.mat'));
load(strcat(data_path__,'s_r_','.mat'));
ns = size(s_r,1);
load(strcat(data_path__,'parame_','.mat'));
nt = parame_.w.nt;
x  = parame_.x;
% ------------------------------------------------------------------------------
% lista = [13,14,15,27,28];
lista = [1];
% lista = [1,7,15,22,30];
for i_=1:numel(lista)
is = lista(i_);
load(strcat(data_path__,data_name_,num2str(is),'.mat'));
d=radargram.d;
t=radargram.t;
r=radargram.r;
rx=r(:,1);
% ----------------------------------------------------------------------------
figure;
fancy_imagesc(d,rx,t);
axis normal
xlabel('Receivers (m)')
ylabel('Time (ns)')
title(['Line # ',num2str(is)])
simple_figure()
% ----------------------------------------------------------------------------
wigb(d,1,rx,t);
axis normal
xlabel('Receivers (m)')
ylabel('Time (ns)')
title(['Line # ',num2str(is)])
simple_figure()
end
% ----------------------------------------------------------------------------
% plot wavelet sources
figure;
hold on
for is=1:ns
% is = lista(i_);
load(strcat(data_path__,data_name_,num2str(is),'.mat'));
t=radargram.t;
wvlet = radargram.wvlet;
plot(t,wvlet)
end
hold off
axis tight
ylabel('Amplitude (V/m)')
xlabel('Time (ns)')
title('all sources')
simple_figure()
% ----------------------------------------------------------------------------
% plot wavelet sources - wigb
sources = zeros(nt,ns);
for is=1:ns
% is = lista(i_);
load(strcat(data_path__,data_name_,num2str(is),'.mat'));
t=radargram.t;
wvlet = radargram.wvlet;
sources(:,is) = wvlet;
end
wigb(sources,1,1:ns,t);
xlabel('Line #')
ylabel('Time (ns)')
title('all sources')
simple_figure()
% ----------------------------------------------------------------------------
% plot src-rec of survey
figure;
hold on
for is=1:ns
  plot(s_r{is,1}(:,1),s_r{is,1}(:,2)+is,'r.','MarkerSize',25)
  plot(s_r{is,2}(:,1),s_r{is,2}(:,2)+is,'k.','MarkerSize',10)
end
hold off
axis tight
xlabel('Length (m)')
ylabel('Line #')
title('Sources and receivers')
simple_figure()
% ----------------------------------------------------------------------------
wigb(radargram.d,1,x(s_r_{is,2}(:,1)),radargram.t); 
ylabel('Time (ns)');
xlabel('receivers [m]');
title('Data');
simple_figure();
% ----------------------------------------------------------------------------
figure;
hold on
for is=1:ns
plot(diff(x(s_r_{is,2}(:,1))),'.-','Markersize',10)
end
hold off
axis tight
ylabel('drx (m)');
xlabel('Receiver index');
title('Derivative of binned receivers');
simple_figure();
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% 
% now you can go to:   gerjoii/field/project/sub-project/scripts,
% ex.
% cd strcat('../../field/',project_name,project_name_,'/scripts/')
%
% or
%
% cd ../../field/bhrs/base/scripts
% ------------------------------------------------------------------------------