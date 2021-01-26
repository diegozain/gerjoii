% ------------------------------------------------------------------------------
% 
% MANY 2D synthetic forward models of GPR data. 
% this is for machine learning. only 1D subsurface models.
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
[parame_,finite_,geome_] = wdc_geom(parame_);
% ------------------------------------------------------------------------------
% set permittivities, conductivities and depths of second layer
% ------------------------------------------------------------------------------
model_param;
% ------------------------------------------------------------------------------
fprintf('\n\n ---------------------------------------------------------------\n')
fprintf('   ok, the total number of 2 layer subsurface scenarios will be: %i\n',n_models_2l)
fprintf('         ...so buckle up, buckaroo\n')
fprintf(' ---------------------------------------------------------------\n')
% ------------------------------------------------------------------------------
% set experiment
% ------------------------------------------------------------------------------
% this is where the sources-receivers are saved
data_path_w = '../mat-file/';
parame_.w.data_path_ = data_path_w;
% this will make all experiments have the same receivers
parame_.natu.epsilon_w = eps_;
% ------------------------------------------------------------------------------
% gerjoii_ is born
% ------------------------------------------------------------------------------
% -- w --
gerjoii_ = struct;
% ------------------------------------------------------------------------------
% make sources-receivers
experim_w;
% make sure the number of sources (gerjoii_.w.ns) is set to 1 !! (for now)
% ------------------------------------------------------------------------------
fprintf('\n the size of the data (time by receivers) is: %i by  %i\n\n',numel(geome_.w.T),size(s_r_{1,2},1))
% ------------------------------------------------------------------------------
%
%                       generate synthetic data
%
% ------------------------------------------------------------------------------
fprintf('\n --------------------- synthetic nature ----------------------\n\n');
% -------------------------
%
% parallel set up 
%
% -------------------------
parpools = gcp('nocreate');
if ~isempty(parpools)
  delete(gcp('nocreate'));
end
n_workers = load('../tmp/workers.txt');
poolsize  = min([n_workers,n_models_2l]);
parpool( poolsize );
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% ------------------------------------------------------------------------------
%                     run the forward models
% ------------------------------------------------------------------------------
% % do some cleaning first
% !rm -r ../data-set/test/* 
% !rm -r ../data-set/train/* 
% ------------------------------------------------------------------------------
tic;
% ------------------------------------------------------------------------------
parfor im=1:n_models_2l
  % set path for saving data
  parame_.w.data_path_ml  = strcat('../data-set/train/',int2str(im),'/');
  % build such directory
  mkdir(parame_.w.data_path_ml);
  % get parameters from model # im
  % ----------------------------------------------------------------------------
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l(geome_.X,geome_.Y,eps_,sig_,lam_,im);
  % ----------------------------------------------------------------------------
  % run the fwd model
  % ----------------------------------------------------------------------------
  % complete parame_
  parame_.w.pis = finite_.w.pis;
  parame_.w.pie = finite_.w.pie;
  parame_.w.pjs = finite_.w.pjs;
  parame_.w.pje = finite_.w.pje;
  parame_.w.t   = geome_.w.T*1e-9;
  % ----------------------------------------------------------------------------
  if mod(im,fix(n_models_2l*0.1)) == 1
    fprintf(' doing fwd model # %i\n',im)
  end
  % ----------------------------------------------------------------------------
  w_natur_ml(geome_,parame_,finite_,gerjoii_,1);
end
% ------------------------------------------------------------------------------
toc;
% ------------------------------------------------------------------------------
cd ../mat-file/
discreti_ = struct;
% ------------------------------------------------------------------------------
discreti_.t  = geome_.w.T*1e-9;  % [s]
discreti_.dt = geome_.w.dt;      % [s]
discreti_.fo = parame_.w.fo;     % [Hz]
discreti_.dx = geome_.dx;        % [m]
discreti_.x  = geome_.X;         % [m]
discreti_.z  = geome_.Y;         % [m]
discreti_.eps_ = eps_;           % [ ]
discreti_.sig_ = sig_;           % [S/m]
discreti_.lam_ = lam_;           % [m]
% ------------------------------------------------------------------------------
save('discreti_','discreti_')
cd ../scripts/
% ------------------------------------------------------------------------------