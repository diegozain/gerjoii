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
poolsize  = min([n_workers,str2num(getenv('SLURM_CPUS_PER_TASK'))]);  
% parpool( poolsize );
parpool('local', poolsize);
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
gerjoii_.dc.tol_iter_ = tol_iter_;
gerjoii_.dc.tol_iter = gerjoii_.dc.tol_iter + gerjoii_.dc.tol_iter_;
if gerjoii_.dc.tol_iter>gerjoii_.linker.tol_iter
  gerjoii_.dc.tol_iter = gerjoii_.linker.tol_iter;
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
% delete data-mat-synth/w/*.mat;
% delete data-mat-synth/dc/*.mat;
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