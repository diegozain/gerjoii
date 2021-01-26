close all
clear
clc
% ------------------------------------------------------------------------------
% create subsurface models mat files 
% so we can make pictures of them in python.
% ------------------------------------------------------------------------------
n_models = 48;
path__   = '../data-set/train/';
% ------------------------------------------------------------------------------
load('../mat-file/discreti_.mat')
x    = discreti_.x;
z    = discreti_.z;
eps_ = discreti_.eps_;           % [ ]
sig_ = discreti_.sig_;           % [S/m]
lam_ = discreti_.lam_;           % [m]
% ------------------------------------------------------------------------------
fprintf(' \n');
for im=1:n_models;
  path_ = strcat(path__,num2str(im));
  path_ = strcat(path_,'/');
  % ----------------------------------------------------------------------------
  [epsi,sigm] = w_model_2l(x,z,eps_,sig_,lam_,im);
  % ----------------------------------------------------------------------------
  save( strcat(path_,'epsi.mat') ,'epsi')
  save( strcat(path_,'sigm.mat') ,'sigm')
  % ----------------------------------------------------------------------------
  if mod(im,fix(n_models*0.3)) == 1
    fprintf('   just finished subsurface models # %i\n',im)
  end
end
% ------------------------------------------------------------------------------
