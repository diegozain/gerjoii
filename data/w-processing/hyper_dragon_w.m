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
% groningen2
% overlap of shots
n_overlap = 3;
t_mute = 33.5;   % ns
v_mute = c;   % m/ns
% times for linear semblance
t_lin_ = 28; % ns
t_lin__= 45; % ns
% times for hyperbolic semblance (considering time-shifted time)
t_hyp_ = 24; % ns
t_hyp__= 40; % ns
% ------------------------------------------------------------------------------
% % bhrs (not working)
% % overlap of shots
% n_overlap = 3;
% t_mute = 103;   % ns
% v_mute = c;   % m/ns
% % times for linear semblance
% t_lin_ = 160; % ns
% t_lin__= 340; % ns
% % times for hyperbolic semblance (considering time-shifted time)
% t_hyp_ = 125; % ns
% t_hyp__= 175; % ns
% ------------------------------------------------------------------------------
% mute air arrival
c = 0.299792458; % m/ns
v_mute = c;   % m/ns
% choose velocities for linear semblance
% (velocity of water 0.03m/ns, rel perm~80)
v__ = 0.23; % [m/ns]
v_  = 0.072; % [m/ns] 
dv = (v__-v_)*0.01;
v = v_ : dv : v__;

% choose velocities for hyperbolic semblance
% (velocity of water 0.03m/ns, rel perm~80)
v__ = 0.23; % [m/ns]
v_  = 0.05; % [m/ns] 
dv = (v__-v_)*0.01;
v_hyper = v_ : dv : v__;
% ------------------------------------------------------------------------------
source_no = (iline_:iline__); 
ns = numel(source_no);

v_lin = zeros(ns,1);
v_hyp = zeros(ns,1);
t_hyp = zeros(ns,1);

V_HYP = [];
V_LIN = [];
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
 t_fa = radargram.t_fa;
 v_fa = radargram.v_fa;
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
 % -----------------------------------------------------------------------------
 % linear semblance
 % -----------------------------------------------------------------------------
 v_analy = v_linear(angle(hilbert(d)),t,rx,v);
 
 % figure;
 % fancy_imagesc(v_analy,v,t)
 % axis normal
 % colormap(rainbow())
 
 ito = binning(t,t_lin_);
 ito_= binning(t,t_lin__);
 v_analy= v_analy(ito:ito_,:);
 
 V_LIN = [V_LIN v_analy];
 T_LIN = t(ito:ito_);
 
 % get linear velocities
 [v_analy,~] = max(v_analy);
 [~,v_analy] = max(v_analy);
 v_analy = v(v_analy);
 v_lin(is) = v_analy;
 % -----------------------------------------------------------------------------
 %  hyperbolic semblance
 % -----------------------------------------------------------------------------
 % correct for time zero for hyper
 [d,t_shift,t_sr] = w_timeshift(d,t,v_fa,dsr,t_fa);
 % hyperbolic semblance
 v_analy= v_hyperbolic(angle(hilbert(d)),t_shift,rx,dsr,v_hyper,0);
 
 % figure;
 % fancy_imagesc(v_analy,v_hyper,t_shift)
 % axis normal
 % colormap(rainbow())
 
 ito = binning(t_shift,t_hyp_);
 ito_= binning(t_shift,t_hyp__);
 v_analy= v_analy(ito:ito_,:);
 
 V_HYP = [V_HYP v_analy];
 T_HYP = t_shift(ito:ito_);
 
 [nv_r,nv_c] = size(v_analy);
 % get max in both to and velocity
 [~,v_analy] = max(v_analy(:));
 [to,v_analy] = ind2sub([nv_r,nv_c],v_analy);
 to = t_shift(to+ito-1);
 v_analy = v_hyper(v_analy);
 v_hyp(is) = v_analy;
 t_hyp(is) = to;
 
 fprintf('  done with line %i\n',is_);
end
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(V_LIN,source_no,T_LIN)
axis normal
simple_figure()
colormap(rainbow())
xlabel('Shot #')
ylabel('Time (ns)')
title('Linear Velocity Semblance')

figure;
fancy_imagesc(V_HYP,source_no,T_HYP)
axis normal
simple_figure()
colormap(rainbow())
xlabel('Shot #')
ylabel('Time Zero (ns)')
title('Hyperbolic Velocity Semblance')
clear V_HYP T_HYP V_LIN T_LIN
% ------------------------------------------------------------------------------
% smooth out
windo = 10; % 10;
v_lin = window_mean(v_lin,windo);
v_hyp = window_mean(v_hyp,windo);
t_hyp = window_mean(t_hyp,windo);
% ------------------------------------------------------------------------------
% get depth
z_depth = v_lin.*sqrt( (t_hyp./2).^2 - (dsr./(2*v_lin)).^2  );
% ------------------------------------------------------------------------------
figure;
hold on
plot(source_no,v_lin,'k.-','markersize',25)
plot(source_no,v_hyp,'r.-','markersize',25)
hold off
axis tight
legend({'Linear','Hyperbolic'})
xlabel('Shot #')
ylabel('Velocity (m/ns)')
title('Velocities per Shot')
simple_figure()

figure;
plot(source_no,z_depth,'k.-','markersize',25)
axis tight
axis ij
xlabel('Shot #')
ylabel('Depth to Second Layer (m)')
title('Depths per Shot')
simple_figure()

% ------------------------------------------------------------------------------
load(strcat('../raw/',project_,'/w-data/data-mat-fwi/parame_.mat'));
load(strcat('../raw/',project_,'/w-data/data-mat-fwi/s_r_.mat'));
% ------------------------------------------------------------------------------
% now we need to put these found values in the big fwi domain.
% this step is sort of an interpolation.
% --

% s_r is a cell where,
%
% s_r{shot #, 1}(1,2) is sx
% s_r{shot #, 2}(end,1) is rx
veloci_lin = zeros(ns,numel(parame_.x));
veloci_hyp = zeros(ns,numel(parame_.x));
depths_hyp = zeros(ns,numel(parame_.x));
for is=1:ns
 is_ = source_no(is);
 ix_ = s_r_{is_, 1}(1,2);
 ix__= s_r_{is_, 2}(end,1);
 veloci_lin(is, ix_:ix__) = v_lin(is);
 veloci_hyp(is, ix_:ix__) = v_hyp(is);
 depths_hyp(is, ix_:ix__) = z_depth(is);
end
% n_overlap = max(sum(veloci_lin~=0,1));
for i_overlap=1:n_overlap
 % left
 ix_ = s_r_{i_overlap, 1}(1,2);
 veloci_lin(i_overlap,1:(ix_-1)) = v_lin(1);
 veloci_hyp(i_overlap,1:(ix_-1)) = v_hyp(1);
 depths_hyp(i_overlap,1:(ix_-1)) = z_depth(1);
 % right
 ix__= s_r_{ns-(i_overlap-1), 2}(end,1);
 veloci_lin(ns-(i_overlap-1),(ix__+1):end) = v_lin(end);
 veloci_hyp(ns-(i_overlap-1),(ix__+1):end) = v_hyp(end);
 depths_hyp(ns-(i_overlap-1),(ix__+1):end) = z_depth(end);
end
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(veloci_lin,parame_.x,source_no)
colormap(rainbow())
axis square
xlabel('Length of Domain (m)')
ylabel('Shot #')
title('Linear Velocity (m/ns)')
simple_figure()
% ------------------------------------------------------------------------------
veloci_lin = sum(veloci_lin,1)/n_overlap;
veloci_hyp = sum(veloci_hyp,1)/n_overlap;
depths_hyp = sum(depths_hyp,1)/n_overlap;
% ------------------------------------------------------------------------------
% smooth out
windo = 100;
veloci_lin = window_mean(veloci_lin.',windo);
veloci_hyp = window_mean(veloci_hyp.',windo);
depths_hyp = window_mean(depths_hyp.',windo);
% ------------------------------------------------------------------------------
figure;
hold on
plot(parame_.x,veloci_lin,'k.-','markersize',25)
plot(parame_.x,veloci_hyp,'r.-','markersize',25)
plot(parame_.x,2*veloci_hyp-veloci_lin,'b.-','markersize',25)
plot(parame_.x,mean((veloci_hyp+veloci_lin)*0.5)*ones(size(parame_.x)),'b--')
hold off
axis tight
legend({'Linear','Hyperbolic','Dix second layer','Average of Dix'})
xlabel('Length of Domain (m)')
ylabel('Velocity (m/ns)')
title('Average of Velocities')
simple_figure()

figure;
plot(parame_.x,depths_hyp,'k.-','markersize',25)
axis tight
axis ij
xlabel('Length of Domain (m)')
ylabel('Depth to Second Layer (m)')
title('Average of Depths')
simple_figure()
% ------------------------------------------------------------------------------
% build final velocity model from linear and hyperbolic velocities
%
vel_ini = zeros(numel(parame_.z),numel(parame_.x));
vel_1layer = 0.5*(veloci_lin + veloci_hyp);
vel_2layer = mean(2*veloci_hyp-veloci_lin);

for ix=1:numel(parame_.x)
 iz = binning(parame_.z,depths_hyp(ix));
 vel_ini(1:iz,ix) = vel_1layer(ix);%0.5*(veloci_lin(ix) + veloci_hyp(ix));
 vel_ini((iz+1):end,ix) = vel_2layer;%veloci_hyp(ix);
end
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
  save('epsi_2l','epsi');
  fprintf('\n    ok, permittivity is saved now.\n\n')
else
  fprintf('\n    ok, permittivity is not saved.\n\n')
end
% ------------------------------------------------------------------------------
