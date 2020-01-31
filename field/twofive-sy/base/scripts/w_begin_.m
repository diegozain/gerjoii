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
% overwrite eps and sig with a cute box in the middle.
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be declared in param_wdc.m
% ------------------------------------------------------------------------------
% permittivity
tmp_=load('../../image2mat/nature-synth/mat-file/epsi.mat');
tmp_=tmp_.epsi;
parame_.natu.epsilon_w = tmp_;
% conductivity
tmp_=load('../../image2mat/nature-synth/mat-file/sigm.mat');
tmp_=tmp_.sigm;
parame_.natu.sigma_w = tmp_;
parame_.natu.sigma_dc = parame_.natu.sigma_w.';
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
% radargram and wavelets path
parame_.w.data_path_ = '../data-synth/w/';
tic;
natur__w;
toc;
% --------------------------
% wave + noise
% --------------------------
gerjoii_.w.noise.prcent = 0.1; % 0.05
gerjoii_.w.noise.f_low = -1e+1;
gerjoii_.w.noise.f_high = 1e+1;
noise__w;
% ------------------------------------------------------------------------------
%
%                       image
%
% ------------------------------------------------------------------------------
fprintf('\n ------------------------ imaging ----------------------------\n\n');
% ------------------------------------------------------------------------------
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be same as in parame_w
% ------------------------------------------------------------------------------
% conductivity: smooth
% load('../../image2mat/nature-synth/initial-guess/sigm_smooth.mat');
% --
% permittivity: smooth
% conductivity: interpolated from above permittivity (to match boundaries)
% load('../../image2mat/nature-synth/initial-guess/sigm_smooth5.mat');
% load('../../image2mat/nature-synth/initial-guess/epsi_smooth.mat');
% --
% permittivity: reomove top layer, then smooth, then insert top layer.
% conductivity: interpolated from above permittivity (to match boundaries)
% load('../../image2mat/nature-synth/initial-guess/sigm_smooth6.mat');
% load('../../image2mat/nature-synth/initial-guess/epsi_smooth6.mat');
% --
% permittivity: reomove top layer, then smooth, then insert top layer, then smooth.
% conductivity: interpolated from above permittivity (to match boundaries)
load('../../image2mat/nature-synth/initial-guess/sigm_smooth7.mat');
load('../../image2mat/nature-synth/initial-guess/epsi_smooth7.mat');
% --
% permittivity: reomove top layer, then smooth, then reduce magnitude, then insert top layer.
% conductivity: interpolated from above permittivity (to match boundaries)
% load('../../image2mat/nature-synth/initial-guess/sigm_smooth8.mat');
% load('../../image2mat/nature-synth/initial-guess/epsi_smooth8.mat');
% % -- dc --
% parame_.dc.sigma  = sigm.';
% % parame_.dc.sigma  = ones(geome_.n,geome_.m)*sig_ini;
% parame_.dc.sigma_o= ones(geome_.n,geome_.m)*sig_bg;
% % expand to robin grid
% [parame_,finite_] = dc_robin(geome_,parame_,finite_);
% -- w --
% parame_.w.epsilon = ones(geome_.m,geome_.n)*eps_ini;
parame_.w.epsilon = epsi; 
% parame_.w.sigma   = ones(geome_.m,geome_.n)*sig_ini;
parame_.w.sigma   = sigm;
% parame_.w.sigma   = parame_.natu.sigma_w;
% ------------------------------------------------------------------------------
% clean
clear sigm
clear epsi
% ------------------------------------------------------------------------------
%
%                     wave & dc :: inversion routine
%
% ------------------------------------------------------------------------------
% load P_inv.txt with all parameters needed for this thing to work.
% this P_inv.txt has parameters for a single inversion in each row.
% the rows are numbered like the folders this thing is in.
P_inv = load('../../inv-param/P_inv_w.txt');
[n_inversions,n_invparam] = size(P_inv);
% get project (folder) number
pwd_=pwd;
if strcmp(pwd_(end-10),'/')
  project_num = str2num( pwd_(end-8) );
elseif strcmp(pwd_(end-11),'/')
  project_num = str2num( pwd_((end-9):(end-8)) );
end
p_inv = P_inv(project_num,:);
% -----------------------
% stop main while criteria
% -----------------------
gerjoii_.w.tol_iter  = p_inv(1);
gerjoii_.w.tol_error = p_inv(2);
% -----------------------
% step size
% -----------------------
nparabo     = p_inv(3);
% -----------------------
% smoothing
% -----------------------
kk_factor_w = p_inv(4);
% -----------------------
% we gonna spice things up 
% with the objective fncs
% -----------------------
gerjoii_.w.obj_FNCs    = {'L2','env_L2'};
gerjoii_.w.g_e_weights = [1,p_inv(5)]; % 1,0.25 (try 1e-6. was 1e-4)
gerjoii_.w.g_s_weights = [1,p_inv(6)]; % 1,0.25
% -----------------------
% save?
% -----------------------
% save permittivity gradients for last iteration
gerjoii_.w.save_ges     ='NO';
gerjoii_.w.data_pathges_='ges/';
gerjoii_.w.save_depsi   ='YES';
gerjoii_.w.data_patheps_='depsis_w/';
% save conductivity gradients for last iteration
gerjoii_.w.save_dsigm   ='YES';
gerjoii_.w.data_pathsig_='dsigm_w/';
% -------------------------
%
% wave 
%
% -------------------------
% ..............
% regularize
% ..............
% choose filter bandwidth in units of [1/m],
% smaller ax,az --> only lower freqs survive
% ax=1/(parame_.w.lo*1.5); az=ax;
ax=1/(parame_.w.lo*kk_factor_w); az=ax;
% ax=20; az=ax;
fprintf('\nwave kk-filter: ax=%2.2d, az=%2.2d [1/m]\n',ax,az);
% turn to discrete coordinates,
% (nax = nkx*ax*dx, but nkx is multiplied in image_gaussian.m)
ax=ax*geome_.dx;az=az*geome_.dy;
gerjoii_.w.regu.ax = ax;
gerjoii_.w.regu.az = az;
% for momentum
gerjoii_.w.depsilon_ = zeros(size(parame_.w.epsilon));
gerjoii_.w.dsigma_   = zeros(size(parame_.w.sigma));
% -----------
% frequencies
% -----------
% frequency scheme (this is a low-pass high bound)
gerjoii_.w.regu.f__ = 0.7*1e+9; % 0.7*1e+9; % [Hz]
gerjoii_.w.regu.f_ = -0.7*1e+9; % -0.7*1e+9; % [Hz]
% record hightest frequency
parame_.w.f_high = gerjoii_.w.regu.f__;
% wanna use frequency scheme??
gerjoii_.w.regu.f_yesno = 'NO';
% frequency for source damping:
if strcmp(gerjoii_.w.regu.f_yesno,'YES')
  gerjoii_.w.regu.f_tol = 1e-3;
  gerjoii_.w.regu.fo = parame_.w.fo;            % [Hz]
  gerjoii_.w.regu.Fpi = 0;
  gerjoii_.w.regu.Fsi = 0;
  gerjoii_.w.regu.p_eps = 1e-7;
  gerjoii_.w.regu.p_sig = 1e-5;
else
  % = parame_.w.fo            --> no funny business
  gerjoii_.w.regu.fo = parame_.w.fo;            % [Hz]
end
% ..............
% optimize
% ..............
% choose objective function
% 'L2' 'env_L2' 'env_L22' 'env_LOG'
gerjoii_.w.obj_FNC = 'L2';
disp(['objective function is ',gerjoii_.w.obj_FNC])
% ..............
% step size
% ..............
gerjoii_.w.k_e = [1e-8 1e+2];
gerjoii_.w.k_s = [1e-7 1e+5];
fprintf('\nwave pica k_e somewhere between %2.2d and %2.2d',...
        gerjoii_.w.k_e(1),gerjoii_.w.k_e(2));
fprintf('\nwave pica k_s somewhere between %2.2d and %2.2d\n',...
        gerjoii_.w.k_s(1),gerjoii_.w.k_s(2));
% number of points for parabola. =2 is 3pt parabola, =3 is 4pt parabola, etc.
gerjoii_.w.nparabo = nparabo;
% percentage of bound k_e to try for 3 point parabola
gerjoii_.w.keprct_  = 0.001; % 0.05; 0.1;; 0.001
gerjoii_.w.keprct__ = 0.95;  % 0.5; 0.95
% percentage of bound k_s to try for 3 point parabola
gerjoii_.w.ksprct_  = 1e-2; % 0.01 c4, 0.1 c1, 0.95 c2, 0.001 c5, 0.95 c6, 1 c7, 1e-5 c8
gerjoii_.w.ksprct__ = 1;
% -----------------------
% automatic k_e(s) finder
% -----------------------
% permittivity
eps_max_ = 10; % max(parame_.natu.epsilon_w(:));
eps_min_ = 1; % min(parame_.natu.epsilon_w(:));
prct_e_=0.05; prct_e=0.05;
gerjoii_.w.regu.eps_max_ = eps_max_-prct_e_*eps_max_;
gerjoii_.w.regu.eps_min_ = eps_min_+prct_e*eps_min_;
% conductivity
sig_max_ = max(parame_.natu.sigma_w(:));
sig_min_ = min(parame_.natu.sigma_w(:));
prct_s_=0.05; prct_s=0.05; % 0.05,0.05.
gerjoii_.w.regu.sig_max_ = sig_max_+prct_s_*sig_max_;
gerjoii_.w.regu.sig_min_ = sig_min_-prct_s*sig_min_;
clear eps_max_ eps_min_ sig_max_ sig_min_ prct_e prct_s prct_e_ prct_s_;
% ------------------------------------------------------------------------------
%                         record for linking?
% ------------------------------------------------------------------------------
% path to record is tmp/
gerjoii_.linker.yn = 'y';
if strcmp(gerjoii_.linker.yn,'y')
  gerjoii_.linker.path_ = '../tmp/';
  gerjoii_.w.E = [];
  gerjoii_.w.iter = 0;
  gerjoii_.w.regu.dE__ = 0;
  % ----------------------------------
  % global & internal iteration clock
  % ----------------------------------
  % global clock
  gerjoii_.linker.tol_iter = gerjoii_.w.tol_iter;
  dlmwrite(strcat(gerjoii_.linker.path_,'tol-iter.txt'),gerjoii_.linker.tol_iter);
  % internal clock
  tol_iter_ = load('../tmp/tol_iter_.txt');
  gerjoii_.w.tol_iter_ = tol_iter_;
  gerjoii_.w.tol_iter = gerjoii_.w.tol_iter_;
end
% ------------------------------------------------------------------------------
%
% This is the main routine of the inversion
%
% ------------------------------------------------------------------------------
fprintf('\n\n image permittivity and conductivity for %i iterations \n\n',...
gerjoii_.w.tol_iter);
tic;
if strcmp(gerjoii_.w.regu.f_yesno,'YES')
  [parame_,gerjoii_] = w_image_es_f(geome_,parame_,finite_,gerjoii_);
elseif strcmp(gerjoii_.w.regu.f_yesno,'NO')
  if gerjoii_.w.g_e_weights(2) == 0
    [parame_,gerjoii_] = w_image_es(geome_,parame_,finite_,gerjoii_);
    % gerjoii_.w.dsigma = zeros(size(parame_.w.sigma));
    % [parame_,gerjoii_] = w_image_e(geome_,parame_,finite_,gerjoii_);
  else 
    [parame_,gerjoii_] = w_imageOBJ_es(geome_,parame_,finite_,gerjoii_);
  end
end
toc;
% -------------------------
%
% parallel kill 
%
% -------------------------
delete(gcp('nocreate'));
% -------------------------
% purge
% -------------------------
% if you want to clean all the saved data,
% delete ../data-synth/w/*.mat;
% delete ../data-synth/dc/*.mat;
% ------------------------------------------------------------------------------
% save the data
% ------------------------------------------------------------------------------
% epsi      - recovered permittivity
% sigm      - recovered conductivity
% depsi     - last update for permittivity
% dsigm_w   - last update for conductivity (just gpr)
% x         - x discretized vector
% z         - z discretized vector
% E         - objective function values in iterations
cd ../output/w/
epsi     =parame_.w.epsilon;
sigm     =parame_.w.sigma;
depsi    =gerjoii_.w.depsilon;
dsigm_w  =gerjoii_.w.dsigma;
x        =geome_.X;
z        =geome_.Y;
E        =gerjoii_.w.E;
save('epsi','epsi')
save('sigm','sigm')
save('depsi','depsi')
save('dsigm_w','dsigm_w')
save('E','E')
save('x','x')
save('z','z')
save('p_inv','p_inv')
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
  dlmwrite(strcat(gerjoii_.linker.path_,'iter.txt'),gerjoii_.w.iter);
end




