% ------------------------------------------------------------------------------
% 
% 2d synthetic inversion of conductivity using ER data
%
% ------------------------------------------------------------------------------
clear
close all
clc
% ------------------------------------------------------------------------------
pwd_ = pwd;
cd ../../../../
dir_paths;
cd(pwd_);
% ------------------------------------------------------------------------------
% build geometry and initial guess
% ------------------------------------------------------------------------------
pwd_ = pwd;
cd ../../
param_wdc;
cd(pwd_);
% ------------------------------------------------------------------------------
%                 choose between wdc_geom and wdc_geom_:
%
% wdc_geom  gives dx,dz with wave criteria.
% wdc_geom_ gives dx,dz arbitrarilly.
% ------------------------------------------------------------------------------
[parame_,finite_,geome_] = wdc_geom(parame_);
% ------------------------------------------------------------------------------
% dx=0.05;
% [parame_,finite_,geome_] = wdc_geom_(parame_,dx);
% ------------------------------------------------------------------------------
% overwrite eps and sig with a cute box in the middle.
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be declared in param_wdc.m
% ------------------------------------------------------------------------------
% % permittivity
% % tmp_=load('../mat-file/epsi.mat');
% tmp_=load('../../model-generator/nature-synth/mat-file/r1/epsi.mat');
% tmp_=tmp_.epsi;
% parame_.natu.epsilon_w = tmp_;
% % conductivity
% % tmp_=load('../mat-file/sigm.mat');
% tmp_=load('../../model-generator/nature-synth/mat-file/r1/sigm.mat');
% tmp_=tmp_.sigm;
% parame_.natu.sigma_w = tmp_;
% parame_.natu.sigma_dc = parame_.natu.sigma_w.';
% ------------------------------------------------------------------------------
% wavelength [m] & velocity [m/ns]
% l = parame_.w.c/( sqrt( relative_permittivity ))/parame_.w.fo;
% v = parame_.w.c/( sqrt( relative_permittivity )) * 1e-9;
% ------------------------------------------------------------------------------
% truth
% ------------------------------------------------------------------------------
% w
parame_.w.epsilon = parame_.natu.epsilon_w;
parame_.w.sigma = parame_.natu.sigma_w;
% dc
parame_.dc.sigma = parame_.natu.sigma_dc;
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
%
%                       generate synthetic data
%
% ------------------------------------------------------------------------------
gerjoii_ = struct;
data_path_w  = '../data-synth/w/';
data_path_dc = '../data-synth/dc/';
experim_check;
% ------------------------------------------------------------------------------
parame_.w.data_path_  = data_path_w;
parame_.dc.data_path_ = data_path_dc;
% ------------------------------------------------------------------------------
parame_.dc.data_path__= '../data-recovered/dc/';
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(parame_.w.epsilon,geome_.X,geome_.Y)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Permittivity ( )')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(parame_.w.sigma,geome_.X,geome_.Y)
colormap(rainbow2(1))
xlabel('Length (m)')
ylabel('Depth (m)')
title('Conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
