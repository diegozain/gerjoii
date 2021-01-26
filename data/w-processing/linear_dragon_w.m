close all
clear all
clc
% ------------------------------------------------------------------------------
ls('../raw/');
prompt = '\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
ls(strcat('../raw/',project_,'/w-data/data-mat/'));
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% ------------------------------------------------------------------------------
% get depth from a hyperbolic event
% v is linear velocity,
% to is time zero of hyper event (corrected)
% z = v*sqrt( (to/2)^2 - (dsr/(2*v))  )
%
% for groningen2: 
% v=0.054, to=27. but v is up to eps limit, so I lowered it.
z_depth = 2.384; % m
v_hyper = 0.065; % m/ns
% ------------------------------------------------------------------------------
% overlap of shots
n_overlap = 3;
% mute air arrival
c = 0.299792458; % m/ns
t_mute = 33.5;   % ns
v_mute = c;   % m/ns
% choose velocities
v__ = 0.23; % [m/ns]
v_  = 0.072; % [m/ns] (velocity of water 0.03m/ns, rel perm~80)
dv = (v__-v_)*0.01;   % [m/ns]
v = v_ : dv : v__;  % [m/s] velocities to consider
% ------------------------------------------------------------------------------
source_no = (iline_:iline__); 
ns = numel(source_no);
v_lin = zeros(ns,1);
% ------------------------------------------------------------------------------
for is=1:ns
 is_ = source_no(is);
 name_ = strcat('../raw/',project_,'/w-data/data-mat/line',num2str(is_),'.mat');
 load(name_)
 % -----------------------------------------------------------------------------
 d   = radargram.d;
 t   = radargram.t;  %        [ns]
 dt  = radargram.dt; %        [ns]
 fo  = radargram.fo; %        [GHz]
 r   = radargram.r;  %        [m] x [m]
 s   = radargram.s;  %        [m] x [m]
 dr  = radargram.dr; %        [m]
 dsr = radargram.dsr;%        [m]rx=s_r{is,2}(:,1);
 % -----------------------------------------------------------------------------
 f_low = radargram.f_low;
 f_high = radargram.f_high;
 r_keepx_ = radargram.r_keepx_;
 r_keepx__ = radargram.r_keepx__;
 v_2d = radargram.v_2d;
 % -----------------------------------------------------------------------------
 fny = 1/dt/2;
 nt = numel(t);
 rx = r(:,1);
 rz = r(:,2);
 nr = numel(rx);
 % -----------------------------------------------------------------------------
 % dewow
 d = dewow(d,dt,fo);
 % amputate receivers
 [d,r,dsr] = w_amputate(d,r,dsr,r_keepx_,r_keepx__);
 rx = r(:,1);
 rz = r(:,2);
 nr = numel(rx);
 % filter
 d = filt_gauss(d,dt,f_low,f_high,10);
 % 2.5D
 sR = w_dsr(s,r);
 filter_ = w_bleistein(t,sR,v_2d);
 d = w_2_5d_2d(d,filter_);
 % mute
 [d,mute_] = linear_mute(d,dr,t,t_mute,v_mute);
 % linear semblance
 v_analy = v_linear(angle(hilbert(d)),t,rx,v);

 [v_analy,~] = max(v_analy);
 [~,v_analy] = max(v_analy);
 v_analy = v(v_analy);

 v_lin(is) = v_analy;
end
% ------------------------------------------------------------------------------
figure;
plot(source_no,v_lin,'k.-','markersize',25)
axis tight
xlabel('Shot #')
ylabel('Velocity (m/ns)')
title('Linear Velocities per Shot')
simple_figure()
% ------------------------------------------------------------------------------
load(strcat('../raw/',project_,'/w-data/data-mat-fwi/parame_.mat'));
load(strcat('../raw/',project_,'/w-data/data-mat-fwi/s_r_.mat'));
% ------------------------------------------------------------------------------
% s_r is a cell where,
%
% s_r{shot #, 1}(1,2) is sx
% s_r{shot #, 2}(end,1) is rx
veloci_lin = zeros(ns,numel(parame_.x));
for is=1:ns
 is_ = source_no(is);
 ix_ = s_r_{is_, 1}(1,2);
 ix__= s_r_{is_, 2}(end,1);
 veloci_lin(is, ix_:ix__) = v_lin(is);
end
% n_overlap = max(sum(veloci_lin~=0,1));
for i_overlap=1:n_overlap
 % left
 ix_ = s_r_{i_overlap, 1}(1,2);
 veloci_lin(i_overlap,1:(ix_-1)) = v_lin(1);
 % right
 ix__= s_r_{ns-(i_overlap-1), 2}(end,1);
 veloci_lin(ns-(i_overlap-1),(ix__+1):end) = v_lin(end);
end
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(veloci_lin,parame_.x,source_no)
colormap(rainbow())
axis square
xlabel('Length of Domain (m)')
ylabel('Shot #')
title('Velocity (m/ns)')
simple_figure()
% ------------------------------------------------------------------------------
veloci_lin = sum(veloci_lin,1)/n_overlap;
% ------------------------------------------------------------------------------
figure;
plot(parame_.x,veloci_lin,'k.-','markersize',25)
axis tight
xlabel('Length of Domain (m)')
ylabel('Velocity (m/ns)')
title('Average of Linear Velocities')
simple_figure()
% ------------------------------------------------------------------------------
vel_ini = zeros(numel(parame_.z),numel(parame_.x));
iz = binning(parame_.z,z_depth);
vel_ini(1:iz,:) = repmat(veloci_lin,iz,1);
vel_ini((iz+1):end,:) = v_hyper;
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(vel_ini,parame_.x,parame_.z);
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Velocity (m/ns)')
simple_figure()

epsi = (c./vel_ini).^2;

figure;
fancy_imagesc(epsi,parame_.x,parame_.z);
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Permittivity ( )')
simple_figure()
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save this permittivity? (y/n)  ';
save_ = input(prompt,'s');
if strcmp(save_,'y')
  save('epsi_linear','epsi');
  fprintf('\n    ok, permittivity is saved now.\n\n')
else
  fprintf('\n    ok, permittivity is not saved.\n\n')
end
% ------------------------------------------------------------------------------

