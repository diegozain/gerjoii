% ------------------------------------------------------------------------------
% 
% 2d synthetic fwd model of GPR and ER
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
% meta-data is in ../../data/[w,dc]
% ------------------------------------------------------------------------------
data_path_dc = '../../data/dc/';
% ------------------------------------------------------------------------------
% load parame_.dc
% ------------------------------------------------------------------------------
% load parame_.dc
load(strcat(data_path_dc,'parame_.mat'))
% ------------------------------------------------------------------------------
% build geometry
% ------------------------------------------------------------------------------
param_dc;
% ------------------------------------------------------------------------------
% truth
% ------------------------------------------------------------------------------
% conductivity
tmp_=load('../output/dc/sigm.mat');
% tmp_=load('../../data/initial-guess/sigm.mat');
tmp_=tmp_.sigm;
parame_.natu.sigma_w = tmp_;
parame_.natu.sigma_dc = parame_.natu.sigma_w.';
% ------------------------------------------------------------------------------
% dc
parame_.dc.sigma  = parame_.natu.sigma_dc; 
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
%                             
% w
% parame_.w.epsilon = 5*ones(size(parame_.natu.epsilon_w));
% parame_.w.sigma   = 1e-3*ones(size(parame_.natu.sigma_w));
% --                  right-angle geometry
% reflector_iz = binning(geome_.Y,1);
% parame_.w.epsilon(reflector_iz:end,:) = 20;
% parame_.w.sigma(reflector_iz:end,:) = 6e+3;
% --
% parame_.dc.sigma = parame_.w.sigma.';
% % expand to robin grid
% [parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
% set paths and copy stuff
% ------------------------------------------------------------------------------
data_path_dc_ = '../../data/dc/';
data_path_dc__= '../data-recovered/dc/';
% bring stuff from those folders
copyfile(strcat(data_path_dc_,'s_i_r_d_std.mat'),data_path_dc__);
% ------------------------------------------------------------------------------
% gerjoii_ is born
% ------------------------------------------------------------------------------
% -- dc --
% load(strcat(data_path_dc__,'s_i_r_d_std.mat'));
% set real coordinates of electrodes (x,z) [m]
% no. of electrodes and stuff
gerjoii_.dc.electr_real  = parame_.dc.electr_real;
gerjoii_.dc.n_electrodes = parame_.dc.n_electrodes;
gerjoii_.dc.n_exp        = parame_.dc.n_exp;
% ------------------------------------------------------------------------------
% parame_ is growing up
% ------------------------------------------------------------------------------
% set paths
parame_.dc.data_path_ = data_path_dc_;
parame_.dc.data_path__= data_path_dc__;
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
poolsize  = min([n_workers,20]); 
parpool( poolsize );
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% --------------------------
% dc
% --------------------------
natur__dc;
% -------------------------
%
% parallel kill 
%
% -------------------------
delete(gcp('nocreate'));
% ------------------------------------------------------------------------------

