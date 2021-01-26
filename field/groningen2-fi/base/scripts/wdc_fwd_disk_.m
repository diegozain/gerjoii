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
data_path_w  = '../../data/w/';
% ------------------------------------------------------------------------------
% load parame_.w and parame_.dc
% ------------------------------------------------------------------------------
% load parame_.dc
load(strcat(data_path_dc,'parame_.mat'))
parame__ = parame_;
% load parame_.w
load(strcat(data_path_w,'parame_.mat'))
% incorporate parame_.dc to parame_.w
parame_.dc = parame__.dc;
% clean
clear parame__
% ------------------------------------------------------------------------------
% build geometry
% ------------------------------------------------------------------------------
param_w;
param_dc;
% ------------------------------------------------------------------------------
% truth
% ------------------------------------------------------------------------------
% permittivity
% tmp_=load('../output/wdc/epsi.mat');
tmp_=load('../../data/initial-guess/epsi.mat');
tmp_=tmp_.epsi;
parame_.natu.epsilon_w = tmp_;
% conductivity
% tmp_=load('../output/wdc/sigm.mat');
tmp_=load('../../data/initial-guess/sigm.mat');
tmp_=tmp_.sigm;
parame_.natu.sigma_w = tmp_;
parame_.natu.sigma_dc = parame_.natu.sigma_w.';
% ------------------------------------------------------------------------------
% % epsi and sigm from file
% % w
% parame_.w.epsilon = parame_.natu.epsilon_w;
% parame_.w.sigma   = parame_.natu.sigma_w;
% % dc
% parame_.dc.sigma  = parame_.natu.sigma_dc; 
% % expand to robin grid
% [parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
% epsi from file, sigm homogeneous
% -- w --
parame_.w.epsilon = parame_.natu.epsilon_w; 
parame_.w.sigma   = ones(geome_.m,geome_.n)*3e-2;
% -- dc --
parame_.dc.sigma  = ones(geome_.n,geome_.m)*3e-2;
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
% % epsi & sigm homogeneous
% % -- w --
% parame_.w.epsilon = ones(geome_.m,geome_.n)*1; 
% parame_.w.sigma   = ones(geome_.m,geome_.n)*0;
% % -- dc --
% parame_.dc.sigma  = ones(geome_.n,geome_.m)*1;
% % expand to robin grid
% [parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
% set paths and copy stuff
% ------------------------------------------------------------------------------
data_path_w_  = '../../data/w/';
data_path_dc_ = '../../data/dc/';
data_path_w__ = '../data-recovered/w/';
data_path_dc__= '../data-recovered/dc/';
% bring stuff from those folders
copyfile(strcat(data_path_w_,'s_r.mat'),data_path_w__);
copyfile(strcat(data_path_w_,'s_r_.mat'),data_path_w__);
copyfile(strcat(data_path_dc_,'s_i_r_d_std.mat'),data_path_dc__);
% ------------------------------------------------------------------------------
% gerjoii_ is born
% ------------------------------------------------------------------------------
% -- w --
gerjoii_ = struct;
% no. of sources
load(strcat(data_path_w__,'s_r.mat'));
gerjoii_.w.ns = size(s_r,1);
% mute?
gerjoii_.w.MUTE = 'no_MUTE';
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
parame_.w.data_path_  = data_path_w_;
parame_.dc.data_path_ = data_path_dc_;
parame_.w.data_path__ = data_path_w__;
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
n_workers = load('../tmp/workers_fwd.txt');
poolsize  = min([n_workers,gerjoii_.w.ns]); % gerjoii_.w.ns
parpool( poolsize );
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% --------------------------
% wave
% --------------------------
domain_check_w;
tic;
natur__w_disk;
toc;
% --------------------------
% dc
% --------------------------
% natur__dc;
% -------------------------
%
% parallel kill 
%
% -------------------------
delete(gcp('nocreate'));

