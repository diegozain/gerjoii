close all
clear all
clc

% from raw txt data, apply first (in 'read-data')
% 
% ./dc-process-data.sh

% # of electrodes 
n_electrodes = 30;

% read src-rec pairs arranged by indicies of electrodes.
% columns are: a b m n, i.e. source sink rec+ rec-
src_rec_dc = dlmread('read-data/er-src-rec.txt');

% read apparent resistivity
rhoa = dlmread('read-data/er-rhoa.txt');
% read voltages
d_o = dlmread('read-data/er-i-u-std.txt');
d_o = d_o(:,2);

% collect sources and rec
src = src_rec_dc(:,1:2);
rec = src_rec_dc(:,3:4);

% ---------------------------------------------------------------------------

[pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoa,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);

figure;
fancy_pcolor(pseus_do,source_no,n_levels);
colormap(jet)
axis normal
xlabel('source \#')
ylabel('$n$ level')
title('wenner $\Delta u\,[V]$');
fancy_figure();

% ---------------
%   dipole-dipole
% ---------------

% set a spacing
a = 1;
[pseus_do,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoa,a,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);

figure;
fancy_pcolor(pseus_do,source_no,n_levels);
colormap(jet)
axis normal
xlabel('source \#')
ylabel('$n$ level')
title(['dipole-dipole $\Delta u\,[V]$ for $a$-spacing = ',num2str(a)]);
fancy_figure();

