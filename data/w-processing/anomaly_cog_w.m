% ------------------------------------------------------------------------------
%
% apply preprocessing and 
% image in time with gain-bandpass 
% a gpr radargram.
%
% ------------------------------------------------------------------------------
close all
clear all
clc
addpath('read-data');
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will process your COGs to find graves.')
fprintf('\n --------------------------------------------------------\n\n')
fprintf('you have to run this after ss2gerjoii2_cog_w.m!!\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_name = input(prompt,'s');
data_path_ = strcat('../raw/',project_name,'/w-data/data-mat/');
% ------------------------------------------------------------------------------
ls(data_path_);
prompt = '    tell me cog-rs-# or cog-sr-#, eg rs-:  ';
cog_ = input(prompt,'s');
prompt = '    tell me 1st# of interval of lines you want, eg: if 2:8 write 2: ';
iline_ = input(prompt,'s'); 
iline_=str2double(iline_);
prompt = '    tell me 2nd# of interval of lines you want, eg: if 2:8 write 8: ';
iline__ = input(prompt,'s'); 
iline__=str2double(iline__);
% ------------------------------------------------------------------------------
cog_no = (iline_:iline__); 
ncog = numel(cog_no);
fprintf('\n    # of lines = %i\n\n',ncog)
% ------------------------------------------------------------------------------
% bandpass. [GHz]
f_low = 0.05;
f_high = 0.3;
% fk-filter. [1/m] & [1/ns]
ar = 10;
at = 25;
% first arrival time shift & velocity. [ns] & [m/ns]
t_fa = 16;%20;
v_fa = 0.2998;
% svd filter 
cut_off = 2;
% odometer off_ and off__
off_ = 1116.6;
off__= 982.2;
scale_ = off__ / off_;
% cut-off time AFTER time shift
t_cut = 70;%50; % ns
% ------------------------------------------------------------------------------
% energy of size ncog by nrx
EE = cell(ncog,1);
Rx = cell(ncog,1);
% ------------------------------------------------------------------------------
rx_max = -Inf;
rx_min = Inf;
dx_min = Inf;
% ------------------------------------------------------------------------------
% figure;hold on
% ------------------------------------------------------------------------------
for icog=1:ncog;
  data_name_ = strcat('cog-',cog_,num2str(cog_no(icog)));
  % ----------------------------------------------------------------------------
  load(strcat(data_path_,data_name_,'.mat'));
  d  = radargram.d;
  t  = radargram.t; %          [ns]
  dt = radargram.dt; %        [ns]
  fo = radargram.fo; %        [GHz]
  r  = radargram.r; %          [m] x [m]
  dr = radargram.dr; %        [m]
  dsr= radargram.dsr; %      [m]rx=s_r{is,2}(:,1);
  fny= 1/dt/2;
  nt = numel(t);
  rx = r(:,1);
  nr = numel(rx);
  % ----------------------------------------------------------------------------
  %   remove wow
  % ----------------------------------------------------------------------------
  % remove wow
  d = dewow(d,dt,fo);
  % background trace
  bg_trace = sum(d,2)/size(d,2);
  % remove back-ground trace
  for r_=1:size(d,2)
    d(:,r_) = d(:,r_) - bg_trace;
  end
  % ----------------------------------------------------------------------------
  %   fourier
  % ----------------------------------------------------------------------------
  % taper edges to zero
  % before fourier
  for i=1:nr
    d(:,i) = d(:,i) .* tukeywin(nt,0.1);
  end
  % ----------------------------------------------------------------------------
  %   cook raw data. for "interpretation"
  % ----------------------------------------------------------------------------
  % -------
  % filter
  d = filt_gauss(d,dt,f_low,f_high,10);
  % -------
  d_max=max(d);
  d = d./repmat(d_max,[nt,1]);
  % fk domain and filter.
  % smaller # -> bigger smudge
  ar_ = ar*dr;   % # is in [1/m] . 13 3
  at_ = at*dt;  % # is in [1/ns]
  [d, d_fk, fkfilter] = image_gaussian(d,ar_,at_,'LOW_PASS');
  % ----------------------------------------------------------------------------
  % time shift
  % ----------------------------------------------------------------------------
  [d,t,t_sr] = w_timeshift(d,t,v_fa,dsr,t_fa);
  % ----------------------------------------------------------------------------
  %   svd filter
  % ----------------------------------------------------------------------------
  [nt,nr]=size(d);
  [V,E,Q]=svd(d);
  E(1:cut_off,1:nr)=zeros(cut_off,nr);
  d = V*E*Q';
  d = d./repmat(max(d),[nt,1]);
  % ----------------------------------------------------------------------------
  % remove early times
  % ----------------------------------------------------------------------------
  d = d(binning(t,t_cut):end,:);
  % ----------------------------------------------------------------------------
  % energy
  % ----------------------------------------------------------------------------
  d = sum(d.^2);
  % ----------------------------------------------------------------------------
  % meaner = 5;
  % meaner = ones(meaner,1)/meaner;
  % d = conv(d,meaner,'same');
  % d = d/max(abs( d ));
  % ----------------------------------------------------------------------------
  % d = d-mean(d);
  % ----------------------------------------------------------------------------
  % % fix odometer wheel ¬_¬
  % rx = rx * scale_;
  % ----------------------------------------------------------------------------
  rx_max = max([rx;rx_max]);
  rx_min = min([rx;rx_min]);
  dx_min = min( [diff(rx);dx_min] );
  % ----------------------------------------------------------------------------
  fprintf('just did cog #%i\n',cog_no(icog))
  EE{icog} = d;
  Rx{icog} = rx;
  % ----------------------------------------------------------------------------
  % plot(rx,icog*ones(size(rx)),'.')
  % ----------------------------------------------------------------------------
end
% ------------------------------------------------------------------------------
figure;
hold on
for icog=1:ncog
% plot(cog_no(icog)*ones(size(Rx{icog},1),1),Rx{icog},'k-')
plot(Rx{icog},cog_no(icog)*ones(size(Rx{icog},1),1),'k-')
end
hold off
axis ij
title('Survey lines')
simple_figure()
% ------------------------------------------------------------------------------
rx_ = rx_min:dx_min:rx_max;
E = zeros(ncog,numel(rx_));
% ------------------------------------------------------------------------------
for icog=1:ncog
  d = EE{icog};
  rx= Rx{icog};
  % E(icog,:) = spline(rx,d,rx_);
  E(icog,:) = interp1(rx,d,rx_);
end
% ------------------------------------------------------------------------------
E = E - min(E(:));
E = normali(E);
% ------------------------------------------------------------------------------
energy = struct;
energy.E = E;
energy.rx= rx_;
% ------------------------------------------------------------------------------
% lines for idaho-peni: 22-34
energy.v_h = 'h';
save('energy_h','energy')
%
figure;
fancy_imagesc(E,rx_,cog_no); % hori
axis square
colormap(bone)
colorbar('off')
xlabel('Road (m)')
ylabel('Hill - Line #')
simple_figure()
% ------------------------------------------------------------------------------
% % lines for idaho-peni: 00-21
% energy.v_h = 'v';
% save('energy_v','energy')
% %
% figure;
% fancy_imagesc(E.',cog_no,rx_); % verti
% axis square
% colormap(bone)
% colorbar('off')
% xlabel('Road - Line #')
% ylabel('Hill (m)')
% simple_figure()
% ------------------------------------------------------------------------------
