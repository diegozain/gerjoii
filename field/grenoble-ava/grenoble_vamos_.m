%%{
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
% arrays
array_names = {'C_26_78' , 'C_45_135' , 'C_78_405'};
narray = numel(array_names);
% ------------------------------------------------------------------------------
% FTAN parameters
f_min = 0.6;  % [Hz] 25 2 10
f_max = 25; % [Hz] 80 12 80
v_min = 10; % [m/s] 10
v_max = 500; % [m/s] 60
% make velocity and frequency vectors
% f=logspace(log10(f_min),log10(f_max),100); % [Hz] frequencies to scan over
% v=logspace(log10(v_min),log10(v_max),100); % [m/s] velocities to consider
f=linspace(f_min,f_max,100); % [Hz] frequencies to scan over
v=linspace(v_min,v_max,100); % [m/s] velocities to consider
nf=numel(f);
nv=numel(v);
df=f(2)-f(1);
% choose width of gaussian ftan filter
alph = 50;
% master stack
disp_vf_ = zeros(nv,nf);
% ------------------------------------------------------------------------------
for i_=1:narray
% choose array name (from their data set)
% C_26_78
% C_45_135
% C_78_405
array_name = array_names{i_};
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
  T_=10;
elseif strcmp(array_name,'C_45_135')
  T_=10;
elseif strcmp(array_name,'C_78_405')
  T_=60;
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
% do FTAN on (c).
% distance from source to receiver [m]
% dsr = norm( locs(recs(1),:)-locs(recs(2),:) );
dsr = norm( locs(stats(1),:)-locs(stats(2),:) );  
% ftan this guy
disp_vf = zeros(numel(v),numel(f),3);
for i_=1:3
  disper_g_vf = ftan(c(:,i_),dt,f,v,alph,dsr); 
  disp_vf(:,:,i_) = disper_g_vf/max(abs(disper_g_vf(:)));
end
disp_vf = sum(disp_vf,3);
disp_vf = normali(disp_vf);
% ----------------------------------------------------------------------------
% stack
disp_vf_ = disp_vf_ + disp_vf;
fprintf('\n\n... ok bye. \n\n')
end
disp_vf_ = normali(disp_vf_);
% ------------------------------------------------------------------------------
%}
% group velocity curve
vg = max_mat(disp_vf_,f,v);
vg = vg(:,1);
% take to radians
% spline( x, y(x), new x ) = new y( new x )
vp = spline( f, vg , 2*pi*f );
% window mean
% vg = window_mean(vg,15);
vp = vg;
% change to slowness
vp = 1./vp;
% integrate to get phase velocity
wo=2*pi*f_min; % [rad/s]
spo=1/3e+2; % [s/m]
dw = 2*pi*df;
w = 2*pi*f; w = w.';
vp = integrate(vp,dw,0);
vp = (spo*wo + vp - vp(1))./w;
% bring back to Velocity
vp = 1./vp;
% bring back to Hz
% spline( x, y(x), new x ) = new y( new x )
vp = spline( w, vp , w/(2*pi) );
% figure;plot(f,vp)
% figure;loglog(f,vp)
% ------------------------------------------------------------------------------
figure;
h=pcolor(f,v,disp_vf_);
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
% ------------------------------------------------------------------------------
figure;
plot(f,vp*1e-3,'linewidth',4)
axis tight
xlabel('Frequency (Hz)'); 
ylabel('Phase velocity (km/s)');
title('Phase velocity curve')
simple_figure()

figure;
loglog(f,vp,'linewidth',5)
axis tight
xlim([10^(-1) 10^2])                         
ylim([10^2 10^4])
grid on
xlabel('Frequency (Hz)'); 
ylabel('Phase velocity (m/s)');
title('Phase velocity curve')
simple_figure()

