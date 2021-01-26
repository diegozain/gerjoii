close all
clear
clc
% ------------------------------------------------------------------------------
% from raw txt data, apply first
% 
% python dc_process.py
% ------------------------------------------------------------------------------
% set std cut
std_cut     = 200;%100;%Inf; % 90
% set max cut for apparent resistivities
rho_max_cut = Inf;%5e+3; % Inf; 2000; 9000; 500;
% x push so fwd domain play nice
x_push      = 2;% 15; % m 5
% max depth of fwd domain
z_max       = 9;%%100; % m 15
% ------  (plotting only) -------
% set a spacing for dd 
% a    = 2;
% set colormap shift
colo = 1; % 8; 4.2
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will process your dc shot-gathers.')
fprintf('\n --------------------------------------------------------\n\n')
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
path_  = strcat('../raw/',project_,'/dc-data/data-mat-raw/');
path__ = strcat('../raw/',project_,'/dc-data/');
% ------------------------------------------------------------------------------
% project name
% project_ = 'bhrs'; % up to a-spacing=11
% colo=8;
% project_ = 'groningen';  % up to a-spacing=1
% project_ = 'groningen2'; % up to a-spacing=9
% colo=4.2;
% ------------------------------------------------------------------------------
% read src-rec pairs arranged by indicies of electrodes.
% columns are: a b m n, i.e. source sink rec+ rec-
% abmn are real receivers, so to get indicies we have to be smart.
src_rec_dc  = dlmread(strcat(path_,'abmn.txt'));
electr_real = unique(sort(src_rec_dc(:)));
n_electrodes= numel(electr_real);
% ------------------------------------------------------------------------------
n_shots    = size(src_rec_dc,1);
src_rec_dc = binning(electr_real,src_rec_dc(:));
src_rec_dc = reshape(src_rec_dc,[n_shots,4]);
% ------------------------------------------------------------------------------
electr_real= [electr_real , zeros(n_electrodes,1)];
dr         = min(diff(electr_real));
% src_rec_dc = ((src_rec_dc-1)/dr)+1;
% % WARNING: change this for a look-up table on indicies!
% src_rec_dc = 2*src_rec_dc -1;
% ------------------------------------------------------------------------------
fprintf('\n     # of electrodes:                            %i ',n_electrodes)
fprintf('\n     # of shots:                                 %i \n',n_shots)
% ------------------------------------------------------------------------------
% get electrodes in real coordinates
fprintf('\n\n electrodes real coordinates are different from project to project')
fprintf('\n                   be careful!!\n')
% ------------------------------------------------------------------------------
% electr_real = [[(0:0.5:10).' ; (11:0.5:36).'] , zeros(n_electrodes,1)];
% electr_real = [(0:1:(n_electrodes-1)).' , zeros(n_electrodes,1)];
% electr_real = [(0:dr:dr*(n_electrodes-1)).' , zeros(n_electrodes,1)];
% ------------------------------------------------------------------------------
% does field_.dc already exist?
field_yn = 'n';
if exist(strcat(path__,project_,'_dc.mat'),'file') == 2
  prompt = '\n\n    field_.dc already exists. Do you want to load (y/n): ';
  field_yn = input(prompt,'s');
  if strcmp(field_yn,'y')
    load(strcat(path__,project_,'_dc.mat'));
    std_cut     = field_.dc.std_cut;
    rho_max_cut = field_.dc.rho_max_cut;
    colo        = field_.dc.colo;
    electr_real = field_.dc.electr_real;
    iremove     = field_.dc.iremove;
    x_push      = field_.x_push;
    z_max       = field_.z_max;
    n_electrodes= field_.dc.n_electrodes;
    % -
    src_rec_dc = dlmread(strcat(path_,'abmn.txt'));
    elect_remove = max(electr_real(:,1));
    [elect_remove,~] = ind2sub(size(src_rec_dc),find(src_rec_dc>elect_remove));
    elect_remove = unique(elect_remove);
    src_rec_dc(elect_remove,:) = [];
    % -
    n_shots    = size(src_rec_dc,1);
    src_rec_dc = binning(electr_real,src_rec_dc(:));
    src_rec_dc = reshape(src_rec_dc,[n_shots,4]);
    dr         = min(diff(electr_real));
    % -
    fprintf('\n new # of electrodes:                            %i ',n_electrodes)
    fprintf('\n new # of shots:                                 %i \n',n_shots)
  end
end
% ------------------------------------------------------------------------------
fprintf('\n     std cut-off                           :      %d',std_cut)
fprintf('\n     max cut-off for apparent resistivities:      %d',rho_max_cut)
fprintf('\n     x push (m):                                  %d',x_push)
fprintf('\n     max depth of probing (m):                    %d',z_max)
% ------------------------------------------------------------------------------
figure;
plot(electr_real(:,1),electr_real(:,2),'k.','markersize',20)
axis tight
axis ij
xlabel('x (m)')
ylabel('z (m)')
title('Electrode positions in the field')
simple_figure();
% ------------------------------------------------------------------------------
if exist(strcat(path_,'app_resi.npy'))==2
  % read apparent resistivity
  rhoa = readNPY(strcat(path_,'app_resi.npy'));
  % read voltages
  d_o  = readNPY(strcat(path_,'voltages.npy'));
  % read std
  std_ = readNPY(strcat(path_,'std.npy'));
  % read currents
  currents = readNPY(strcat(path_,'currents.npy'));
else
  % read apparent resistivity
  rhoa = dlmread(strcat(path_,'app_resi.txt'));
  % read voltages
  d_o  = dlmread(strcat(path_,'voltages.txt'));
  % read std
  std_ = dlmread(strcat(path_,'std.txt'));
  % read currents
  currents = dlmread(strcat(path_,'currents.txt'));
end
% ------------------------------------------------------------------------------
elect_remove_ = 'n';
if ~strcmp(field_yn,'y')
  prompt = '\n\n Do you want to remove electrodes above a certain number (y or n)?:  ';
  elect_remove_ = input(prompt,'s');
  if strcmp(elect_remove_,'y')
    prompt = '\n\n    tell me above which number (in meters) I should delete:  ';
    elect_remove = input(prompt,'s');
    elect_remove = str2num(elect_remove);
    % -
    src_rec_dc = dlmread(strcat(path_,'abmn.txt'));
    [elect_remove,~] = ind2sub(size(src_rec_dc),find(src_rec_dc>elect_remove));
    elect_remove = unique(elect_remove);
    src_rec_dc(elect_remove,:) = [];
    % - 
    electr_real= unique(sort(src_rec_dc(:)));
    n_electrodes= numel(electr_real);
    n_shots    = size(src_rec_dc,1);
    src_rec_dc = binning(electr_real,src_rec_dc(:));
    src_rec_dc = reshape(src_rec_dc,[n_shots,4]);
    electr_real= [electr_real , zeros(n_electrodes,1)];
    dr         = min(diff(electr_real));
    % -
    rhoa(elect_remove) = [];
    d_o(elect_remove) = [];
    std_(elect_remove) = [];
    currents(elect_remove) = [];
    % -
    fprintf('\n new # of electrodes:                            %i ',n_electrodes)
    fprintf('\n new # of shots:                                 %i \n',n_shots)
  end
else % which means strcmp(field_yn,'y') is true
  rhoa(elect_remove) = [];
  d_o(elect_remove) = [];
  std_(elect_remove) = [];
  currents(elect_remove) = [];
end
% ------------------------------------------------------------------------------
std_max  = max(std_);
std_min  = min(std_);
rhoa_max = max(rhoa);
rhoa_min = min(rhoa);
% ------------------------------------------------------------------------------
%                     quality removal
% ------------------------------------------------------------------------------
if ~strcmp(field_yn,'y')
  % std_cut   = std_cut*mean(std_);
  istd_bad  = find(std_>std_cut);
  irhoa_neg = find(rhoa<=0);
  irhoa_big = find(rhoa>rho_max_cut);
  iremove = [istd_bad;irhoa_neg;irhoa_big];
  % ----------------------------------------------------------------------------
  iremove = unique(iremove);
  % ----------------------------------------------------------------------------
  rhoa(iremove) = NaN;
  d_o(iremove)  = NaN;
  std_(iremove) = NaN;
  currents(iremove) = NaN;
else % which means strcmp(field_yn,'y') is true
  rhoa(iremove) = [];
  d_o(iremove) = [];
  std_(iremove) = [];
  currents(iremove) = [];
  src_rec_dc(iremove,:,:) = [];
end
% ------------------------------------------------------------------------------
% collect sources and rec
src = src_rec_dc(:,1:2);
rec = src_rec_dc(:,3:4);
% ------------------------------------------------------------------------------
%
%                     this only affects plotting
%
% ------------------------------------------------------------------------------
%                         plot src-rec pairs
% ------------------------------------------------------------------------------
% bundle sources, current, receivers, observed data and standard deviation,
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
s_i_r_d_std = dc_iris2gerjoii( src,currents,rec,d_o,std_ );
n_exp = size(s_i_r_d_std,2);
% ------------------------------------------------------------------------------
% this part is just so dc_plot_srcrec_all plays nice.
X   =zeros(1,2);
X(1)=electr_real(1,1);
X(2)=electr_real(end,1);
geome_.X = X;
gerjoii_.dc.electr_real=electr_real;
% ------------------------------------------------------------------------------
for i_e=1:n_exp
  s_all{i_e} = s_i_r_d_std{ i_e }{ 1 }(1:2);
  r_all{i_e} = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
end
dc_plot_srcrec_all(gerjoii_,geome_,s_all,r_all);
clear gerjoii_ geome_
% ------------------------------------------------------------------------------
% dylan's florida data has this flipped for some weird reason. Feb 2020
prompt = '\n\n    Are the ab electrodes flipped ba (y or n):  ';
ab_flipped = input(prompt,'s');
if strcmp(ab_flipped,'y')
  src = flip(src,2);
end
% ------------------------------------------------------------------------------
% choose a-spacing
prompt = '\n\n    what a-spacing do you want for dipol-dipole:  ';
a = input(prompt);
% ------------------------------------------------------------------------------
%                     pseudo sections
% ------------------------------------------------------------------------------
% wenner
[pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoa,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% save 
voltagram.pseus_rhoa = pseus_rhoa;
voltagram.pseus_do   = pseus_do;
voltagram.source_no  = source_no;  
voltagram.n_levels   = n_levels;  
% save(strcat(project_,'-wen.mat'),'voltagram')
% --
% figure;
% fancy_pcolor(pseus_do,source_no,n_levels);
% colormap(rainbow2(colo))
% axis normal
% xlabel('Source #')
% ylabel('n level')
% title('Wenner (V)');
% simple_figure();
figure;
fancy_pcolor(pseus_rhoa,source_no,n_levels);
colormap(rainbow2(colo))
axis normal
xlabel('Source #')
ylabel('n level')
title('Wenner (Ohm.m)');
simple_figure();
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
% save(strcat(project_,'-dd.mat'),'voltagram')
% --
% figure;
% fancy_pcolor(pseus_do,source_no,n_levels);
% colormap(rainbow2(0.1))
% axis normal
% xlabel('Source #')
% ylabel('n level')
% title(['Dipole-dipole (V) for a-spacing = ',num2str(a)]);
% simple_figure();
figure;
fancy_pcolor(pseus_rhoa,source_no,n_levels);
colormap(rainbow2(colo))
axis normal
xlabel('Source #')
ylabel('n level')
title(['Dipole-dipole (Ohm.m) for a-spacing = ',num2str(a)]);
simple_figure();
% ------------------------------------------------------------------------------
%                           quality removal 
% ------------------------------------------------------------------------------
if ~strcmp(field_yn,'y')
  rhoa(iremove) = [];
  d_o(iremove) = [];
  std_(iremove) = [];
  currents(iremove) = [];
  src_rec_dc(iremove,:,:) = [];
  % collect sources and rec
  src = src_rec_dc(:,1:2);
  rec = src_rec_dc(:,3:4);
end
% ------------------------------------------------------------------------------
% get average
rho_ave = mean(rhoa);
fprintf('\n\n     mean value of apparent resistivity     (Ohm.m):  %d \n',rho_ave)
% ------------------------------------------------------------------------------
% raw data, rhoa and standard deviation in index form
z=zeros(size(rhoa));
m=ones(size(d_o))*std_cut;
% --
figure;
plot(d_o,'k.','markersize',20)
axis square
axis tight
xlabel('Index #')
ylabel('Data (V)')
title('Observed data');
simple_figure();
% --
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
simple_figure();
% --
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
simple_figure();
% --
figure;
[ksd_std_,std__] = ksdensity(std_);
plot(std__,ksd_std_,'k-')
axis square
axis tight
ylabel('Density')
xlabel('Standard deviation')
title('Observed data');
simple_figure();
% --
figure;
plot(currents,'k.','markersize',20)
axis square
axis tight
xlabel('Index #')
ylabel('Current (A)')
title('Source magnitude');
simple_figure();
% ------------------------------------------------------------------------------
% get value for surface apparent resistivity
% ------------------------------------------------------------------------------
if ~strcmp(field_yn,'y')
  prompt = '     tell me value for surface apparent resistivity (Ohm.m):  ';
  rho_sur = input(prompt,'s');
  rho_sur = str2double(rho_sur);
else
  rho_sur = field_.dc.rho_sur;
  fprintf('     value for surface apparent resistivity (Ohm.m):  %d',rho_sur)
end
% ------------------------------------------------------------------------------
%
%                           save parameters in field_ 
%
% ------------------------------------------------------------------------------
field_ = struct;
% ------------------------------------------------------------------------------
% from real done survey 
field_.dc.n_electrodes = n_electrodes;
field_.dc.electr_real  = electr_real;
% ------------------------------------------------------------------------------
% you must choose these. maybe run datavis_dc2 first to choose them.
field_.dc.rho_max_cut = rho_max_cut;  % Ohm.m
field_.dc.rho_ave     = rho_ave;      % Ohm.m
field_.dc.rho_sur     = rho_sur;      % Ohm.m
field_.dc.std_cut     = std_cut;
field_.dc.colo        = colo;
% if strcmp(elect_remove_,'y')
%   iremove=[iremove;elect_remove];
%   iremove=unique(iremove);
% end
field_.dc.iremove   = iremove;
% ------------------------------------------------------------------------------
% push all receivers x_push to give the fwd solver some room
field_.x_push = x_push; % m
% max depth of penetration
field_.z_max  = z_max;
% ------------------------------------------------------------------------------
% save?
prompt = '\n\n    do you want to save field_.dc (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  save(strcat('../raw/',project_,'/dc-data/',project_,'_dc.mat'),'field_')
  % ----------------------------------------------------------------------------
  fprintf('\n\n       field_.dc has been saved in %s \n\n\n',...
  strcat('../raw/',project_,'/dc-data/',project_,'_dc.mat'))
else
  fprintf('\n\n       ok, your meta-data was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------









