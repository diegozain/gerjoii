% ------------------------------------------------
%
% prepare ss2gerjoii_w data to use with fwi scheme
%
% ------------------------------------------------ 
close all
clear all
clc
addpath('read-data');
% constants
cf=0.9; % [ ]
nl=10;  % [ ]
% c=299792458; % [m/s]
c=0.299792458; % [m/ns]
% ------------------------------------------
% load values computed from datavis_w 
% ------------------------------------------
groningen2_w;
% ------------------------------------------
%  compute dx, choose and compute dt_cfl
% ------------------------------------------
% compute dx
dx = v_min/(nl*f_max); % [m]  wavelength condition
dr = 0.03; % [m]              receiver spacing
dx = dr / ceil(dr/dx);  %     to not alias receivers
dz = dx;
% compute dt
v_max = c./(sqrt(eps_min)); % [m/ns]
dt_ = cf*( 1./( v_max*sqrt(2/dx^2)  ) ); % [ns]
% dt_ = dt_*1e+9;
% ------------------------------------------
%  print
% ------------------------------------------
fprintf('t fa       = %2.2d        [ns]\n',t_fa)
fprintf('vel max    = %2.2d  [m/ns]\n',v_max)
fprintf('eps min    = %2.2d        [ ]\n',eps_min)
fprintf('vel min    = %2.2d  [m/ns]\n',v_min)
fprintf('eps max    = %2.2d  [ ]\n',eps_max)
fprintf('f max      = %2.2d  [GHz]\n',f_max)
fprintf('dx         = %2.2d  [m]\n',dx)
fprintf('dt cfl     = %2.2d  [ns]\n\n',dt_)
% ------------------------------------------
%  build distances from src to rec
% ------------------------------------------
% s_r is a cell where,
%
% s_r{shot #, 1}(:,1) is sx
% s_r{shot #, 1}(:,2) is sz
% s_r{shot #, 2}(:,1) is rx
% s_r{shot #, 2}(:,2) is rz
load(strcat(data_path_,'s_r','.mat'));
s_r_ = s_r;
% first source
x_begin = s_r{1,1}(1,1);
% last receiver
x_end = s_r{ns,2}(end,1);
% build x and z
x = x_begin:dx:(x_end+dx);
z = 0:dx:(4);
% ------------------------------------------
%   source wavelet
% ------------------------------------------
wvlets_ = cell(1,ns);
% ------------------------------------------
%   main loop
% ------------------------------------------
for is=1:ns;
  % ------------------------------------------
  %   read .mat time shifted data
  % ------------------------------------------
  fprintf('    processing shot-gather %i\n',is);
  load(strcat(data_path_,data_name_,num2str(is),'.mat'));
  d = radargram.d;
  t = radargram.t; %          [ns]
  dt = radargram.dt; %        [ns]
  fo = radargram.fo; %        [GHz]
  r = radargram.r; %          x[m] x z[m]
  s = radargram.s; %          x[m] x z[m]
  dr = radargram.dr; %        [m]
  dsr = radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
  nt = numel(t);
  nr = size(r,1);
  % ------------------------------------------
  %   remove wow
  % ------------------------------------------
  % remove wow
  d = dewow(d,dt,fo);
  % taper edges to zero
  % before fourier
  for i=1:nr
    d(:,i) = d(:,i) .* tukeywin(nt,0.1);
  end
  % ------------------------------------------
  %   cook raw data. for "interpretation"
  % ------------------------------------------
  % filter
  nbutter = 10;
  d = butter_butter(d,dt,f_low,f_high,nbutter);
  % ------------------------------------------
  %   amputate unwanted receivers
  % ------------------------------------------
  rx = r(:,1);
  rz = r(:,2);
  r_keepx_ = rx+r_keepx;
  r_keepx_ = binning(rx,r_keepx_);
  rx = rx(1:r_keepx_);
  rz = rz(1:r_keepx_);
  d = d(:,1:r_keepx_);
  % ------------------------------------------
  %   save binned-real and binned-indices of new r and s
  % ------------------------------------------
  r = [rx,rz];
  s_r{is, 2} = r;
  s_r_{is, 2} = r;
  sx = s_r{is, 1}(:,1);
  sz = s_r{is, 1}(:,2);
  s_r_{is, 2}(:,1) = binning(x,rx);
  s_r_{is, 2}(:,2) = binning(z,rz);
  s_r_{is, 1}(:,1) = binning(x,sx);
  s_r_{is, 1}(:,2) = binning(z,sz);
  % ------------------------------------------
  %   2.5d --> 2d
  % ------------------------------------------
  v_ = v_min;
  sR = w_dsr(s,r);
  filter_ = w_bleistein(t,sR,v_);
  d = w_2_5d_2d(d,filter_);
  % ------------------------------------------
  %   mute unwanted events
  % ------------------------------------------
  % % ground
  % t_fa = 30; %   [s]
  % vel_ = 0.055; % [m/ns]
  % % air
  % t_fa = 16; % [ns]
  % vel_ = c; % [m/ns]
  d = linear_mute(d,dr,t,t_fa,vel_);
  % ------------------------------------------
  %   interpolate
  % ------------------------------------------
  t_ = (t(1):dt_:t(nt)).';
  d = interp1(t,d,t_,'spline');
  t=t_;
  nt=numel(t);
  % ------------------------------------------
  % source signature
  % ------------------------------------------
  % lmo
  d_lmo = lmo(d,t,dr,vel_);
  % lmo+mute
  [wvlet,d_muted,gaussian_] = lmo_source(d_lmo,t,t_fa_,t_fa);
  % --
  % time zero correction
  % --
  % using velocity of propagation and dsr get time from src to first rec
  t_sr = dsr/vel_; % [ns]
  % get time-zero (when src originated)
  t_zero = t_fa - t_sr; % [ns]
  % get time-zero in time-index
  it_zero = binning(t,t_zero);
  % shift source and gaussian up
  wvlet( 1:nt-it_zero+1 ) = wvlet( it_zero:nt );
  gaussian_( 1:nt-it_zero+1 ) = gaussian_( it_zero:nt );
  % amplitude correction
  [a_o,~] = max(d_muted); a_o=a_o.';
  [dd,bb,cc] = fit_hyperbola(a_o,sR);
  % amplitude at sR=0 (where source is)
  a_ = dd./((bb).^cc);
  % correct for amplitude
  wvlet = a_ * (wvlet/max(wvlet));
  % integrate for Yee grid
  wvlet_ = integrate(wvlet,dt,0);
  wvlet_ = - gaussian_.*wvlet_;
  % collect
  radargram.wvlet  = wvlet;
  radargram.wvlet_ = wvlet_;
  wvlets_{is} = wvlet_;
  % ------------------------------------------
  %   standard deviation
  % ------------------------------------------
  [nt,nr] = size(d);
  std_ = ones(nt*nr,1);
  radargram.std_ = std_;
  % ------------------------------------------
  %   overwrite
  % ------------------------------------------
  radargram.r = r;           % [m] real numbers
  radargram.d = d;           % [ns] x [m]
  radargram.fo = fo;         % [GHz]
  radargram.f_low = f_low;   % [GHz]
  radargram.fc = fc;         % [GHz]
  radargram.f_high = f_high; % [GHz]
  radargram.t = t;           % [ns]
  radargram.dx = dx;         % [m]
  % ------------------------------------------
  %   save to disk
  % ------------------------------------------
  % overwrite
  name = strcat(data_path_,data_name_,num2str( is ),'.mat');
  save( name , 'radargram' );
end
% --------------------
%   parameters
% --------------------
parame_ = struct;
% GIVEN by nature and gpr system
parame_.w.eps_0 = 8.854187817e-12;   % [F/m]             
parame_.w.mu_0  = 4*pi*1e-7;         % [H/m]
parame_.w.c     = 1/sqrt(parame_.w.mu_0*parame_.w.eps_0); % [m/s]
parame_.w.fo    = fo * 1e+9; % [Hz]
% INTERPRETED by human analysis
parame_.w.fo_     = fo_*1e+9;   % [Hz]
parame_.w.t_fa    = t_fa*1e-9;  % [s]
parame_.w.t_fa_   = t_fa_*1e-9; % [s]
parame_.w.vel_    = vel_*1e+9;  % [m/s]
parame_.w.v_min   = v_min*1e+9; % [m/s]
parame_.w.v_max   = v_max*1e+9; % [m/s]
parame_.w.eps_max = eps_max;    % [ ]
parame_.w.eps_min = eps_min;    % [ ]
parame_.w.f_max   = f_max*1e+9; % [Hz]
% DERIVED
parame_.x  = x;          % [m]
parame_.z  = z;          % [m]
parame_.dx = dx;         % [m]
parame_.dz = dz;         % [m]
parame_.w.dt = dt_ * 1e-9; % [s]
parame_.w.t  = t * 1e-9;   % [s]
parame_.w.nt = numel(t);

name = strcat(data_path_,'parame_','.mat');
save( name , 'parame_' );
% --------------------
%   sources and receivers
% --------------------
% binned
name = strcat(data_path_,'s_r_','.mat');
save( name , 's_r_' );
% real
name = strcat(data_path_,'s_r','.mat');
save( name , 's_r' );
% --------------------
%   sources wavelet
% --------------------
wvlets_ = cell2mat(wvlets_);
name = strcat(data_path_,'wvlets_','.mat');
save( name , 'wvlets_');
% ------------------------------------------------------------------------------
% see if we actually did this right
% ------------------------------------------------------------------------------

% lista = [13,14,15,27,28];
lista = [1];
% lista = [1,7,15,22,30];
for i_=1:numel(lista)
is = lista(i_);
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
d=radargram.d;
t=radargram.t;
r=radargram.r;
rx=r(:,1);
figure;
fancy_imagesc(d(binning(t,63*1e-9):end,:),rx,t(binning(t,63*1e-9):end));
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['shot \# ',num2str(is)])
fancy_figure()

wigb(d,1,rx,t);
axis normal
xlabel('receivers $x\,[m]$')
ylabel('$t\,[ns]$')
title(['shot \# ',num2str(is)])
fancy_figure()
end

% plot wavelet sources
figure;
hold on
for is=1:ns
% is = lista(i_);
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
t=radargram.t;
wvlet = radargram.wvlet;
plot(t,wvlet)
end
hold off
axis tight
ylabel('$u\;[V/m]$')
xlabel('$t\,[ns]$')
title('all sources')
fancy_figure()

% plot wavelet sources - wigb
sources = zeros(nt,ns);
for is=1:ns
% is = lista(i_);
load(strcat(data_path_,data_name_,num2str(is),'.mat'));
t=radargram.t;
wvlet = radargram.wvlet;
sources(:,is) = wvlet;
end
wigb(sources,1,1:ns,t);
xlabel('shot \#')
ylabel('$t\,[ns]$')
title('all sources')
fancy_figure()

% plot src-rec of survey
figure;
hold on
for is=1:ns
  plot(s_r{is,1}(:,1),s_r{is,1}(:,2)+is,'r.','MarkerSize',25)
  plot(s_r{is,2}(:,1),s_r{is,2}(:,2)+is,'k.','MarkerSize',10)
end
hold off
axis tight
xlabel('survey length $x\,[m]$')
ylabel('shot \#')
title('sources and receivers')
fancy_figure()

wigb(radargram.d,1,x(s_r_{is,2}(:,1)),radargram.t); 
ylabel('$t$ [ns]');
xlabel('receivers [m]');
title('data');
fancy_figure();

figure;
hold on
for is=1:ns
plot(diff(x(s_r_{is,2}(:,1))),'.-','Markersize',10)
end
hold off
axis tight
ylabel('$\Delta r_x \; [m]$');
xlabel('receiver index');
title('derivative of binned receivers');
fancy_figure();

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% 
% now you can go to,
% 
% cd ../../field/project-name/w-or-dc-or-joint-inv
% 
% for example
%
% cd ../../field/groningen/w-inv
%
% to come back here from there, type
%
% cd ../../../data/w-processing
%
% ss2gerjoii_w; data2fwi_w