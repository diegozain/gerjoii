% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
% choose array name (from their data set)
% C_26_78
% C_45_135
% C_78_405
array_name = 'C_45_135';
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
what_way = 'normal';
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
f_low = 0.6; % [Hz]
f_high = 20;  % [Hz]
nbutter = 10;
for icomp=1:3
  d(:,icomp,:) = filt_gauss(squeeze(d(:,icomp,:)),dt,f_low,f_high,nbutter);
end
% ------------------------------------------------------------------------------
% window the data to get 'sources' all around the virtual source and receivers
t=0:(nt-1); t=t.'*dt;
T = t(end)/60/60; % total time in [hours]
% T_=5; % cut-off time in [seconds]
if strcmp(array_name,'C_26_78')
  T_=5;
elseif strcmp(array_name,'C_45_135')
  T_=2.5;
elseif strcmp(array_name,'C_78_405')
  T_=10;
end
% make d a matrix (time by components by receivers by time-windows)
d = window_denz(d,T_,dt);
fprintf('\n total time in hours is: %2.2d',T);
fprintf('\n window time in seconds is: %2.2d\n',T_);
% ------------------------------------------------------------------------------
% choose virtual receivers (b and c)
% recs = [b c]
if strcmp(array_name,'C_26_78')
  recs = [1 8];
  a_ = [2 4 10 11 12 13 15];
elseif strcmp(array_name,'C_45_135')
  recs = [1 15];
  a_ = [2 8 9 10 11 12 13];
elseif strcmp(array_name,'C_78_405')
  recs = [1 10];
  a_ = [3 5 6 7 8 9 10 15];
end
% recs = [1 8];
% recs = [1 15];
% recs = [1 10];
% virtual src list
% a_ = [2 4 10 11 12 13 15];
% a_ = [2 8 9 10 11 12 13];
% a_ = [3 5 6 7 8 9 10 15];
% for loop over virtual sources
% ------------------------------------------------------------------------------
nt_=size(d,1);
% xcorr time interval
t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];
Ba_ = zeros(numel(t_corr),3,numel(recs)+1,numel(a_));
for ivs = 1:numel(a_)
  % choose virtual source (a)
  a = a_(ivs);
  fprintf('\n virtual source is station # %i',a);
  % thin d to only these stations
  stats = [recs a];
  Bs = squeeze(d(:,:,stats,:));
  locs_ = locs(stats,:);
  % rename source to new station index arrangement
  a = numel(stats);
  % ----------------------------------------------------------------------------
  if strcmp(what_way,'normal')
    % normal way
    [Ba, t_corr] = ifm_xcorr_comp(Bs,a,dt);
    % --------------------------------------------------------------------------
  elseif strcmp(what_way,'radial')
    % radial way
    vs_loc = locs_(end,:).';
    vr_loc = ( geom_median(locs_(1:(end-1),:),[1,1]) ).';
    [Ba, t_corr] = ifm_xcorr_radial_(Bs,a,dt,vs_loc,vr_loc);
  end
  % ----------------------------------------------------------------------------
  % store all virtual sources to the common receivers, this is the data now.
  Ba_(:,:,:,ivs) = Ba;
end
clear d Ba;
% remove virtual source (it contains all different virt.srcs)
Ba_(:,:,end,:)=[];
% ------------------------------------------------------------------------------
% Ba_ is a matrix of size (time by components by receivers by sources)
% # of time samples = numel(t_corr) 
% # of components = 3
% # of receivers = numel(recs)
% # of sources = numel(a_)
% ------------------------------------------------------------------------------
% causal - acausal
% correlation time t is 2t-1,
% so causal time is
it_o = (numel(t_corr)+1)/2;
t_causal = t_corr(it_o:end);
% causal - acausal
Ba_causal = Ba_(it_o:end,:,:,:);
Ba_acausal = Ba_(1:it_o,:,:,:);
Ba_acausal = flip(Ba_acausal,1);
Ba = 0.5*(Ba_causal + Ba_acausal);
clear Ba_ Ba_causal Ba_acausal;
% ------------------------------------------------------------------------------
% filter data
for ivs=1:size(Ba,4)
  for icomp=1:3
    Ba(:,icomp,:,ivs) = filt_gauss(squeeze(Ba(:,icomp,:,ivs)),...
    dt,f_low,f_high,nbutter);
  end
end
% ------------------------------------------------------------------------------
% set virtual receiver and virtual source  (b and c)
stats = recs;
locs_ = locs(stats,:);
% station to be virtual source is in index #2 in Ba,
a = 2;
% for loop over virtual sources previously computed
% ------------------------------------------------------------------------------
if strcmp(what_way,'normal')
  % normal way
  [Ba, t_corr] = ifm_xcorr_comp(Ba,a,dt);
  % ----------------------------------------------------------------------------
  % radial way
  elseif strcmp(what_way,'radial')
  vs_loc = locs_(2,:).';
  vr_loc = locs_(1,:).';
  [Ba, t_corr] = ifm_xcorr_radial_(Ba,a,dt,vs_loc,vr_loc);
end
% ------------------------------------------------------------------------------
% Ba is a matrix of size (time by components by stations)
% # of time samples = numel(t_corr) 
% # of components = 3
% # of stations = numel(recs) + 1, (the virtual source is included)
% ------------------------------------------------------------------------------
% causal - acausal
% correlation time t is 2t-1,
% so causal time is
it_o = (numel(t_corr)+1)/2;
t_corr = t_corr(it_o:end);
% causal - acausal
Ba_causal = Ba(it_o:end,:,:);
Ba_acausal = Ba(1:it_o,:,:);
Ba_acausal = flip(Ba_acausal,1);
Ba = 0.5*(Ba_causal + Ba_acausal);
clear Ba_causal Ba_acausal;
% ------------------------------------------------------------------------------
% filter data
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
title('Wavefield at center station (vvr)')
simple_figure()
subplot(4,1,2)
hold on
plot(t_corr, be/max(abs(be)) );
plot(t_corr, ce/max(abs(be)) );
hold off
legend({'vvs','vvr'})
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
legend({'vvs','vvr'})
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
legend({'vvs','vvr'})
axis tight
xlabel('Time (s)')
set(gca,'YTick',[])
title('Waveform Z')
simple_figure()
% ------------------------------------------------------------------------------
% do FTAN on (c).
f_min = 2;  % [Hz] 25 2 10
f_max = 30; % [Hz] 80 12 80
v_min = 35; % [m/s] 10
v_max = 1500; % [m/s] 60
% make velocity and frequency vectors
f=logspace(log10(f_min),log10(f_max),100); % [Hz] frequencies to scan over
v=logspace(log10(v_min),log10(v_max),100); % [m/s] velocities to consider
% choose width of gaussian ftan filter
alph = 10;
% distance from source to receiver [m]
% dsr = norm( locs(recs(1),:)-locs(recs(2),:) );
dsr = norm( locs(stats(1),:)-locs(stats(2),:) );  
% ftan this guy
disp_vf = zeros(numel(v),numel(f),3);
disp_ft = zeros(numel(f),numel(t_corr),3);
for i_=1:3
  [disper_g_vf, disper_g_ft, dro_snr] = ftan(c(:,i_),dt,f,v,alph,dsr); 
  disp_vf(:,:,i_) = disper_g_vf/max(abs(disper_g_vf(:)));
  disp_ft(:,:,i_) = disper_g_ft/max(abs(disper_g_ft(:)));
end
disp_vf = sum(disp_vf,3);
disp_ft = sum(disp_ft,3);
disp_vf = disp_vf/max(abs(disp_vf(:)));
disp_ft = abs(disp_ft); disp_ft = disp_ft/max(abs(disp_ft(:)));
% Plot ftan image
figure('Position',[423 127 612 578]);
subplot(2,1,1)
% imagesc(t_corr, f,disp_ft); axis xy;
h=pcolor(f,t_corr,disp_ft.');
h.EdgeColor='none';
colormap(rainbow2(1));
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