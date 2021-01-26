close all
clear
clc
% ------------------------------------------------------------------------------
% create subsurface models mat files 
% so we can make pictures of them in python.
% ------------------------------------------------------------------------------
n_models = 48;
path__   = '../data-set/test/';
% ------------------------------------------------------------------------------
load('../mat-file/discreti_test_.mat')
x    = discreti_test_.x;
z    = discreti_test_.z;
eps_ = discreti_test_.eps_;           % [ ]
sig_ = discreti_test_.sig_;           % [S/m]
lam_ = discreti_test_.lam_;           % [m]
I__  = discreti_test_.I__;           % [m]
% ------------------------------------------------------------------------------
n_models = size(I__,1);
% ------------------------------------------------------------------------------
fprintf(' \n');
for im=1:n_models;
  path_ = strcat(path__,num2str(im));
  path_ = strcat(path_,'/');
  % ----------------------------------------------------------------------------
  [epsi,sigm,~] = w_model_2l_(x,z,eps_,sig_,lam_,I__(im,:));
  % ----------------------------------------------------------------------------
  save( strcat(path_,'epsi.mat') ,'epsi')
  save( strcat(path_,'sigm.mat') ,'sigm')
  % ----------------------------------------------------------------------------
  if mod(im,fix(n_models*0.3)) == 1
    fprintf('   just finished subsurface models # %i\n',im)
  end
end
% ------------------------------------------------------------------------------
