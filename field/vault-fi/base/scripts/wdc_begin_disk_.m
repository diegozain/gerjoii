% ------------------------------------------------------------------------------
% 
% 2.5d synthetic inversion of conductivity using GPR and ER data
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
parame_.w.data_path_  = data_path_w;
parame_.dc.data_path_ = data_path_dc;
% ------------------------------------------------------------------------------
% build geometry
% ------------------------------------------------------------------------------
param_w;
param_dc;
% ------------------------------------------------------------------------------
% to go back to pre-processing (if you so desire)
% ------------------------------------------------------------------------------
% cd ../../../../data/w-processing/
% cd ../../../../data/dc-processing/
%%{
% ------------------------------------------------------------------------------
% load regularization parameters
% ------------------------------------------------------------------------------
P_inv = load('../../inv-param/P_inv.txt');
[n_inversions,n_invparam] = size(P_inv);
% get project (folder) number
pwd_=pwd;
if strcmp(pwd_(end-10),'/')
  project_num = str2num( pwd_(end-8) );
elseif strcmp(pwd_(end-11),'/')
  project_num = str2num( pwd_((end-9):(end-8)) );
end
% choose said project number
p_inv = P_inv(project_num,:);
% ------------------------------------------------------------------------------
% assign
% ------------------------------------------------------------------------------
% number of iterations
tol_iter  = p_inv(1);
% tolerance for error
tol_error = p_inv(2);
% tolerance for xgrad error
tol_xgrad = p_inv(3);
% number of gpr-sources to do cut-off
n_shots   = p_inv(4);
% ----------  initial guesses 
% conductivity
sig_ini = p_inv(5);  % S/m
% background conductivity
sig_bg  = p_inv(6);  % S/m
% max sig value permitted
sig_max_= p_inv(7);  % S/m
% min sig value permitted
sig_min_= p_inv(8);  % S/m
% permittivity
eps_ini = p_inv(9);  % []
% ----------  dc regu 
% coefficient for background conductivity
beta_dc     = p_inv(10);
% momentum dc
momentum_dc = p_inv(11);
% kk-smoothing factor dc
kk_factor_dc= p_inv(12);
% ----------  w regu 
% kk-smoothing factor w
kk_factor_w= p_inv(13);
% number of obj-fnc samples for parabola step-size
nparabo    = p_inv(14);
% g_e envelope weight
g_e_weight = p_inv(15);
% g_s envelope weight
g_s_weight = p_inv(16);
% ----------  wdc regu 
adc_ = p_inv(17);
da_dc= p_inv(18);
dEdc = p_inv(19);
da_w = p_inv(20);
dEw  = p_inv(21);
% ----------  wdc regu + xgrad
h_eps = p_inv(22);
d_eps = p_inv(23);
h_sig = p_inv(24);
d_sig = p_inv(25);
% ----------  dsigm_wdc * geomean * ?
step_ = p_inv(26);
% ------------------------------------------------------------------------------
% here you could put whatever values for permittivity and conductivity 
% but the max and min of permittivity also has to be same as in parame_w
% ------------------------------------------------------------------------------
% epsi & sigm homogeneous
% -- dc --
parame_.dc.sigma  = ones(geome_.n,geome_.m)*sig_ini;
parame_.dc.sigma_o= ones(geome_.n,geome_.m)*sig_bg;
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% -- w --
parame_.w.epsilon = ones(geome_.m,geome_.n)*eps_ini;; 
parame_.w.sigma   = ones(geome_.m,geome_.n)*sig_ini;
% ------------------------------------------------------------------------------
%{
load('../../data/initial-guess/sigm.mat');
load('../../data/initial-guess/epsi.mat');
% ------------------------------------------------------------------------------
% epsi & sigm from file
% -- dc --
parame_.dc.sigma  = sigm.';
parame_.dc.sigma_o= ones(geome_.n,geome_.m)*sig_bg;
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% -- w --
parame_.w.epsilon = epsi; 
parame_.w.sigma   = sigm;
% ------------------------------------------------------------------------------
% clean
clear sigm
clear epsi
%}
% ------------------------------------------------------------------------------
% % parame_.dc.rho_sur
% % parame_.dc.rho_ave
% % parame_.dc.rho_max
% % parame_.dc.rho_min
% % parame_.dc.rho_max_cut
% % -- dc --
% parame_.dc.sigma  = ones(geome_.n,geome_.m)*sig_ini;
% parame_.dc.sigma_o= ones(geome_.n,geome_.m)*sig_bg;
% % expand to robin grid
% [parame_,finite_] = dc_robin(geome_,parame_,finite_);
% % -- w --
% parame_.w.epsilon = ones(geome_.m,geome_.n)*eps_ini;
% parame_.w.sigma   = ones(geome_.m,geome_.n)*sig_ini;
% ------------------------------------------------------------------------------
% %                             right-angle geometry
% % w
% parame_.w.epsilon = ones(geome_.m,geome_.n)*5;
% parame_.w.sigma   = ones(geome_.m,geome_.n)*sig_ini;
% % --
% reflector_iz = binning(geome_.Y,1);
% parame_.w.epsilon(reflector_iz:end,:) = 20;
% % parame_.w.sigma(reflector_iz:end,:) = 6e+3;
% parame_.dc.sigma  = parame_.w.sigma.';
% parame_.dc.sigma_o= ones(geome_.n,geome_.m)*sig_bg;
% % --
% % expand to robin grid
% [parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ------------------------------------------------------------------------------
% lo wavelength [m]
% c = 299792458 m / s
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
gerjoii_.w.MUTE = parame_.w.MUTE; % 'yes_MUTE' or 'no_MUTE' or parame_.w.MUTE
% -- dc --
% no. of electrodes and stuff
gerjoii_.dc.electr_real  = parame_.dc.electr_real;
gerjoii_.dc.n_electrodes = parame_.dc.n_electrodes;
gerjoii_.dc.n_exp        = parame_.dc.n_exp;
% -----------------------
% use joint update for permittivity too? (xgrad)
% use permittivity for conductivity too? (xgrad)
% -----------------------
gerjoii_.wdc.eps_too  ='YES';
gerjoii_.wdc.sig_too  ='YES';
% -----------------------
% save?
% -----------------------
% save updates
gerjoii_.wdc.save_dsigs = 'NO';
gerjoii_.wdc.save_deps  = 'NO';
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
% gerjoii_.dc.save_dsigm = 1;
% gerjoii_.dc.data_pathsigs_='sigs-dc/';
%%{
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
poolsize  = min([n_workers,gerjoii_.w.ns]); % gerjoii_.w.ns
parpool( poolsize );
fprintf('\n\n    ------------------------------\n');
fprintf('    things are going parallel now.\n');
fprintf('    number of workers is %i \n',poolsize);
fprintf('    ------------------------------\n');
% ------------------------------------------------------------------------------
% dc 2.5d conversion stuff
% ------------------------------------------------------------------------------
kk_dc;
% ------------------------------------------------------------------------------
%
%                                     image
%
% ------------------------------------------------------------------------------
fprintf('\n ------------------------ imaging ----------------------------\n\n');
% ------------------------------------------------------------------------------
%
% wave 
%
% ------------------------------------------------------------------------------
% ..............
% regularize
% ..............
% choose filter bandwidth in units of [1/m],
% smaller ax,az --> only lower freqs survive
% ax=1/(parame_.w.lo*1.5); az=ax;
ax=1/(parame_.w.lo*kk_factor_w); az=ax;
% ax=20; az=ax;
fprintf('\ncharacateristic wavelength is %2.2d [m]\n',parame_.w.lo)
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
gerjoii_.w.k_s = [1e-7 1e+3];
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
gerjoii_.w.ksprct_  = 0.002; % 0.005, 1e-2 (was 0.002)
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
% ------------------------------------------------------------------------------
%
% dc 
%
% ------------------------------------------------------------------------------
% ..............
% regularize
% ..............
% choose filter bandwidth in units of [1/m],
% smaller ax,az --> only lower freqs survive
% ax=1/parame_.w.lo; az=ax; % [1/m]
% ax = 1/1.6; az = 1/1.6; % [1/m]
ax = 1/(parame_.dc.dr*kk_factor_dc); az = 1/(parame_.dc.dr*kk_factor_dc); % [1/m]
fprintf('\ndc kk-filter:   ax=%2.2d, az=%2.2d [1/m]\n',ax,az);
% turn to discrete coordinates,
% (nax = nkx*ax*dx, but nkx is multiplied in image_gaussian.m)
ax=ax*geome_.dx; az=az*geome_.dy;
gerjoii_.dc.regu.ax = ax;
gerjoii_.dc.regu.az = az;
gerjoii_.dc.regu.beta_ = beta_dc;
% for momentum
gerjoii_.dc.dsigma_ = zeros(size(parame_.dc.sigma));
gerjoii_.dc.momentum = momentum_dc;
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
% sig_max_ = 1/parame_.dc.rho_min;
% sig_min_ = 1/parame_.dc.rho_max;
prct_s_=0.05; prct_s=0.05;
gerjoii_.dc.regu.sig_max_ = sig_max_+prct_s_*sig_max_;
gerjoii_.dc.regu.sig_min_ = sig_min_-prct_s*sig_min_;
clear sig_max_ sig_min_ prct_s prct_s_;
% ------------------------------------------------------------------------------
%
% joint
%
% ------------------------------------------------------------------------------
% 
% -----------------------
% stop main while criteria
% -----------------------
gerjoii_.wdc.tol_iter  = tol_iter;
gerjoii_.wdc.tol_error = tol_error;
% -----------------------
% joint inversion weights
% -----------------------
% choose weights for dsigma_wdc weights,
gerjoii_.wdc.adc_  = adc_;
% regulate adc
gerjoii_.wdc.da_dc = da_dc;
gerjoii_.wdc.dEdc  = dEdc;
% regulate aw
gerjoii_.wdc.da_w  = da_w;
gerjoii_.wdc.dEw   = dEw;
fprintf('\ninitial adc = %2.2d\n',gerjoii_.wdc.adc_);
parame_.wdc.sigma = parame_.w.sigma;
% -----------------------
% we gonna spice things up 
% with the objective fncs
% -----------------------
gerjoii_.w.obj_FNCs    = {'L2','env_L2'};
gerjoii_.w.g_e_weights = [1,g_e_weight];
gerjoii_.w.g_s_weights = [1,g_s_weight];
% -----------------------
% use joint update for permittivity too? (xgrad)
% -----------------------
% for 'b' weight
gerjoii_.wdc.deps.h   = h_eps;
gerjoii_.wdc.deps.d   = d_eps;
% for xgradient optimization
gerjoii_.wdc.deps.ni  = 25;
gerjoii_.wdc.deps.tol = tol_xgrad;
gerjoii_.wdc.deps.ka  = linspace(-1,2,4).';
% -----------------------
% use permittivity for conductivity too? (xgrad)
% -----------------------
gerjoii_.wdc.dsigx.h  = h_sig;
gerjoii_.wdc.dsigx.d  = d_sig;
gerjoii_.wdc.deps.kb  = linspace(-1,2,4).';
% -----------------------
% dsigm_wdc * geomean * ?
% -----------------------
gerjoii_.wdc.step_    = step_;
% ------------------------------------------------------------------------------
%                         record for linking?
% ------------------------------------------------------------------------------
% path to record is tmp/
gerjoii_.linker.yn = 'y';
if strcmp(gerjoii_.linker.yn,'y')
  gerjoii_.linker.path_ = '../tmp/';
  gerjoii_.wdc.E = [];
  gerjoii_.wdc.as = zeros(2,2);
  gerjoii_.wdc.h_w_ = [];
  gerjoii_.wdc.Ee = [];
  gerjoii_.wdc.deps.b = [];
  gerjoii_.wdc.dsigx.b = [];
  gerjoii_.wdc.iter = 0;
  gerjoii_.dc.v_currs=zeros(geome_.n,geome_.m);
  % ----------------------------------
  % global & internal iteration clock
  % ----------------------------------
  % global clock
  gerjoii_.linker.tol_iter = gerjoii_.wdc.tol_iter;
  dlmwrite(strcat(gerjoii_.linker.path_,'tol-iter.txt'),gerjoii_.linker.tol_iter);
  % internal clock
  tol_iter_ = load('../tmp/tol_iter_.txt');
  gerjoii_.wdc.tol_iter_ = tol_iter_;
  gerjoii_.wdc.tol_iter = gerjoii_.wdc.tol_iter_;
end
% ------------------------------------------------------------------------------
%
% Set up stuff for tiny domains
%
% ------------------------------------------------------------------------------
domain_w;
% ------------------------------------------------------------------------------
%
% This is the main routine of the inversion
%
% ------------------------------------------------------------------------------
fprintf('\n\n image permittivity and conductivity for %i iterations \n\n',...
gerjoii_.wdc.tol_iter);
tic;
[parame_,gerjoii_] = wdc_imageOBJe2_5d_disk(geome_,parame_,finite_,gerjoii_);
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
% dsigm_dc  - last update for conductivity (just er)
% dsigm     - last update for conductivity (joint gpr+er)
% x         - x discretized vector
% z         - z discretized vector
% h_w       - weights h used for joint conductivity update scheme
% as        - weights aw and adc used for weighing h in joint update in row 1
%             objective function values for gpr and er in row 2
% E         - objective function values in iterations
cd ../output/wdc/
epsi     =parame_.w.epsilon;
sigm     =parame_.w.sigma;
depsi    =gerjoii_.w.depsilon;
dsigm_w  =gerjoii_.w.dsigma;
dsigm_dc =gerjoii_.dc.dsigma.';
dsigm    =gerjoii_.wdc.dsigma;
x        =geome_.X;
z        =geome_.Y;
h_w      =gerjoii_.wdc.h_w_;
as       =gerjoii_.wdc.as;
E        =gerjoii_.wdc.E;
wvlets_  =parame_.w.wvlets_;
v_currs  =gerjoii_.dc.v_currs.';
save('epsi','epsi')
save('sigm','sigm')
save('depsi','depsi')
save('dsigm_w','dsigm_w')
save('dsigm_dc','dsigm_dc')
save('dsigm','dsigm')
save('h_w','h_w')
save('E','E')
save('as','as')
save('x','x')
save('z','z')
save('p_inv','p_inv')
save('wvlets_','wvlets_')
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
  dlmwrite(strcat(gerjoii_.linker.path_,'iter.txt'),gerjoii_.wdc.iter);
end
%%}



