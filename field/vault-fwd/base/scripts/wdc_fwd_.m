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
pwd_ = pwd;
cd ../../
param_wdc;
cd(pwd_);
% ------------------------------------------------------------------------------
[parame_,finite_,geome_] = wdc_geom(parame_);
% ------------------------------------------------------------------------------
% truth
% ------------------------------------------------------------------------------
% permittivity
tmp_=load('../mat-file/epsi.mat');
% tmp_=load('../output/wdc/epsi.mat');
tmp_=tmp_.epsi;
parame_.natu.epsilon_w = tmp_;
% conductivity
tmp_=load('../mat-file/sigm.mat');
% tmp_=load('../output/wdc/sigm.mat');
tmp_=tmp_.sigm;
parame_.natu.sigma_w = tmp_;
parame_.natu.sigma_dc = parame_.natu.sigma_w.';
% ------------------------------------------------------------------------------
% w
parame_.w.epsilon = parame_.natu.epsilon_w;
parame_.w.sigma = parame_.natu.sigma_w;
% dc
parame_.dc.sigma = parame_.natu.sigma_dc;
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
% set paths and copy stuff
% ------------------------------------------------------------------------------
data_path_w_  = '../data-synth/w/';
data_path_dc_ = '../data-synth/dc/';
data_path_w   = '../data-recovered/w/';
data_path_dc  = '../data-recovered/dc/';
% bring stuff from those folders
copyfile(strcat(data_path_w_,'s_r.mat'),data_path_w);
copyfile(strcat(data_path_w_,'s_r_.mat'),data_path_w);
copyfile(strcat(data_path_dc_,'s_i_r_d_std_nodata.mat'),data_path_dc);
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
% -- dc --
% no. of electrodes and stuff
load(strcat(data_path_dc,'s_i_r_d_std_nodata.mat'));
gerjoii_.dc.n_exp = size( s_i_r_d_std , 2 );
src=[];
rec=[];
for is=1:gerjoii_.dc.n_exp
  rec_ = s_i_r_d_std{ is }{ 2 }(:,1:2);       % gives receivers.
  rec = [rec; rec_];
  src_ = s_i_r_d_std{ is }{ 1 }(1:2);         % gives source.
  src_ = repmat(src_,size(rec_,1),1);
  src = [src; src_];
end
src_rec_dc = [src;rec];
n_electrodes = numel(unique(src_rec_dc(:)));
n_shots = size(src_rec_dc,1);
% electrode spacing. [ms]
dr = 1;
% set real coordinates of electrodes (x,z) [m]
gerjoii_.dc.electr_real = [((dr*(0:n_electrodes-1))+2).',zeros(n_electrodes,1)];
gerjoii_.dc.n_electrodes = n_electrodes;
% ------------------------------------------------------------------------------
% parame_ is growing up
% ------------------------------------------------------------------------------
% % lo wavelength [m]
% parame_.w.lo = parame_.w.c/( sqrt( max(parame_.natu.epsilon_w(:)) ))/parame_.w.fo;
% % round to nearest-bigger decimal (e.g. 0.561924 -> 0.6)
% parame_.w.lo = ceil( parame_.w.lo/0.1 )*0.1;
% ------------------------------------------------------------------------------
% set paths
% ------------------------------------------------------------------------------
parame_.w.data_path_  = data_path_w;
parame_.dc.data_path_ = data_path_dc;
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
natur__w;
toc;
% --------------------------
% wave + noise
% --------------------------
% gerjoii_.w.noise.prcent = 0.1; % 0.05
% gerjoii_.w.noise.f_low = -1e+1;
% gerjoii_.w.noise.f_high = 1e+1;
% noise__w;
% --------------------------
% dc
% --------------------------
natur__dc;
% --------------------------
% dc + noise
% --------------------------
% gerjoii_.dc.noise.prcent = 0.1; % 0.05
% gerjoii_.dc.noise.n_vkluster = 3;
% noise__dc;
% ------------------------------------------------------------------------------
% save the discretization
% ------------------------------------------------------------------------------
cd ../mat-file/
x        =geome_.X;
z        =geome_.Y;
save('x','x')
save('z','z')
cd ../scripts/
% ------------------------------------------------------------------------------

