%%{
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
% choose array name (from their data set)
% C_26_78
% C_45_135
% C_78_405
array_name = 'C_78_405';
% from grenoble_see.m,
% array   |  nt
% -------------
% C_26_78  978000
% C_45_135 1146000
% C_78_405 1440000 
if strcmp(array_name,'C_26_78')
  nt=978000;
elseif strcmp(array_name,'C_45_135')
  nt=1146000;
elseif strcmp(array_name,'C_78_405')
  nt=1440000;
end
% radial or normal
what_way = 'radial';
% ------------------------------------------------------------------------------
% dir to load 
data_path_=strcat('data-mat/',array_name,'/');
if exist(data_path_) ~= 7
  fprintf('\n\nidiot, you havent grenoble2gerjoii-ed that one\n');
end
% ------------------------------------------------------------------------------
% load geometry for this array
load(strcat(data_path_,'geome','_',array_name,'.mat'));
% get its info
locs=geome.locs;
names=geome.names;
nstat=size(locs,1);
% print funny stuff so user is amused
fprintf('\n I am roboto-matlab, hi.\n\n');
fprintf('\n   ---------------------\n')
fprintf('\n   array name:     %s ',array_name);
fprintf('\n   # of stations:  %i',nstat)
fprintf('\n   gonna do the:   %s way\n',what_way)
fprintf('\n   ---------------------\n\n')
% ------------------------------------------------------------------------------
% get data from all stations and put it in d,
% d is of size (time by components by stations)
d = zeros(nt,3,nstat);
% loop over stations
fprintf('   loading: \n');
for j_ = 1:nstat
  % station
  station_name = names(j_);
  station_name = char(station_name);
  load(strcat(data_path_,station_name,'.mat'));
  % bundle data for that station
  d_enz = ambient.d_enz;
  dt = ambient.dt;
  d(:,:,j_) = d_enz;
  fprintf('       station # %i\n',j_);
end
fprintf('\n',j_);
clear ambient d_enz j_ station_name;
% ------------------------------------------------------------------------------
% filter data
% bandpass
f_low = 0.6; % 2 [Hz]
f_high = 20; % [Hz]
nbutter = 10;
for icomp=1:3
  d(:,icomp,:) = filt_gauss(squeeze(d(:,icomp,:)),dt,f_low,f_high,nbutter);
end
% % ------------------------------------------------------------------------------
% % whiten spectra:
% %   bring data to frequency domain
% %   average
% %   divide
% %   take back to time domain
% % --
% % windows to take the window mean
% c_f = 1; % [Hz]
% c_t = 5; % [s]
% c_f = fix(c_f / (1/dt/size(d,1))); 
% c_t = fix(c_t / dt);
% % --
% % design time chunks so my laptop doesn't die from ram space
% dch = 120; % [s]
% dch = floor(dch/dt);
% chs = (0:dch:nt)+mod(nt,dch);
% nchs = numel(chs);
% for ich=1:(nchs-1)
%   for icomp=1:3
%     % --
%     d_ = fft(squeeze(d( (chs(ich)+1):chs(ich+1) ,icomp,:)),[],1);
%     % windowed mean via conv gives artifacts near the edges, so 
%     % let those artifacts be in the high rather than low freqs,
%     d_ = fftshift(d_,1);
%     d_meaned = window_mean(abs(d_),c_f);
%     d_ = d_ ./ d_meaned;
%     d_ = fftshift(d_,1);
%     d_ = real(ifft(d_,[],1));
%     % nt_=2^nextpow2(nt);
%     % nt_extra = nt_-nt;
%     % d_ = d_(1:end-nt_extra, : );
%     % --
%     d_meaned = window_mean(abs(d_),c_t);
%     d_ = d_ ./ d_meaned;
%     % --
%     d(  (chs(ich)+1):chs(ich+1)  ,icomp,:) = d_;
%   end
%   if mod(20,ich)==0
%     fprintf('\n chunk # %i',ich);
%   end
% end
% % ------------------------------------------------------------------------------
% % something weird happens in the beginnig and ending of the data
% d=d(10:(nt-10),:,:);
% nt=size(d,1);
% ------------------------------------------------------------------------------
% window the data to get 'sources' all around the virtual source and receivers
t=0:(nt-1); t=t.'*dt;
T = t(end)/60/60; % total time in [hours]
% T_=5; % cut-off time in [seconds]
if strcmp(array_name,'C_26_78')
  T_=10;
elseif strcmp(array_name,'C_45_135')
  T_=10;
elseif strcmp(array_name,'C_78_405')
  T_=60;
end
% make d a matrix (time by components by receivers by time-windows)
d = window_denz(d,T_,dt);
fprintf('\n\n total time in hours is: %2.2d',T);
fprintf('\n window time in seconds is: %2.2d\n',T_);
% ------------------------------------------------------------------------------
% simple interferometry
if strcmp(array_name,'C_26_78')
  a=8;
  recs=1;
elseif strcmp(array_name,'C_45_135')
  a=15;
  recs=1;
elseif strcmp(array_name,'C_78_405')
  a=10;
  recs=1;
end
fprintf('\n virtual source is station # %i\n',a);
fprintf(' virtual receiver is station # %i\n',recs);
stats = [recs a];
Bs = squeeze(d(:,:,stats,:));
a=numel(stats);
if strcmp(what_way,'normal')
  % normal way
  [Ba, t_corr] = ifm_xcorr_comp(Bs,a,dt);
elseif strcmp(what_way,'radial')
  % radial way
  locs_ = locs(stats,:);
  vs_loc = locs_(end,:).';
  vr_loc = ( geom_median(locs_(1:(end-1),:),[1,1]) ).';
  [Ba, t_corr] = ifm_xcorr_radial_(Bs,a,dt,vs_loc,vr_loc);
end
% % figure; plot(t_corr,Ba(:,1,1)); axis tight
% % causal - acausal
% it_o = (numel(t_corr)+1)/2;
% t_corr = t_corr(it_o:end);
% Ba_causal = Ba(it_o:end,:,:);
% Ba_acausal = Ba(1:it_o,:,:);
% Ba_acausal = flip(Ba_acausal,1);
% Ba = 0.5*(Ba_causal + Ba_acausal);
% ------------------------------------------------------------------------------
% filter
for icomp=1:3
  Ba(:,icomp,:) = filt_gauss(squeeze(Ba(:,icomp,:)),...
  dt,f_low,f_high,nbutter);
end
% ------------------------------------------------------------------------------
% store virtual gather of receiver (c). this is the data now.
b = squeeze(Ba(:,:,2)); % virt src
c = squeeze(Ba(:,:,1)); % virt rec
bz = b(:,3);
cz = c(:,3);
bn = b(:,2);
cn = c(:,2);
be = b(:,1);
ce = c(:,1);
clear Ba;
% ------------------------------------------------------------------------------
% see
figure('Position',[709 85 560 620]);
subplot(4,1,1)
plot(t_corr,c);
legend({'E','N','Z'})
axis tight
set(gca,'XTick',[])
set(gca,'YTick',[])
title('Wavefield at center station (vr)')
simple_figure()
subplot(4,1,2)
hold on
plot(t_corr, be/max(abs(be)) );
plot(t_corr, ce/max(abs(be)) );
hold off
legend({'vs','vr'})
axis tight
set(gca,'XTick',[])
set(gca,'YTick',[])
title('Waveform E')
simple_figure()
subplot(4,1,3)
hold on
plot(t_corr, bn/max(abs(bn)) );
plot(t_corr, cn/max(abs(bn)) );
hold off
legend({'vs','vr'})
axis tight
set(gca,'XTick',[])
set(gca,'YTick',[])
title('Waveform N')
simple_figure()
subplot(4,1,4)
hold on
plot(t_corr, bz/max(abs(bz)) );
plot(t_corr, cz/max(abs(bz)) );
hold off
legend({'vs','vr'})
axis tight
xlabel('Time (s)')
set(gca,'YTick',[])
title('Waveform Z')
simple_figure()
% ------------------------------------------------------------------------------
%}
% do FTAN on (c).
f_min = 0.6;  % [Hz] 25 2 10
f_max = 25; % [Hz] 80 12 80
v_min = 10; % [m/s] 10
v_max = 500; % [m/s] 60
% make velocity and frequency vectors
f=logspace(log10(f_min),log10(f_max),100); % [Hz] frequencies to scan over
v=logspace(log10(v_min),log10(v_max),100); % [m/s] velocities to consider
% choose width of gaussian ftan filter
alph = 50;
% distance from source to receiver [m]
% dsr = norm( locs(recs(1),:)-locs(recs(2),:) );
dsr = norm( locs(stats(1),:)-locs(stats(2),:) );  
% ftan this guy
disp_vf = zeros(numel(v),numel(f),3);
disp_ft = zeros(numel(f),numel(t_corr),3);
for i_=1:3
  [disper_g_vf, disper_g_ft, dro_snr] = ftan(c(:,i_),dt,f,v,alph,dsr);
  disp_vf(:,:,i_) = normali(disper_g_vf);
  disp_ft(:,:,i_) = normali(disper_g_ft);
end
disp_vf = sum(disp_vf,3);
disp_ft = sum(disp_ft,3);
disp_vf = disp_vf/max(abs(disp_vf(:)));
disp_ft = abs(disp_ft); 
disp_ft = normali(disp_ft);
% Plot ftan image
figure('Position',[423 127 612 578]);
subplot(2,1,1)
% imagesc(t_corr, f,disp_ft); axis xy;
h=pcolor(f,t_corr,disp_ft.');
h.EdgeColor='none';
colormap(rainbow());
axis square;
colorbar('off')
ylabel('Time (s)'); 
set(gca,'XTick',[])
title('Dispersion measure')
subplot(2,1,2)
% imagesc(v, f,disp_vf.'); axis xy;
h=pcolor(f,v,disp_vf);
h.EdgeColor='none';
colormap(rainbow2(1));
axis square;
colorbar('off')
xlabel('Frequency (Hz)'); 
ylabel('Group velocity (m/s)');
simple_figure()
% --
cc=colorbar;
cc.TickLength = 0;
% [left, bottom, width, height]
cc.Location = 'eastoutside';
h=get(subplot(2,1,1),'Position');
cc.Position = [h(3)*0.9,h(4)*1,0.02,0.31];
cc.Label.FontSize = 20;
% xlabel(cc,'semblance')
% --
simple_figure()

figure;
h=pcolor(f,v,disp_vf);
h.EdgeColor='none';
colormap(rainbow2(1));
axis square;
colorbar('off')
xlabel('Frequency (Hz)'); 
ylabel('Group velocity (m/s)');
cc=colorbar;
cc.TickLength = 0;
% [left, bottom, width, height]
cc.Location = 'eastoutside';
simple_figure()


fprintf('\n\n... ok bye. \n\n')