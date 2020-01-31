% ------------------------------------------------------------------------------
% 
% surface wave analysis on passive data from Grenoble
%
% this here script makes the array raw data ready for use with gerjoii.
% run grenoble_see.m first to get nt and look at one receiver.
%
% saves station data into data-mat folder:
%     folder with array name
%       mat file with geometry
%         locations & names of stations
%       mat file with station name
%         data in all components (E,N,Z)
%         dt used
%         physical location (identical to the one in geometry file above)
%         name of station
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
% array
array_name = 'C_26_78'; % 'C_78_405'; % 'C_26_78'; 'C_45_135';
data_path = strcat('../../data/raw/AVA_GRENOBLE_SAC/GRENOBLE_SAC/GRE_',...
array_name,'/');
geom_name = strcat('../../data/raw/AVA_GRENOBLE_SAC/GRENOBLE_GEOM/GRE_',...
array_name,'.geom');
components = {'E','N','Z'};
% load geometry of array
geom = importdata(geom_name);
locs = geom.data; % coordinates easting x northing [m]
names = geom.textdata(2:end,1);
nr = numel(names);
% ------------------------------------------------------------------------------
% from grenoble_see.m,
% array   |  nt
% -------------
% C_45_135 1146000
% C_78_405 1440000
% C_26_78  978000
nt = 978000; 
% ------------------------------------------------------------------------------
% print funny stuff so user is amused
fprintf('\n I am roboto-matlab, hi.\n\n');
fprintf('\n   ---------------------\n')
fprintf('\n   array name: %s ',array_name);
fprintf('\n   # of stations: %i\n',nr)
fprintf('\n   ---------------------\n\n')
% ------------------------------------------------------------------------------
% display array geometry
figure;
% plot(locs(:,1),locs(:,2),'.k','markersize',20)
hold on
line(locs(:,1),locs(:,2),'color','[0.5 0.5 0.5]')
scatter(locs(:,1),locs(:,2),300*ones(numel(locs(:,1)),1),...
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
% dir to save
data_path_=strcat('data-mat/',array_name,'/');
if exist(data_path_) ~= 7
  mkdir(data_path_);
end
% loop over stations
for j_ = 1:nr
  % station
  station_name = names(j_);
  station_name = char(station_name);
  if and(j_==5,strcmp(array_name,'C_78_405'))
    station_name = strcat('CORR','_',station_name);
  end
  % loop over components
  d_enz=zeros(nt,3);
  for i_=1:3
    component = components(i_); component = char(component);
    data_name = strcat('GRE_',array_name,'_',station_name,'_',component,'.sac');
    data_read = strcat(data_path,data_name);
    data=rdsac(data_read);
    % --------------------------------------------------------------------------
    % get the data
    d=data.d;
    dt=data.HEADER.DELTA; % [s]
    % % ------------------------------------------------------------------------
    % % bandpass
    % f_low = 0.01; % Hz
    % f_high = 5; % Hz
    % nbutter = 10;
    % d = filt_gauss(d,dt,f_low,f_high,nbutter);
    % % ------------------------------------------------------------------------
    % bundle components
    d_enz(:,i_) = d;
  end
  % bundle data for that station
  ambient = struct;
  ambient.d_enz = d_enz;
  ambient.dt = dt;
  ambient.loc = locs(j_,:);
  ambient.name = station_name;
  % save data for that station
  save(strcat(data_path_,station_name),'ambient')
  fprintf('       station # %i\n',j_);
end
% bundle array 
geome = struct;
geome.locs = locs;
geome.names = names;
% save geometry for this array
save(strcat(data_path_,'geome','_',array_name),'geome')
% print funny shit
fprintf('\n array data saved in \n%s\n\n',data_path_);
fprintf('...bye \n\n')
%clear 
