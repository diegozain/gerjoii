% ------------------------------------------------------------------------------
% 
% 2.5d synthetic inversion of conductivity using GPR data.
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
% data is in ../../data/[w,dc]
% ------------------------------------------------------------------------------
data_path_w = '../../data/w/';
% ------------------------------------------------------------------------------
% load parame_.w and parame_.dc
% ------------------------------------------------------------------------------
% load parame_.w
load(strcat(data_path_w,'parame_.mat'))
% ------------------------------------------------------------------------------
parame_.w.data_path_ = data_path_w;
% ------------------------------------------------------------------------------
% build geometry
% ------------------------------------------------------------------------------
param_w;
% ------------------------------------------------------------------------------
% to go back to pre-processing (if you so desire)
% ------------------------------------------------------------------------------
% cd ../../../../data/w-processing/
%%{
% ------------------------------------------------------------------------------
% load regularization parameters
% ------------------------------------------------------------------------------
P_inv_w = load('../../inv-param/P_inv_w.txt');
[n_inversions,n_invparam] = size(P_inv_w);
% get project (folder) number
pwd_=pwd;
if strcmp(pwd_(end-10),'/')
  project_num = str2num( pwd_(end-8) );
elseif strcmp(pwd_(end-11),'/')
  project_num = str2num( pwd_((end-9):(end-8)) );
end
% choose said project number
p_inv = P_inv_w(project_num,:);
% ------------------------------------------------------------------------------
% assign
% ------------------------------------------------------------------------------
% number of iterations
tol_iter   = p_inv(1);
% tolerance for error
tol_error  = p_inv(2);
% max number of shot-gathers to use
n_shots    = p_inv(3);
% initial guesses
eps_ini    = p_inv(4);  % []
sig_ini    = p_inv(5);  % S/m
% max sig value permitted
sig_max_   = p_inv(6);  % S/m
% min sig value permitted
sig_min_   = p_inv(7);  % S/m
% kk-smoothing factor
kk_factor  = p_inv(8);
% g_e envelope weight
g_e_weight = p_inv(9);
% g_s envelope weight
g_s_weight = p_inv(10);
% number of obj-fnc samples for parabola step-size
nparabo    = p_inv(11);
% ------------------------------------------------------------------------------
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be same as in parame_w
% ------------------------------------------------------------------------------
% -- w --
parame_.w.epsilon = ones(geome_.m,geome_.n)*eps_ini;
parame_.w.sigma   = ones(geome_.m,geome_.n)*sig_ini;
% lo wavelength [m]
parame_.w.lo = parame_.w.c/( sqrt( parame_.w.eps_max ))/parame_.w.fo;
% round to nearest-bigger decimal (e.g. 0.561924 -> 0.6)
parame_.w.lo = ceil( parame_.w.lo/0.1 )*0.1;
% ------------------------------------------------------------------------------
% gerjoii_ is born
% ------------------------------------------------------------------------------
gerjoii_ = struct;
% -- w --
gerjoii_.w.ns = n_shots;
% -----------------------
% save?
% -----------------------
% save permittivity gradients for last iteration
gerjoii_.w.save_ges     ='NO';
gerjoii_.w.data_pathges_='ges/';
% -
gerjoii_.w.MUTE = parame_.w.MUTE;
% -----------------------
% we gonna spice things up 
% with the objective fncs
% -----------------------
gerjoii_.w.obj_FNCs    = {'L2','env_L2'};
gerjoii_.w.g_e_weights = [1,g_e_weight];
gerjoii_.w.g_s_weights = [1,g_s_weight];
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
%
%                                     image
%
% ------------------------------------------------------------------------------
fprintf('\n ------------------------ imaging ----------------------------\n\n');
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
ax=1/(parame_.w.lo*kk_factor); az=ax;
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
gerjoii_.w.regu.f__ =  parame_.w.f_high; % [Hz]
gerjoii_.w.regu.f_  = -parame_.w.f_high; % [Hz]
% wanna use frequency scheme??
gerjoii_.w.regu.f_yesno = 'NO';
% frequency for source damping:
if strcmp(gerjoii_.w.regu.f_yesno,'YES')
  % = 0.5*gerjoii_.w.regu.f__ --> for frequency scheme 
  gerjoii_.w.regu.fo = 0.5*gerjoii_.w.regu.f__; % [Hz]
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
gerjoii_.w.keprct_  = 0.05; % 0.05; 0.1;
gerjoii_.w.keprct__ = 0.5;
% percentage of bound k_s to try for 3 point parabola
gerjoii_.w.ksprct_  = 0.01; % 0.005, 1e-2
gerjoii_.w.ksprct__ = 1;
% -----------------------
% automatic k_e(s) finder
% -----------------------
% permittivity
eps_max_ = parame_.w.eps_max;
eps_min_ = parame_.w.eps_min;
prct_e_=0.05; prct_e=0.05;
gerjoii_.w.regu.eps_max_ = eps_max_-prct_e_*eps_max_;
gerjoii_.w.regu.eps_min_ = eps_min_+prct_e*eps_min_;
% conductivity
prct_s_=0.05; prct_s=0.05; % 0.05,0.05.
gerjoii_.w.regu.sig_max_ = sig_max_+prct_s_*sig_max_;
gerjoii_.w.regu.sig_min_ = sig_min_-prct_s*sig_min_;
clear eps_max_ eps_min_ sig_max_ sig_min_ prct_e prct_s prct_e_ prct_s_;
% ---------------------------------------------------------------------------
%
% w :: inversion routine
%
% ---------------------------------------------------------------------------
gerjoii_.w.tol_iter  = tol_iter;
gerjoii_.w.tol_error = tol_error;
% ------------------------------------------------------------------------------
%                         record for linking?
% ------------------------------------------------------------------------------
% path to record is tmp/
gerjoii_.linker.yn = 'y';
if strcmp(gerjoii_.linker.yn,'y')
  gerjoii_.linker.path_ = '../tmp/';
  gerjoii_.w.E = [];
  gerjoii_.w.iter = 0;
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
fprintf('\n image permittivity & conductivity for %i iterations \n\n',...
gerjoii_.w.tol_iter);
tic;
% [parame_,gerjoii_] = wdc_image_e_2d(geome_,parame_,finite_,gerjoii_);
[parame_,gerjoii_] = w_imageOBJ_es(geome_,parame_,finite_,gerjoii_);
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
%%}



