close all
clear
clc
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me what project you want:  ';
ls('../');
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
path_t= strcat('../image2mat/nature-synth/mat-file/');
load(strcat(path_t,'sigm.mat'))
sigm_t = sigm;
% ------------------------------------------------------------------------------
path_ = strcat('../',project_,'/output/dc/');
% ------------------------------------------------------------------------------
load(strcat(path_,'x.mat'))
load(strcat(path_,'z.mat'))
load(strcat(path_,'sigm.mat'))
load(strcat(path_,'v_currs.mat'));
% ------------------------------------------------------------------------------
% min_s=min(sigm_t(:));
% max_s=max(sigm_t(:));
% min_s=min([sigm(:) ; min_s])*1e+3;
% max_s=max([sigm(:) ; max_s])*1e+3;
% ------------------------------------------------------------------------------
min_s=4;
max_s=10;
% ------------------------------------------------------------------------------
cut_off = 0.024; % 0.022
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm*1e+3,x,z)
caxis([min_s max_s])
colormap(rainbow2(2))
xlabel('Length (m)');
ylabel('Depth (m)');
title('ER conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm_t-sigm,x,z)
colormap(rainbow2(2))
xlabel('Length (m)');
ylabel('Depth (m)');
title('True - ER conductivity')
simple_figure()
% ------------------------------------------------------------------------------
v_currs = normali(v_currs);
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(v_currs,x,z)
xlabel('Length (m)');
ylabel('Depth (m)');
title('Stack of potentials')
simple_figure()
% ------------------------------------------------------------------------------
v_currs(v_currs<=cut_off)=NaN;    
v_currs(v_currs>cut_off)=1;
figure;
fancy_imagesc(v_currs,x,z)
xlabel('Length (m)');
ylabel('Depth (m)');
title('ER confidence region')
simple_figure()
sigm = sigm .* v_currs;
% ------------------------------------------------------------------------------
sigm_=sigm;
z_=z;
% ------------------------------------------------------------------------------
fprintf('\n there are these many nans in new sigm %i',sum(isnan(sigm_(:))))
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(1e+3*sigm_,x,z_);
caxis([min_s max_s])
colormap(rainbow2(2))
xlabel('Length (m)');
ylabel('Depth (m)');
title('ER conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save sigma topo corrected (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
sigm_topo = struct;
sigm_topo.x = x;
sigm_topo.z = z_;
sigm_topo.sigm = sigm_;
sigm_topo.cut_off = cut_off;
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  save(strcat(path_,'sigm_topo.mat'),'sigm_topo')
  % ----------------------------------------------------------------------------
  fprintf('\n\n       sigma topo has been saved in %s \n\n\n',...
  strcat(path_,'sigma_topo.mat'))
else
  fprintf('\n\n       ok, your sigma topo was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------