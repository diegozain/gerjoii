close all
clear
clc
% ------------------------------------------------------------------------------
% load('../data/dc/bhrs-topo.txt');
% ------------------------------------------------------------------------------
cut_off = 0.003; % 0.002 for b40
x_push  = 15;    % m
z_      = 0;         % m
z__     = 50;%13. 8 for b40       % m
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me what project you want:  ';
ls('../');
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
path_ = strcat('../',project_,'/output/dc/');
% ------------------------------------------------------------------------------
load(strcat(path_,'x.mat'))
load(strcat(path_,'z.mat'))
load(strcat(path_,'sigm.mat'))
% ------------------------------------------------------------------------------
load(strcat(path_,'v_currs.mat'));
v_currs = normali(v_currs);
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
figure;
fancy_imagesc(sigm,x,z)
xlabel('Length (m)');
ylabel('Depth (m)');
title('ER conductivity')
simple_figure()
% ------------------------------------------------------------------------------
x_ = x(1)+x_push;        % m
x__= x(end)-x_push;       % m
% ------------------------------------------------------------------------------
x_ = binning(x,x_);
x__= binning(x ,x__ );
z_ = binning(z ,z_ );
z__= binning(z ,z__ );
% ------------------------------------------------------------------------------
x = x(1,x_:x__)-x_push;
z = z(1,z_:z__);
sigm = sigm(z_:z__,x_:x__);
% ------------------------------------------------------------------------------
prompt = '\n\n    Do you have a topographic correction file? (y or n):  ';
topo_ = input(prompt,'s');
if strcmp(topo_,'y')
  z_=bhrs_topo(:,2).';
  x_=bhrs_topo(:,1).';
  % ----------------------------------------------------------------------------
  z_=-(z_-min(z_));
  % ----------------------------------------------------------------------------
  % z_=(z_-min(z_));
  % ----------------------------------------------------------------------------
  [sigm_,z_] = topo2mat(sigm,x,z,x_,z_);
elseif strcmp(topo_,'n')
  % ----------------------------------------------------------------------------
  sigm_=sigm;
  z_=z;
end
% ------------------------------------------------------------------------------
fprintf('\n there are these many nans in new sigm %i',sum(isnan(sigm_(:))))
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(1e+3*sigm_,x,z_);
colormap(rainbow2(5))
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
  strcat(path_,'sigm_topo.mat'))
else
  fprintf('\n\n       ok, your sigma topo was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------