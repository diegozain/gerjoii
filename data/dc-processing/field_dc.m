close all
clear all
clc
% ------------------------------------------------------------------------------
%
%                           build field_ structure
%
% that is, meta-data for all shot-gathers.
% ------------------------------------------------------------------------------
% must choose existing project:
project_ = 'bhrs';
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   build field_ er structure for project: %s',project_)
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
field_ = struct;
% ------------------------------------------------------------------------------
% from real done survey 
field_.dc.n_electrodes = Inf;
% ------------------------------------------------------------------------------
% you must choose these. maybe run datavis_dc2 first to choose them.
field_.dc.rho_max_cut = Inf;  % Ohm.m
field_.dc.rho_ave     = 1; % Ohm.m
field_.dc.rho_sur     = 1; % Ohm.m
field_.dc.std_cut     = Inf;
field_.dc.colo        = 1;
% ------------------------------------------------------------------------------
% push all receivers x_push to give the fwd solver some room
field_.x_push = 5; % m
% ------------------------------------------------------------------------------
save(strcat('../raw/',project_,'/dc-data/',project_,'_dc.mat'),'field_')
% ------------------------------------------------------------------------------
fprintf('\n\n       your field meta-data has been saved in %s \n\n\n',...
strcat('../raw/',project_,'/dc-data/',project_,'_dc.mat'))

