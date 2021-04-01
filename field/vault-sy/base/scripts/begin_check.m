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
param_wdc;
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
% save x and z so you can run the image2gerjoii stuff
x=geome_.X;
z=geome_.Y;
save('../../image2mat/nature-synth/mat-file/x.mat','x')
save('../../image2mat/nature-synth/mat-file/z.mat','z')
