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
%
%                       load gerjoii_ structure
%                                 &
%                          current solutions 
%
%   all needed files are in tmp/
% ------------------------------------------------------------------------------
% load gerjoii_
load(strcat('../tmp/','gerjoii_.mat'))
load(strcat('../tmp/','parame_.mat'))
load(strcat('../tmp/','finite_.mat'))
load(strcat('../tmp/','geome_.mat'))
% load iteration stuff
iter      = load(strcat('../tmp/','iter.txt'))
tol_iter  = load(strcat('../tmp/','tol-iter.txt'))
tol_iter_ = load('../tmp/tol_iter_.txt');
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
% ------------------------------------------------------------------------------
%
%                       image
%
% ------------------------------------------------------------------------------
fprintf('\n ------------------------ imaging ----------------------------\n\n');
% ..............................................................................
% load initial guess (perhaps from a previous inversion)
% ..............................................................................
% ..............................................................................
% load dsigma and depsilon for momentum
% ..............................................................................
% ..............................................................................
% load current number of iterations
% ..............................................................................
% (they are already inside gerjoii_):
% global clock is     gerjoii_.linker.tol_iter
% internal clock is   gerjoii_.wdc.tol_iter
% iter step size is   gerjoii_.wdc.tol_iter_
gerjoii_.linker.tol_iter = tol_iter;
gerjoii_.w.tol_iter_ = tol_iter_;
gerjoii_.w.tol_iter = gerjoii_.w.tol_iter + gerjoii_.w.tol_iter_;
if gerjoii_.w.tol_iter>gerjoii_.linker.tol_iter
  gerjoii_.w.tol_iter = gerjoii_.linker.tol_iter;
end
% ------------------------------------------------------------------------------
%
% This is the main routine of the inversion
%
% ------------------------------------------------------------------------------
fprintf('\n\n image permittivity and conductivity for %i iterations \n\n',...
gerjoii_.w.tol_iter);
tic;
% [parame_,gerjoii_] = w_image_es_f(geome_,parame_,finite_,gerjoii_);
[parame_,gerjoii_] = w_image_es(geome_,parame_,finite_,gerjoii_);
% [parame_,gerjoii_] = w_image_e(geome_,parame_,finite_,gerjoii_);
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
% delete data-mat-synth/w/*.mat;
% delete data-mat-synth/dc/*.mat;
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
cd ../../scripts/
% ------------------------------------------------------------------------------
% for linking
% ------------------------------------------------------------------------------
% path to record is ../tmp/
% save gerjoii_, parame_, geome_ & finite_
save(strcat(gerjoii_.linker.path_,'gerjoii_'),'gerjoii_');
save(strcat(gerjoii_.linker.path_,'parame_'),'parame_');
save(strcat(gerjoii_.linker.path_,'geome_'),'geome_');
save(strcat(gerjoii_.linker.path_,'finite_'),'finite_');
% save iterations in txt so an outside cron shell can access them
dlmwrite(strcat(gerjoii_.linker.path_,'iter.txt'),gerjoii_.w.iter);