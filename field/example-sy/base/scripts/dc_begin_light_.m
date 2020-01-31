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
poolsize  = min([n_workers,str2num(getenv('SLURM_CPUS_PER_TASK'))]); 
% parpool( poolsize );
parpool('local', poolsize);
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% --------------------------
% dc
% --------------------------
% set recording path
parame_.dc.data_path_ = '../data-synth/dc/';
natur__dc;
% --------------------------
% dc + noise
% --------------------------
gerjoii_.dc.noise.prcent = 0.1; % 0.05
gerjoii_.dc.noise.n_vkluster = 3;
noise__dc;
% ------------------------------------------------------------------------------
%
%                       image
%
% ------------------------------------------------------------------------------
fprintf('\n ------------------------ imaging ----------------------------\n\n');
% ..............
% initial guess
% ..............
% ---
% unknown conductivity & unknown permittivity
% ---
parame_.w.epsilon = parame_.natu.epsilon_w(1) * ones(geome_.m,geome_.n);
parame_.w.sigma = parame_.natu.sigma_w(1) * ones(geome_.m,geome_.n);
% -------------------------
%
% dc 
%
% -------------------------
% ...............
% initial guess
% ...............
parame_.dc.sigma = parame_.w.sigma.';
parame_.dc.sigma_o = zeros(size(parame_.natu.sigma_dc)); % parame_.dc.sigma;
% ..............
% regularize
% ..............
% choose filter bandwidth in units of [1/m],
% smaller ax,az --> only lower freqs survive
% ax=1/parame_.w.lo; az=ax; % [1/m]
ax = 1/1.6; az = 1/1.6; % [1/m]
fprintf('\ndc kk-filter:   ax=%2.2d, az=%2.2d [1/m]\n',ax,az);
% turn to discrete coordinates,
% (nax = nkx*ax*dx, but nkx is multiplied in image_gaussian.m)
ax=ax*geome_.dx; az=az*geome_.dy;
gerjoii_.dc.regu.ax = ax;
gerjoii_.dc.regu.az = az;
gerjoii_.dc.regu.beta_ = 0; % 1e-2; % 2e-2;
% for momentum
gerjoii_.dc.dsigma_ = zeros(size(parame_.dc.sigma));
gerjoii_.dc.momentum = 0.5;
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
gerjoii_.dc.k_s = [1e-7 1e+5];
fprintf('\ndc pica k_s somewhere between %2.2d and %2.2d\n',...
gerjoii_.dc.k_s(1),gerjoii_.dc.k_s(2));
% percentage of bound k_s to try for 3 point parabola
gerjoii_.dc.kprct_  = 1e-3; % 0.005 1e-2 5e-4 8e-3
gerjoii_.dc.kprct__ = 0.5;
% -----------------------
% automatic k_s finder
% -----------------------
% conductivity
sig_max_ = max(parame_.natu.sigma_dc(:));
sig_min_ = min(parame_.natu.sigma_dc(:));
prct_s_=0.05; prct_s=0.05;
gerjoii_.dc.regu.sig_max_ = sig_max_+prct_s_*sig_max_;
gerjoii_.dc.regu.sig_min_ = sig_min_-prct_s*sig_min_;
clear sig_max_ sig_min_ prct_s prct_s_;
% ---------------------------------------------------------------------------
%
%                     dc :: inversion routine
%
% ---------------------------------------------------------------------------
% load P_inv.txt with all parameters needed for this thing to work.
% this P_inv.txt has parameters for a single inversion in each row.
% the rows are numbered like the folders this thing is in.
P_inv = load('../../inv-param/P_inv.txt');
[n_inversions,n_invparam] = size(P_inv);
% get project (folder) number
pwd_=pwd;
if strcmp(pwd_(end-10),'/')
  project_num = str2num( pwd_(end-8) );
elseif strcmp(pwd_(end-11),'/')
  project_num = str2num( pwd_((end-9):(end-8)) );
end
% maybe P_inv is too small for this one project, 
% so let's spice things up.
if n_inversions<project_num
  ww = rand(1,n_inversions);
  p_inv    = ww * P_inv * (1/n_inversions);
  p_inv(1)  = P_inv(1,1);
  p_inv(2)  = P_inv(1,2);
  p_inv(12) = P_inv(1,12);
else 
  % choose said project number
  p_inv = P_inv(project_num,:);
end
% -----------------------
% stop main while criteria
% -----------------------
gerjoii_.dc.tol_iter  = p_inv(1);
gerjoii_.dc.tol_error = p_inv(2);
% -----------------------
% joint inversion weights
% -----------------------
% choose weights for dsigma_wdc weights,
gerjoii_.wdc.adc_  = p_inv(3); % 0.75 . 0.75 (0.85 is ok)
% regulate adc
gerjoii_.wdc.da_dc = p_inv(4); % 1.2 . 3 . 1.1
gerjoii_.wdc.dEdc  = p_inv(5); % 2 . 1.5
% regulate aw
gerjoii_.wdc.da_w  = p_inv(6); % 1.1 . 2.5 4 (3 is ok)
gerjoii_.wdc.dEw   = p_inv(7); % 1/1.1 . 1/1.1
fprintf('\ninitial adc = %2.2d\n',gerjoii_.wdc.adc_);
parame_.wdc.sigma = parame_.w.sigma;
% -----------------------
% we gonna spice things up 
% with the objective fncs
% -----------------------
gerjoii_.w.obj_FNCs    = {'L2','env_L2'};
gerjoii_.w.g_e_weights = [1,p_inv(8)]; % 1,0.25 (try 1e-6. was 1e-4)
gerjoii_.w.g_s_weights = [1,p_inv(9)]; % 1,0.25
% -----------------------
% use joint update for permittivity too? (xgrad)
% -----------------------
gerjoii_.wdc.eps_too  ='NO';
% for 'b' weight
gerjoii_.wdc.deps.h   = p_inv(10); % 0.01 (try 1e-6. was 1e-4)
gerjoii_.wdc.deps.d   = p_inv(11); % 0.1
% for xgradient optimization
gerjoii_.wdc.deps.ni  = 25;
gerjoii_.wdc.deps.tol = p_inv(12);
gerjoii_.wdc.deps.ka  = linspace(-1,2,4).';
% -----------------------
% use permittivity for conductivity too? (xgrad)
% -----------------------
gerjoii_.wdc.sig_too  ='NO';
gerjoii_.wdc.dsigx.h  = p_inv(13); % 0.01  0.1 kinda ok, 0.3 too much
gerjoii_.wdc.dsigx.d  = p_inv(14); % 0.1 kinda ok
gerjoii_.wdc.deps.kb  = linspace(-1,2,4).';
% -----------------------
% save?
% -----------------------
% save permittivity gradients for last iteration
gerjoii_.w.save_ges     ='NO';
gerjoii_.w.data_pathges_='ges/';
% save updates
gerjoii_.wdc.save_dsigs = 'NO';
gerjoii_.wdc.save_deps  = 'NO';
% ------------------------------------------------------------------------------
%                         record for linking?
% ------------------------------------------------------------------------------
% path to record is tmp/
fid=fopen('../tmp/link_power.txt');
link_power=fgetl(fid);
fclose(fid);
gerjoii_.linker.yn = link_power; % 'y' or 'n'
if strcmp(gerjoii_.linker.yn,'y')
  gerjoii_.linker.path_ = '../tmp/';
  gerjoii_.dc.E = [];
  gerjoii_.dc.iter = 0;
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
fprintf('\n\n image conductivity for %i iterations \n\n',...
gerjoii_.dc.tol_iter);
tic;
[parame_,gerjoii_] = dc_image_2d__(geome_,parame_,finite_,gerjoii_);
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
save('sigm','sigm')
save('dsigm_dc','dsigm_dc')
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
  dlmwrite(strcat(gerjoii_.linker.path_,'iter.txt'),gerjoii_.dc.iter);
  % activate the power
  if gerjoii_.dc.iter<gerjoii_.linker.tol_iter
    !./link_light_dc_.sh
  end
end
% ------------------------------------------------------------------------------
% chao
% ------------------------------------------------------------------------------
exit;




