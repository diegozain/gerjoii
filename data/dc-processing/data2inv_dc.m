close all
clear
clc
% ------------------------------------------------------------------------------
%
%                           get data ready for inversion
%
% after dc_process.py and datavis_dc2.m.
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   gonna make data ready for inversion')
fprintf('\n   run after dc_process.py and datavis_dc2.m')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
ls('../raw/');
prompt = '\n\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
path_  = strcat('../raw/',project_,'/dc-data/data-mat-raw/');
path__ = strcat('../raw/',project_,'/dc-data/');
% ------------------------------------------------------------------------------
% load field structure
load(strcat(path__,project_,'_dc.mat'));
std_cut     = field_.dc.std_cut;
colo        = field_.dc.colo;
electr_real = field_.dc.electr_real;
iremove     = field_.dc.iremove;
n_electrodes= field_.dc.n_electrodes;
x_push      = field_.x_push;
z_max       = field_.z_max;
rho_max_cut = field_.dc.rho_max_cut;  % Ohm.m
rho_ave     = field_.dc.rho_ave;      % Ohm.m
rho_sur     = field_.dc.rho_sur;      % Ohm.m
% ------------------------------------------------------------------------------
fprintf('\n     # of electrodes:                            %i',n_electrodes)
fprintf('\n     std cut-off as multiple of mean(std):       %d',std_cut)
fprintf('\n     max cut-off for apparent resistivities:     %d\n\n',rho_max_cut)
% ------------------------------------------------------------------------------
%                                 load data
% ------------------------------------------------------------------------------
% load abmn ( in index? )
src_rec_dc = dlmread(strcat(path_,'abmn.txt'));
n_shots    = size(src_rec_dc,1);
src_rec_dc = binning(electr_real(:,1),src_rec_dc(:));
src_rec_dc = double(src_rec_dc);
src_rec_dc = reshape(src_rec_dc,[n_shots,4]);
% % WARNING: change this for a look-up table on indicies!
% src_rec_dc = 2*src_rec_dc -1;
% ------------------------------------------------------------------------------
% read apparent resistivity
rhoa     = dlmread(strcat(path_,'app_resi.txt'));
% read voltages
d_o      = dlmread(strcat(path_,'voltages.txt'));
% read std
std_     = dlmread(strcat(path_,'std.txt'));
% read currents
currents = dlmread(strcat(path_,'currents.txt'));
% ------------------------------------------------------------------------------
%                                 pre-process
% ------------------------------------------------------------------------------
rhoa(iremove)           = [];
d_o(iremove)            = [];
std_(iremove)           = [];
currents(iremove)       = [];
src_rec_dc(iremove,:,:) = [];
% ------------------------------------------------------------------------------
% collect sources and rec
src = src_rec_dc(:,1:2);
rec = src_rec_dc(:,3:4);
% ------------------------------------------------------------------------------
% current normalization --> voltage normalization.
d_o = d_o./currents;
i_o = ones(size(currents));
n_shots = numel(d_o);
% ------------------------------------------------------------------------------
% get max & min apparent resistivity
rho_max = max(rhoa);
rho_min = min(rhoa);
% ------------------------------------------------------------------------------
%                 bundle all in s_i_r_d_std.mat structure
% ------------------------------------------------------------------------------
% s_i_r_d_std is a cell of ns cells:
% 
% { { [s i],[r d_o] }, ..., { [s i],[r d_o] }  }
%
% [s i] is (1 by 3) first two entries are source, third is current.
% [r d_o std_o] is (nr_si by 4) where
%         nr_si is # of receivers for that source & current.
% ns is # of shots done, i.e. # of fwd models to do.
%
% example of usage:
% suppose we want to model src & current # j:
%
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
s_i_r_d_std = dc_iris2gerjoii( src,i_o,rec,d_o,std_ );
% ------------------------------------------------------------------------------
%                                     x push
% ------------------------------------------------------------------------------
electr_real(:,1) = electr_real(:,1) + x_push;
dr = min(diff(electr_real(:,1)));
% ------------------------------------------------------------------------------
%                                     parame_
% ------------------------------------------------------------------------------
parame_ = struct;
%--------------
% domain
%--------------
parame_.aa = 0;
parame_.bb = electr_real(n_electrodes,1) + x_push;
parame_.cc = z_max;
% ------------------------------------------------------------------------------
% get values from wave solver
prompt = '\n\n    do you want dx & dz from wave solver (y/n):  ';
dxdz_w_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(dxdz_w_,'y')
  pp_=load(strcat('../raw/',project_,'/w-data/data-mat-fwi/parame_.mat'));
  parame_.dx = pp_.parame_.dx;
  parame_.dz = pp_.parame_.dz;
  clear pp_
else
  parame_.dx = dr*0.05; % *0.1 *0.05
  parame_.dz = dr*0.05; % *0.1 *0.05
end
% ------------------------------------------------------------------------------
parame_.x  = parame_.aa:parame_.dx:parame_.bb;
parame_.z  = parame_.aa:parame_.dz:parame_.cc;
%------------------
% robin padding
%------------------
parame_.dc.robin = 1;
%------------------
% 2.5d for ER solver
%------------------
parame_.dc.n_ky = 4;
%------------------
% electrodes and min electrode-electrode distance 
%------------------
parame_.dc.electr_real  = electr_real;
parame_.dc.dr           = dr;
parame_.dc.n_electrodes = n_electrodes;
parame_.dc.n_exp        = size( s_i_r_d_std , 2 );
parame_.dc.n_shots      = n_shots;
%------------------
% for initial guess 
%------------------
parame_.dc.rho_max_cut = rho_max_cut;
parame_.dc.rho_max     = rho_max;
parame_.dc.rho_min     = rho_min;
parame_.dc.rho_ave     = rho_ave;
parame_.dc.rho_sur     = rho_sur;
% ------------------------------------------------------------------------------
%                                     save
% ------------------------------------------------------------------------------
prompt = '\n\n    Do you want to save these parameters? (y or n):  ';
save_me= input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_me,'y')
  % s_i_r_d_std
  name = strcat('../raw/',project_,'/dc-data/data-mat/','s_i_r_d_std','.mat');
  save( name , 's_i_r_d_std' );
  fprintf('\n    ok, dc data is saved now in \n %s \n\n',name)
  % parame_
  name = strcat('../raw/',project_,'/dc-data/data-mat/','parame_','.mat');
  save( name , 'parame_' );
  % --
  fprintf('\n    and parame_ is saved now in \n %s \n\n',name)
  % rhoa_o_
  rhoa_o_ = rhoa;
  name = strcat('../raw/',project_,'/dc-data/data-mat/','rhoa_o_','.mat');
  save( name , 'rhoa_o_' );
  % --
  fprintf('\n    and rhoa_o_ is saved now in \n %s \n\n',name)
else
  fprintf('\n   ok whatever, suit yourself.  \n\n')
end
% ------------------------------------------------------------------------------
%                                 plotting
% ------------------------------------------------------------------------------
% % dylan's florida data has this flipped for some weird reason. Feb 2020
% % this only affects plotting
% src = flip(src,2);
% ------------------------------------------------------------------------------
% dipole-dipole
a=1;
[pseus_do,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoa,a,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% --
figure;
fancy_pcolor(pseus_rhoa,source_no,n_levels);
colormap(rainbow2(colo))
axis normal
xlabel('Source #')
ylabel('n level')
title(['Dipole-dipole (Ohm.m) for a-spacing = ',num2str(a)]);
simple_figure();
% wenner
[pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoa,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% --
figure;
fancy_pcolor(pseus_rhoa,source_no,n_levels);
colormap(rainbow2(colo))
axis normal
xlabel('Source #')
ylabel('n level')
title('Wenner (Ohm.m)');
simple_figure();
% ------------------------------------------------------------------------------
% receivers real
figure;
plot(electr_real(:,1),electr_real(:,2),'k.','markersize',20)
xlim([parame_.aa, parame_.bb])
axis ij
xlabel('x (m)')
ylabel('z (m)')
title('Electrode positions in domain')
simple_figure();
% ------------------------------------------------------------------------------



