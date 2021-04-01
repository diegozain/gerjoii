% ------------------------------------------------------------------------------
% 
% 2.5d synthetic inversion of conductivity using ER data
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
dx=0.05;
[parame_,finite_,geome_] = wdc_geom_(parame_,dx);
% ------------------------------------------------------------------------------
% overwrite eps and sig with a cute box in the middle.
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be declared in param_wdc.m
% ------------------------------------------------------------------------------
% permittivity
tmp_=load('../../image2mat/nature-synth/mat-file/epsi.mat');
tmp_=tmp_.epsi;
parame_.natu.epsilon_w= tmp_;
% conductivity
tmp_=load('../../image2mat/nature-synth/mat-file/sigm.mat');
tmp_=tmp_.sigm;
parame_.natu.sigma_w  = tmp_;
parame_.natu.sigma_dc = parame_.natu.sigma_w.';
% ------------------------------------------------------------------------------
% box_ix_  = binning(geome_.X,9.5);
% box_ix__ = binning(geome_.X,10.5);
% box_iz_  = binning(geome_.Y,1.5);
% box_iz__ = binning(geome_.Y,2.5);
% reflector_iz = binning(geome_.Y,3.5);
% % conductivity
% parame_.natu.sigma_w = ones(size(parame_.natu.sigma_w))*5e-3; % 5e-3
% parame_.natu.sigma_w(box_iz_:box_iz__,box_ix_:box_ix__) = 10e-3; % 20e-3;
% parame_.natu.sigma_dc = parame_.natu.sigma_w.';
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
experim_wdc;
fprintf('\n --------------------- synthetic nature ----------------------\n\n');
% ------------------------------------------------------------------------------
%
% parallel set up 
%
% ------------------------------------------------------------------------------
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
% ------------------------------------------------------------------------------
% dc 2.5d conversion stuff
% ------------------------------------------------------------------------------
parame_.dc.data_path_ = '../data-synth/dc/';
parame_.dc.data_path__= '../data-recovered/dc/';
parame_.dc.n_shots    = gerjoii_.dc.n_exp;
name = strcat(parame_.dc.data_path_,'s_i_r_d_std','.mat');
save( name , 's_i_r_d_std' );
finite_.dx = geome_.dx;
% ------------------------------------------------------------------------------
kk_dc;
% ------------------------------------------------------------------------------
% dc
% ------------------------------------------------------------------------------
natur__dc_;
name = strcat(parame_.dc.data_path_,'s_i_r_d_std','.mat');
save( name , 's_i_r_d_std' );
% ------------------------------------------------------------------------------
% dc 2d 
% ------------------------------------------------------------------------------
% natur__dc;
% ------------------------------------------------------------------------------
% dc + noise
% ------------------------------------------------------------------------------
% gerjoii_.dc.noise.prcent     = 0.1; % 0.05
% gerjoii_.dc.noise.n_vkluster = 3;
% noise__dc;
% ------------------------------------------------------------------------------
% remove negative apparent resistivities
% ------------------------------------------------------------------------------
load(strcat(parame_.dc.data_path_,'s_i_r_d_std.mat'));
load(strcat(parame_.dc.data_path_,'kfactor_.mat'));
[src,rec,cur,d_o,std_,ns] = dc_gerjoii2iris_(s_i_r_d_std);
rhoas   = d_o .* kfactor_;
iremove = find(rhoas<0);
if numel(iremove)>0
  fprintf('             oh no...  you have negative apparent resistivities\n')
  fprintf('             we gonna remove them...\n')
  % ----------------------------------------------------------------------------
  src(iremove,:) = [];
  rec(iremove,:) = [];
  cur(iremove) = [];
  d_o(iremove) = [];
  std_(iremove)= [];
  s_i_r_d_std = dc_iris2gerjoii( src,cur,rec,d_o,std_ );
  % ----------------------------------------------------------------------------
  name = strcat(parame_.dc.data_path_,'s_i_r_d_std','.mat');
  save( name , 's_i_r_d_std' );
  % ----------------------------------------------------------------------------
  gerjoii_.dc.n_exp = numel(s_i_r_d_std);
  parame_.dc.n_shots= numel(d_o);
  % ----------------------------------------------------------------------------
  clear src rec cur d_o std_;
  % ----------------------------------------------------------------------------
  kk_dc;
end
% ------------------------------------------------------------------------------
% load regularization parameters
% ------------------------------------------------------------------------------
P_inv_dc = load('../../inv-param/P_inv_dc.txt');
[n_inversions,n_invparam] = size(P_inv_dc);
% get project (folder) number
pwd_=pwd;
if strcmp(pwd_(end-10),'/')
  project_num = str2num( pwd_(end-8) );
elseif strcmp(pwd_(end-11),'/')
  project_num = str2num( pwd_((end-9):(end-8)) );
end
% choose said project number
p_inv = P_inv_dc(project_num,:);
% ------------------------------------------------------------------------------
% assign
% ------------------------------------------------------------------------------
% number of iterations
tol_iter = p_inv(1);
% tolerance for error
tol_error= p_inv(2);
% initial guess
sig_ini = p_inv(3);  % S/m
% background conductivity
sig_bg  = p_inv(4);  % S/m
% max sig value permitted
sig_max_= p_inv(5);  % S/m
% min sig value permitted
sig_min_= p_inv(6);  % S/m
% coefficient for background conductivity
beta_dc  = p_inv(7);
% momentum
momentum = p_inv(8);
% kk-smoothing factor
kk_factor= p_inv(9);
% ------------------------------------------------------------------------------
% use pica or parabola?
% for parabola comment this line:
gerjoii_.dc.pica_me = 1;
% ------------------------------------------------------------------------------
% use weird step size average in dc_update2_5d__?
% pica does this automatically.
% If parabola is used and you want to get weird,
% uncomment this line:
gerjoii_.dc.weird_me = 1;
% ------------------------------------------------------------------------------
% save?
% to not save comment this line:
gerjoii_.dc.save_dsigm = 1;
gerjoii_.dc.data_pathsigs_='sigs-dc/';
% ------------------------------------------------------------------------------
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be same as in parame_w
% ------------------------------------------------------------------------------
% load('../../image2mat/nature-synth/initial-guess/sigm_smooth5.mat');
% load('../../image2mat/nature-synth/initial-guess/sigm_smooth7.mat');
% load('../../image2mat/nature-synth/initial-guess/sigm_init.mat');
% -- dc --
% parame_.dc.sigma  = sigm.';
parame_.dc.sigma  = ones(geome_.n,geome_.m)*sig_ini;
parame_.dc.sigma_o= ones(geome_.n,geome_.m)*sig_bg;
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
%
%                                     image
%
% ------------------------------------------------------------------------------
fprintf('\n ------------------------ imaging ----------------------------\n\n');
% -------------------------
%
% dc 
%
% -------------------------
% ..............
% regularize
% ..............
% choose filter bandwidth in units of [1/m],
% smaller ax,az --> only lower freqs survive
% ax=1/parame_.w.lo; az=ax; % [1/m]
% ax = 1/1.6; az = 1/1.6; % [1/m]
ax = 1/(parame_.dc.dr*kk_factor); az = 1/(parame_.dc.dr*kk_factor); % [1/m]
fprintf('\ndc kk-filter:   ax=%2.2d, az=%2.2d [1/m]\n',ax,az);
% turn to discrete coordinates,
% (nax = nkx*ax*dx, but nkx is multiplied in image_gaussian.m)
ax=ax*geome_.dx; az=az*geome_.dy;
gerjoii_.dc.regu.ax = ax;
gerjoii_.dc.regu.az = az;
gerjoii_.dc.regu.beta_ = beta_dc;
% for momentum
gerjoii_.dc.dsigma_ = zeros(size(parame_.dc.sigma));
gerjoii_.dc.momentum = momentum;
% ..............
% optimize
% ..............
% choose objective function
% 'L2' 'env_L2' 'env_L22' 'env_LOG'
gerjoii_.dc.obj_FNC = 'L2';
disp(['objective function is ',gerjoii_.dc.obj_FNC])
% ..............
% step size
% ..............
gerjoii_.dc.k_s = [1e-10 1e+3]; % [1e-7 1e+5]
fprintf('\ndc pica k_s somewhere between %2.2d and %2.2d\n',...
gerjoii_.dc.k_s(1),gerjoii_.dc.k_s(2));
% percentage of bound k_s to try for 3 point parabola
gerjoii_.dc.kprct_  = 5e-4; % 1e-3
gerjoii_.dc.kprct__ = 0.5;
% -----------------------
% automatic k_s finder
% -----------------------
% conductivity
% sig_max_ = 1/parame_.dc.rho_min;
% sig_min_ = 1/parame_.dc.rho_max;
prct_s_=0.05; prct_s=0.05;
gerjoii_.dc.regu.sig_max_ = sig_max_+prct_s_*sig_max_;
gerjoii_.dc.regu.sig_min_ = sig_min_-prct_s*sig_min_;
clear sig_max_ sig_min_ prct_s prct_s_;
% ---------------------------------------------------------------------------
%
% dc :: inversion routine
%
% ---------------------------------------------------------------------------
gerjoii_.dc.tol_iter  = tol_iter;
gerjoii_.dc.tol_error = tol_error;
% ------------------------------------------------------------------------------
%                         record for linking?
% ------------------------------------------------------------------------------
% path to record is tmp/
gerjoii_.linker.yn = 'y';
if strcmp(gerjoii_.linker.yn,'y')
  gerjoii_.linker.path_ = '../tmp/';
  gerjoii_.dc.E = [];
  gerjoii_.dc.iter = 0;
  gerjoii_.dc.v_currs=zeros(geome_.n,geome_.m);
  % ----------------------------------
  % global & internal iteration clock
  % ----------------------------------
  % global clock
  gerjoii_.linker.tol_iter = gerjoii_.dc.tol_iter;
  dlmwrite(strcat(gerjoii_.linker.path_,'tol-iter.txt'),gerjoii_.linker.tol_iter);
  % internal clock
  tol_iter_ = load('../tmp/tol_iter_.txt');
  gerjoii_.dc.tol_iter_ = tol_iter_;
  gerjoii_.dc.tol_iter = gerjoii_.dc.tol_iter_;
end
% ------------------------------------------------------------------------------
%
% This is the main routine of the inversion
%
% ------------------------------------------------------------------------------
fprintf('\n image conductivity for %i iterations \n\n',gerjoii_.dc.tol_iter);
tic;
% 2d
% [parame_,gerjoii_] = dc_image_2d__(geome_,parame_,finite_,gerjoii_);
% [parame_,gerjoii_] = dc_image_2d__B(geome_,parame_,finite_,gerjoii_);
% 2.5d
[parame_,gerjoii_] = dc_image2_5d__(geome_,parame_,finite_,gerjoii_);
toc;
% -------------------------
%
% parallel kill 
%
% -------------------------
delete(gcp('nocreate'));
% ------------------------------------------------------------------------------
% save the data
% ------------------------------------------------------------------------------
% sigm      - recovered conductivity
% dsigm_dc  - last update for conductivity (just er)
% x         - x discretized vector
% z         - z discretized vector
% E         - objective function values in iterations
cd ../output/dc/
sigm     =parame_.dc.sigma.';
dsigm_dc =gerjoii_.dc.dsigma.';
x        =geome_.X;
z        =geome_.Y;
E        =gerjoii_.dc.E;
v_currs  =gerjoii_.dc.v_currs.';
save('sigm','sigm')
save('dsigm_dc','dsigm_dc')
save('E','E')
save('x','x')
save('z','z')
save('p_inv','p_inv')
save('v_currs','v_currs')
cd ../../scripts/
% ------------------------------------------------------------------------------
% for linking
% ------------------------------------------------------------------------------
% path to record is ../tmp/
if strcmp(gerjoii_.linker.yn,'y')
  % save gerjoii_, parame_, geome_ & finite_
  save(strcat(gerjoii_.linker.path_,'gerjoii_'),'gerjoii_');
  save(strcat(gerjoii_.linker.path_,'parame_'),'parame_');
  save(strcat(gerjoii_.linker.path_,'geome_'),'geome_');
  save(strcat(gerjoii_.linker.path_,'finite_'),'finite_');
  % save iterations in txt so an outside cron shell can access them
  dlmwrite(strcat(gerjoii_.linker.path_,'tol-iter.txt'),gerjoii_.linker.tol_iter);
  dlmwrite(strcat(gerjoii_.linker.path_,'iter.txt'),gerjoii_.dc.iter);
end
%%}



