% ------------------------------------------------------------------------------
% 
% 2d synthetic inversion of conductivity using GPR and ER data
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
[parame_,finite_,geome_] = wdc_geom(parame_);
% ------------------------------------------------------------------------------
% truth
% ------------------------------------------------------------------------------
% permittivity
tmp_=load('../../image2mat/nature-synth/mat-file/epsi.mat');
% tmp_=load('../output/w/epsi.mat');
tmp_=tmp_.epsi;
parame_.natu.epsilon_w = tmp_;
% conductivity
tmp_=load('../../image2mat/nature-synth/mat-file/sigm.mat');
% tmp_=load('../output/w/sigm.mat');
tmp_=tmp_.sigm;
parame_.natu.sigma_w = tmp_;
% ------------------------------------------------------------------------------
% w
parame_.w.epsilon = parame_.natu.epsilon_w;
parame_.w.sigma = parame_.natu.sigma_w;
% ------------------------------------------------------------------------------
% set paths and copy stuff
% ------------------------------------------------------------------------------
data_path_w_  = '../data-synth/w/';
data_path_w  = '../data-recovered/w/';
% bring stuff from those folders
copyfile(strcat(data_path_w_,'s_r.mat'),data_path_w);
copyfile(strcat(data_path_w_,'s_r_.mat'),data_path_w);
% ------------------------------------------------------------------------------
% gerjoii_ is born
% ------------------------------------------------------------------------------
% -- w --
gerjoii_ = struct;
% no. of sources
load(strcat(data_path_w,'s_r.mat'));
gerjoii_.w.ns = size(s_r,1);
% mute?
gerjoii_.w.MUTE = 'no_MUTE';
% ------------------------------------------------------------------------------
% parame_ is growing up
% ------------------------------------------------------------------------------
% % lo wavelength [m]
% parame_.w.lo = parame_.w.c/( sqrt( max(parame_.natu.epsilon_w(:)) ))/parame_.w.fo;
% % round to nearest-bigger decimal (e.g. 0.561924 -> 0.6)
% parame_.w.lo = ceil( parame_.w.lo/0.1 )*0.1;
% set paths
parame_.w.data_path_  = data_path_w;
% ------------------------------------------------------------------------------
% choose parameters for saving the wavefield
% ------------------------------------------------------------------------------
gerjoii_.w.ns = 1;
parame_.w.parallel_memory = 'wavefield/u/';
gerjoii_.w.chunks = [1e+3,1e+3,1e+3,1e+3,1e+3];
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
poolsize  = min([n_workers,gerjoii_.w.ns]); % gerjoii_.w.ns
parpool( poolsize );
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% --------------------------
% wave
% --------------------------
tic;
natur__w_;
toc;
% --------------------------
% wave + noise
% --------------------------
% gerjoii_.w.noise.prcent = 0.1; % 0.05
% gerjoii_.w.noise.f_low = -1e+1;
% gerjoii_.w.noise.f_high = 1e+1;
% noise__w;


