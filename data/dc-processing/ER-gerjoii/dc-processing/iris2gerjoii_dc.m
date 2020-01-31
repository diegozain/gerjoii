close all
clear
clc
% ------------------------------------------------------------------------------
% from raw txt data apply,
% python dc_process.py
% and then datavis_dc2.m to find the right parameters for trimming the data.
% ------------------------------------------------------------------------------
% cut for std as in std_cut = std_cut*mean(std_)
std_cut = 3;
% a-spacing for dd plotting
a = 1;
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will process AND save your dc shot-gathers.')
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
std_cut = std_cut*mean(std_);
% ------------------------------------------------------------------------------
%                     quality removal
% ------------------------------------------------------------------------------
fprintf('\n  remember to comment/uncomment quality factor data removal!!\n\n')
istd_bad  = find(std_>std_cut);
irhoa_neg = find(rhoa<0);
iremove = [istd_bad;irhoa_neg];
iremove = unique(iremove);
% ------------------------------------------------------------------------------
rhoa(iremove) = [];
d_o(iremove) = [];
std_(iremove) = [];
currents(iremove) = [];
src_rec_dc(iremove,:,:) = [];
% collect sources and rec
src = src_rec_dc(:,1:2);
rec = src_rec_dc(:,3:4);
% ------------------------------------------------------------------------------
% current normalization --> voltage normalization.
d_o = d_o./currents;
i_o = ones(size(currents));
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
%                               see
% ------------------------------------------------------------------------------
% wenner
[pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoa,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
min_rhoa = min(pseus_rhoa(:));
max_rhoa = max(pseus_rhoa(:));
figure;
pcolor(source_no,n_levels,pseus_rhoa);
caxis([min_rhoa,max_rhoa])
colormap(hsv)
axis ij
axis normal
shading flat;
xlabel('Source #')
ylabel('n level')
title('Wenner (Ohm.m)');
%   dipole-dipole
[pseus_do,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoa,a,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
figure;
pcolor(source_no,n_levels,pseus_rhoa);
caxis([min_rhoa,max_rhoa])
colormap(hsv)
axis ij
axis normal
shading flat;
xlabel('Source #')
ylabel('n level')
title(['Dipole-dipole (Ohm.m) for a-spacing = ',num2str(a)]);
% ------------------------------------------------------------------------------
%                               save
% ------------------------------------------------------------------------------
name = strcat('../raw/',project_,'/dc-data/data-mat/','s_i_r_d_std','.mat');
save( name , 's_i_r_d_std' );
fprintf('\n    ok, dc data is saved now in \n %s \n\n',name)