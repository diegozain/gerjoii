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
fprintf('\n   array name: %s ',array_name);
fprintf('\n   # of stations: %i\n',nstat)
fprintf('\n   ---------------------\n\n')
% ------------------------------------------------------------------------------
% display array geometry
figure;
% plot(locs(:,1),locs(:,2),'.k','markersize',20)
hold on
line(locs(:,1),locs(:,2),'color','[0.5 0.5 0.5]')
scatter(locs(:,1),locs(:,2),500*ones(numel(locs(:,1)),1),...
1:numel(locs(:,1)),'filled');
hold off
colormap(rainbow2(1));
% --
cc=colorbar;
cc.TickLength = 0;
% cc.Label.Interpreter = 'latex';
cc.Label.FontSize = 20;
xlabel(cc,'Station #')
% --
xlabel('Easting (m)')
ylabel('Northing (m)')
title(strcat('Array',{' '},strrep(array_name,'_','.')));
box on;
simple_figure()
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
clear ambient array_name d_enz j_ station_name;
% ------------------------------------------------------------------------------
% whiten spectra:
%   bring data to frequency domain
%   average
%   divide
%   take back to time domain
% --
% windows to take the window mean
c_f = 1; % [Hz]
c_t = 5; % [s]
c_f = fix(c_f / (1/dt/size(d,1))); 
c_t = fix(c_t / dt);
% --
% design time chunks so my laptop doesn't die from ram space
dch = 120; % [s]
dch = floor(dch/dt);
chs = (0:dch:nt)+mod(nt,dch);
nchs = numel(chs);
for ich=1:(nchs-1)
  for icomp=1:3
    % --
    d_ = fft(squeeze(d( (chs(ich)+1):chs(ich+1) ,icomp,:)),[],1);
    % windowed mean via conv gives artifacts near the edges, so 
    % let those artifacts be in the high rather than low freqs,
    d_ = fftshift(d_,1);
    d_meaned = window_mean(abs(d_),c_f);
    d_ = d_ ./ d_meaned;
    d_ = fftshift(d_,1);
    d_ = real(ifft(d_,[],1));
    % nt_=2^nextpow2(nt);
    % nt_extra = nt_-nt;
    % d_ = d_(1:end-nt_extra, : );
    % --
    d_meaned = window_mean(abs(d_),c_t);
    d_ = d_ ./ d_meaned;
    % --
    d(  (chs(ich)+1):chs(ich+1)  ,icomp,:) = d_;
  end
  if mod(20,ich)==0
    fprintf('\n chunk # %i',ich);
  end
end
% ------------------------------------------------------------------------------
% something weird happens in the beginnig and ending of the data
d=d(10:(nt-10),:,:);
nt=size(d,1);
% ------------------------------------------------------------------------------
% data is too big for my laptop to handle :(
d=d(1:fix(0.3*size(d,1)),:,:);
% ------------------------------------------------------------------------------
% bring data to frequency domain
fprintf('\ntaking to frequency\n')
d_=zeros(2^(nextpow2(size(d,1))-1)-1,size(d,2),size(d,3));
for icomp=1:3
  [d__,f,df] = fourier_rt(squeeze(d(:,icomp,:)),dt);
  d_(:,icomp,:) = d__;
end
% ------------------------------------------------------------------------------
% beamform_ this fucker (angle by velocity)
fprintf('beamforming\n')
f_low = 2;
f_high = 20;
df = 10;
v_min = 1;
v_max = 1200;
dv = 10;
fo_ = f_low:0.1:f_high; % [Hz]
v = v_min:dv:v_max;
dtheta = (2*pi)/100;
theta = 0:dtheta:2*pi;
b = beamformer_thetav(fo_,locs,squeeze(d_(:,1,:)),f,v,theta);
% b = beamformer_(30,locs,squeeze(d_(:,1,:)),f,v,theta);
b=abs(b).^2;
b=b/max(b(:));
% % save
% beamformer.b = b;
% beamformer.v = v;
% beamformer.theta = theta;
% beamformer.fo_ = fo_;
% beamformer.d_ = d_(:,1,:);

figure;
subplot(1,2,2)
fancy_polar(b.',v,theta)
% colorbar('off')
colormap(rainbow2(1))
simple_figure();
subplot(1,2,1)
imagesc(v,theta,b);
colormap(rainbow2(1))
axis square
xlabel('Velocity (m/s)')
ylabel('Angle (rad)')
title('Beamformer')
simple_figure();

