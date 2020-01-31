close all
clear
clc
% ------------------------------------------------------------------------------
% from raw txt data, apply first
% 
% python dc_process.py
% ------------------------------------------------------------------------------
% set std cut as in std_cut = std_cut*mean(std_)
std_cut = 3;
% set a spacing
a = 1;
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will process your dc shot-gathers.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
fprintf('\n     std cut-off as multiple of mean(std): %d',std_cut)
% ------------------------------------------------------------------------------
path_=strcat('../raw/',project_,'/dc-data/data-mat-raw/');
% ------------------------------------------------------------------------------
% read src-rec pairs arranged by indicies of electrodes.
% columns are: a b m n, i.e. source sink rec+ rec-
src_rec_dc = dlmread(strcat(path_,'abmn.txt'));
% get number of electrodes
n_electrodes = numel(unique(src_rec_dc(:)));
fprintf('\n     # of electrodes: %i \n',n_electrodes)
% ------------------------------------------------------------------------------
% read apparent resistivity
rhoa = dlmread(strcat(path_,'app_resi.txt'));
% read voltages
d_o = dlmread(strcat(path_,'voltages.txt'));
% read std
std_ = dlmread(strcat(path_,'std.txt'));
% read currents
currents = dlmread(strcat(path_,'currents.txt'));
% ------------------------------------------------------------------------------
std_max = max(std_);
std_min = min(std_);
rhoa_max = max(rhoa);
rhoa_min = min(rhoa);
% ------------------------------------------------------------------------------
%                     quality removal
% ------------------------------------------------------------------------------
fprintf('\n  remember to comment/uncomment quality factor data removal!!\n\n')
std_cut   = std_cut*mean(std_);
istd_bad  = find(std_>std_cut);
irhoa_neg = find(rhoa<0);
iremove = [istd_bad;irhoa_neg];
iremove = unique(iremove);
% ------------------------------------------------------------------------------
rhoa(iremove) = NaN;
d_o(iremove) = NaN;
std_(iremove) = NaN;
currents(iremove) = NaN;
% ------------------------------------------------------------------------------
% collect sources and rec
src = src_rec_dc(:,1:2);
rec = src_rec_dc(:,3:4);
% ------------------------------------------------------------------------------
%                     pseudo sections
% ------------------------------------------------------------------------------
% wenner
[pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoa,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% save 
voltagram.pseus_rhoa = pseus_rhoa;
voltagram.pseus_do = pseus_do;
voltagram.source_no = source_no;  
voltagram.n_levels = n_levels;  
save(strcat(project_,'-wen.mat'),'voltagram')

min_rhoa = min(pseus_rhoa(:));
max_rhoa = max(pseus_rhoa(:));

figure;
pcolor(source_no,n_levels,pseus_rhoa);
caxis([min_rhoa,max_rhoa])
colormap(hsv)
colorbar
axis ij
axis normal
shading flat;
xlabel('Source #')
ylabel('n level')
title('Wenner (Ohm.m)');
% ------------------------------------------------------------------------------
%   dipole-dipole
[pseus_do,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoa,a,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% save 
voltagram.pseus_rhoa = pseus_rhoa;
voltagram.pseus_do = pseus_do;
voltagram.source_no = source_no;  
voltagram.n_levels = n_levels;  
save(strcat(project_,'-dd.mat'),'voltagram')

figure;
pcolor(source_no,n_levels,pseus_rhoa);
caxis([min_rhoa,max_rhoa])
colormap(hsv)
colorbar
axis ij
axis normal
shading flat;
xlabel('Source #')
ylabel('n level')
title(['Dipole-dipole (Ohm.m) for a-spacing = ',num2str(a)]);
% ------------------------------------------------------------------------------
%                     quality removal (for real)
% ------------------------------------------------------------------------------
fprintf('\n  remember to comment/uncomment quality factor data removal!! (for real)\n\n')
rhoa(iremove) = [];
d_o(iremove) = [];
std_(iremove) = [];
currents(iremove) = [];
src_rec_dc(iremove,:,:) = [];
% collect sources and rec
src = src_rec_dc(:,1:2);
rec = src_rec_dc(:,3:4);
% ------------------------------------------------------------------------------
% now data has to be saved again

% ------------------------------------------------------------------------------
% raw data, rhoa and standard deviation in index form
z=zeros(size(rhoa));
m=ones(size(d_o))*std_cut;

figure;
plot(d_o,'k.','markersize',20)
axis square
axis tight
xlabel('Index #')
ylabel('Data (V)')
title('Observed data');

figure;
hold on;
plot(rhoa,'k.','markersize',20)
plot(z,'r-')
hold off;
axis square
axis tight
ylim([rhoa_min, rhoa_max])
xlabel('Index #')
ylabel('App. Resistivity (Ohm.m)')
title('Observed data');

figure;
hold on;
plot(std_,'k.','markersize',20)
plot(m,'r-')
hold off;
axis square
axis tight
ylim([std_min, std_max])
xlabel('Index #')
ylabel('Standard deviation')
title('Observed data');

figure;
plot(currents,'k.','markersize',20)
axis square
axis tight
xlabel('Index #')
ylabel('Current (A)')
title('Source magnitude');



