% ------------------------------------------------------------------------------
% 
% MANY 2D synthetic forward models of GPR and ER data. 
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
% every nl, the index for the models jumps to another depth 
nl = me*ms*(me-1)*(ms-1);
% randomly choose ml_ consecutive depths
ml_= 3;
I__= zeros(n_models_2l,ml_);
for im=1:n_models_2l
  I_ = 0:(ml_-1);
  I_ = nl*I_ + randi(nl-1,1,numel(I_));
  I__(im,:) = I_;
end
I__= unique(I__,'rows');
n_models_test = size(I__,1);
% ------------------------------------------------------------------------------
fprintf('\n\n ---------------------------------------------------------------\n')
fprintf('   ok, the total number of 2 layer subsurface scenarios will be: %i\n',n_models_test)
fprintf('         ...so buckle up, buckaroo\n')
fprintf(' ---------------------------------------------------------------\n')
% ------------------------------------------------------------------------------
% set experiment
% ------------------------------------------------------------------------------
% - w
% this is where the sources-receivers are saved
data_path_w = '../mat-file/';
parame_.w.data_path_ = data_path_w;
% this will make all experiments have the same receivers
parame_.natu.epsilon_w = eps_;
% - dc
% this is where the sources-receivers are saved
data_path_dc = '../mat-file/';
parame_.dc.data_path_ = data_path_dc;
% ------------------------------------------------------------------------------
% gerjoii_ is born
% ------------------------------------------------------------------------------
% -- w --
gerjoii_ = struct;
% ------------------------------------------------------------------------------
% make sources-receivers
experim_w;
% make sure the number of sources (gerjoii_.w.ns) is set to 1 !! (for now)
experim_dc;
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
poolsize  = min([n_workers,n_models_test]);
parpool( poolsize );
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% ------------------------------------------------------------------------------
% print some funny stuff so user is amused
fprintf('\n\n----------->x< er forward models\n');
fprintf('  # of fwd models    : %i\n',gerjoii_.dc.n_exp);
fprintf('  # of src-rec pairs : %i\n\n',n_shots);
% ------------------------------------------------------------------------------
%                     run the forward models
% ------------------------------------------------------------------------------
% % do some cleaning first
% !rm -r ../data-set/test/* 
% !rm -r ../data-set/test/* 
% ------------------------------------------------------------------------------
tic;
% ------------------------------------------------------------------------------
for im=1:n_models_test
  % set path for saving data
  parame_.w.data_path_ml  = strcat('../data-set/test/',int2str(im),'/');
  parame_.dc.data_path_ml = strcat('../data-set/test/',int2str(im),'/');
  % build such directory
  mkdir(parame_.w.data_path_ml);
  % ----------------------------------------------------------------------------
  % get parameters from model # im
  [parame_.w.epsilon,parame_.w.sigma,~] = w_model_2l_(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
  % ----------------------------------------------------------------------------
  % dc
  parame_.dc.sigma  = parame_.w.sigma.';
  % expand to robin grid
  [parame_,finite_] = dc_robin(geome_,parame_,finite_);
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
  if mod(im,fix(n_models_test*0.1)) == 1
    fprintf(' doing fwd model # %i\n',im)
  end
  % ----------------------------------------------------------------------------
  w_natur_ml(geome_,parame_,finite_,gerjoii_,1);
  % ----------------------------------------------------------------------------
  load(strcat(parame_.dc.data_path_,'s_i_r_d_std_nodata.mat'));
  % ----------------------------------------------------------------------------
  dc_natur_ml(geome_,parame_,finite_,gerjoii_,s_i_r_d_std);
end
% ------------------------------------------------------------------------------
toc;
% ------------------------------------------------------------------------------
cd ../mat-file/
discreti_test_ = struct;
% ------------------------------------------------------------------------------
discreti_test_.t  = geome_.w.T*1e-9;  % [s]
discreti_test_.dt = geome_.w.dt;      % [s]
discreti_test_.fo = parame_.w.fo;     % [Hz]
discreti_test_.dx = geome_.dx;        % [m]
discreti_test_.x  = geome_.X;         % [m]
discreti_test_.z  = geome_.Y;         % [m]
discreti_test_.eps_ = eps_;           % [ ]
discreti_test_.sig_ = sig_;           % [S/m]
discreti_test_.lam_ = lam_;           % [m]
discreti_test_.I__  = I__;           
% ------------------------------------------------------------------------------
save('discreti_test_','discreti_test_')
cd ../scripts/
% ------------------------------------------------------------------------------