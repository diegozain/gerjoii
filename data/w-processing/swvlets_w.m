close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
% WARNING:
% run after datavis_w3.m and field_w.m
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   Get all source-signatures.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat/');
data_name_ = 'line';
% -
ls(data_path_);
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% -
prompt = '    is this gerjoii synthetic data, (y or n):  ';
synthetic_ = input(prompt,'s');
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
good_lines=field_.w.good_lines;
% ------------------------------------------
%  compute dx, choose and compute dt_cfl
% ------------------------------------------
% compute dx
dx = v_min/(nl*f_max); % [m]
dx = dr / ceil(dr/dx);  %     to not alias receivers
dz=dx;
fprintf('\n dx is %d m',dx)
% compute dt
dt_cfl = cf*( 1./( v_max*sqrt(2/dx^2)  ) ); % [ns]
% ------------------------------------------------------------------------------
source_no = (iline_:iline__); 
ns = numel(source_no);
fprintf('\n    # of lines = %i\n\n',ns)
% ------------------------------------------------------------------------------
amax=zeros(ns,1);
% this is a cell because we do not know the size of the new interpolated time.
s_wvlets  = cell(1,ns);
gaussians_= cell(1,ns);
% ------------------------------------------------------------------------------
figure;hold on
for is=1:ns;
  fprintf('source for line # %i\n',is)
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
  fny = 1/dt/2;
  nt = numel(t);
  rx = r(:,1);
  rz = r(:,2);
  nr = numel(rx);
  % ----------------------------------------------------------------------------
  %   WARNING: this part is only for synthetic data
  % ----------------------------------------------------------------------------
  if strcmp(synthetic_,'y')
    t  = 1e+9 *t;   %        [ns]
    dt = 1e+9 *dt; %        [ns]
    fo = 1e-9 *fo; %        [GHz]
  end
  % ----------------------------------------------------------------------------
  % dewow
  d = dewow(d,dt,fo);
  % ----------------------------------------------------------------------------
  % filter
  d = filt_gauss(d,dt,f_low,f_high,10);
  % 2.5d -> 2d
  sR = w_dsr(s,r);
  filter_ = w_bleistein(t,sR,v_2d);
  d = w_2_5d_2d(d,filter_);
  % ----------------------------------------------------------------------------
  %   fourier interpolation
  [d,t] = interp_fourier(d,t,dt,dt_cfl);
  nt = numel(t);
  dt = dt_cfl;
  % ----------------------------------------------------------------------------
  % # of early samples to cut due to clipping and/or noise
  [d,r,dsr] = w_amputate(d,r,dsr,r_keepx_,r_keepx__);
  % ----------------------------------------------------------------------------
  %                             source estimation
  % ----------------------------------------------------------------------------
  d_lmo = lmo(d,t,rx,v_ground);
  % ground velocity
  t_sr = dsr/v_ground; % [ns]
  % ground wave 
  t_  = t_ground_  + t_sr; % [ns]
  t__ = t_ground__ + t_sr; % [ns]
  % stack linear moveout
  [s_wvlet,d_muted,gaussian_] = lmo_source(d_lmo,t,t__,t_);
  % get time-sr in time-index
  it_sr = binning(t,t_sr);
  % shift source and gaussian up to match when it was shot
  s_wvlet( 1:(nt-it_sr+1) )   = s_wvlet( it_sr:nt );
  gaussian_( 1:(nt-it_sr+1) ) = gaussian_( it_sr:nt );
  % --------------------------------------------------------------------------
  % get amplitudes and their distances
  % --------------------------------------------------------------------------
  % compute distance from source to receivers
  sR = w_dsr(s,r);
  % get amplitudes from peak of lmo wave
  % [a_o,~] = max(d_muted); 
  a_o = abs(min(d_muted));
  a_o=a_o.';
  % window-mean the amplitudes
  cc=5; % 5 samples to mean 
  [a_o,~] = window_mean(a_o,cc);
  % --------------------------------------------------------------------------
  %                     hyperbolic amplitude estimation
  % --------------------------------------------------------------------------
  % fit hyperbola
  [dd,bb,cc] = fit_hyperbola2(a_o,sR,[1; 1; 1]);
  fprintf('   c=%d\n',cc);
  % amplitude at sR=0 (where source is)
  a_ = dd./(bb).^cc;
  % a_ = a_/0.44;
  amax(is) = a_;
  % normalize
  s_wvlet = normali(s_wvlet);
  % ----------------------------------------------------------------------------
  % collect all sources
  s_wvlets{is} = s_wvlet;
  gaussians_{is} = gaussian_;
  % ----------------------------------------------------------------------------
  % set colors for sections of the survey
  if is<=fix(ns/3)
    colo = [1 0 0];
  elseif and(is>=fix(ns/3),is<=fix(2*ns/3))
    colo = [0 1 0];
  elseif is>fix(2*ns/3)
    colo = [0 0 1];
  end  
  plot(t(1:fix(nt*0.2)),s_wvlet(1:fix(nt*0.2)),'color',colo )
end
hold off
axis tight
xlabel('Time (ns)')
ylabel('Normalized amplitude')
title('Sources for all lines')
simple_figure()
% ------------------------------------------------------------------------------
% cell2mat for source-wavelets
s_wvlets  = cell2mat(s_wvlets);
gaussians_= cell2mat(gaussians_);
% ------------------------------------------------------------------------------
% trim time
it_o = binning(t,t_o);
if it_o~=1
  s_wvlets( 1:it_o,: ) = [];
  gaussians_(1:it_o,:) = [];
  t((nt-it_o+1):nt)    = [];
  nt = numel(t);
end
% ------------------------------------------------------------------------------
% trim down chosen amplitudes
amax_ = amax(1:min(good_lines,ns));
% ------------------------------------------------------------------------------
figure;
hold on
plot(amax,'.-','markersize',30)
plot(mean(amax_)*ones(size(amax_)),'-.','markersize',30)
hold off
grid on
xlabel('Line #')
ylabel('Max amplitude (V/m)')
title('Fitted amplitude for all sources')
simple_figure()
% ------------------------------------------------------------------------------
% 
% ------------------------------------------------------------------------------
gaussian_=mean(gaussians_(:,1:min(good_lines,ns)),2);
swvlet = mean(s_wvlets(:,1:min(good_lines,ns)),2);
amax_  = mean(amax_);
% ------------------------------------------------------------------------------
swvlet = normali(swvlet);
% ------------------------------------------------------------------------------
[~,tau_] = max(swvlet);
tau_ = t(tau_);
[wo,tau_]=fit_ricker(swvlet,t,[2.2*fo; tau_],'n');
[wo,bo,tau_,E_] = fit_gabor(swvlet,t,[wo; 20; tau_],'n');
fprintf('\n   fo=%d',wo/2/pi);
fprintf('\n   tau=%d\n\n',tau_);
% s = ( 1-0.5*(wo^2)*(t-tau_).^2 ) .* exp( -0.25*(wo^2)*(t-tau_).^2 );
s = exp(-((t-tau_).^2)./(bo^2)) .* cos(wo*(t-tau_));
% ------------------------------------------------------------------------------
swvlet = swvlet/abs(min(swvlet));
swvlet = amax_*swvlet;
% ------------------------------------------------------------------------------
s = s/abs(min(s));
s = amax_*s;
% ------------------------------------------------------------------------------
% yee grid source
s_ = integrate(s,dt,0);
s_ = - gaussian_.*s_;
% ------------------------------------------------------------------------------
figure;
hold on
plot(t(1:fix(nt*0.2)),swvlet(1:fix(nt*0.2)),'k-','linewidth',5)
% plot(t(1:fix(nt*0.2)),s_(1:fix(nt*0.2)),'-.','linewidth',5)
plot(t(1:fix(nt*0.2)),s(1:fix(nt*0.2)),'-.','linewidth',5)
plot(t(1:fix(nt*0.2)),gaussian_(1:fix(nt*0.2))*max(s),'-.','linewidth',5)
hold off
axis tight
xlabel('Time (ns)')
ylabel('Amplitude (V/m)')
title('Average source')
simple_figure()
% ------------------------------------------------------------------------------
%  compute dx, dt_cfl, x and z for size of wave cube
% ------------------------------------------------------------------------------
% build x and z 
% x & z will be larger because of pml.
x=field_.aa:dx:field_.bb;
z=field_.aa:dz:field_.cc;
% ------------------------------------------------------------------------------
%   size of wave cube
% ------------------------------------------------------------------------------
fprintf('\n\nwave cube will be of approx size (no pml, no air):  %1d [Gb]\n',...
          numel(x)*numel(z)*numel(t)*8*1e-9);
% ------------------------------------------------------------------------------
%                           save master wavlet?
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save master source wavelet? (y/n)  ';
src_yn = input(prompt,'s');
if strcmp(src_yn,'y')
  field_.w.wvlet_ = s_;
  field_.w.wvlet  = s;
  field_.w.gaussian_ = gaussian_;
  save(strcat('../raw/',project_name,'/w-data/',project_name,'_w.mat'),'field_');
  fprintf('\n    ok, source wavelet is saved in field_.w.wvlet_ \n\n',is)
else
  fprintf('\n    ok, source wavelet is not saved.\n\n',is)
end

