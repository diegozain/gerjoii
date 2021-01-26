close all
clear
clc
% ------------------------------------------------------------------------------
cut_off = 0.006;
x_push  = 5;     % m
z_      = 0;     % m
z__     = 10;    % m
% ------------------------------------------------------------------------------
fprintf('\n\n')
ls('../');
prompt = '\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
ls(strcat('../',project_,'/output/'));
prompt = '    Tell me w or dc or wdc:         ';
wdc_ = input(prompt,'s');
% ------------------------------------------------------------------------------
path_ = strcat('../',project_,'/output/',wdc_,'/');
% ------------------------------------------------------------------------------
load(strcat(path_,'x.mat'))
load(strcat(path_,'z.mat'))
load(strcat(path_,'sigm.mat'))
% ------------------------------------------------------------------------------
load(strcat(path_,'v_currs.mat'));
v_currs = normali(v_currs);
% WARNING!!
v_currs = ones(size(v_currs));
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm*1e+3,x,z)
xlabel('Length (m)');
ylabel('Depth (m)');
title('Conductivity Everywhere (mS/m)')
simple_figure()
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
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(v_currs,x,z)
xlabel('Length (m)');
ylabel('Depth (m)');
title('ER confidence region')
simple_figure()
% ------------------------------------------------------------------------------
sigm = sigm .* v_currs;
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(sigm*1e+3,x,z)
xlabel('Length (m)');
ylabel('Depth (m)');
title('Conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
x_ = x(1)+x_push+1;        % m
x__= x(end)-x_push+1;      % m
% ------------------------------------------------------------------------------
x_ = binning(x,x_);
x__= binning(x ,x__ );
z_ = binning(z ,z_ );
z__= binning(z ,z__ );
% ------------------------------------------------------------------------------
x = x(1,x_:x__)-x_push;
z = z(1,z_:z__);
% ------------------------------------------------------------------------------
sigm = sigm(z_:z__,x_:x__);
if strcmp(wdc_,'w') | strcmp(wdc_,'wdc')
  load(strcat(path_,'epsi.mat'));
  epsi = epsi(z_:z__,x_:x__);
end
% ------------------------------------------------------------------------------
prompt = '\n\n    Do you have a topographic correction file? (y or n):  ';
topo_yn = input(prompt,'s');
if strcmp(topo_yn,'y')
  topo_=load('../data/bhrs-topo.txt');
  z_=topo_(:,2).';
  x_=topo_(:,1).';
  % ----------------------------------------------------------------------------
  z_=-(z_-min(z_));
  % ----------------------------------------------------------------------------
  if strcmp(wdc_,'w') | strcmp(wdc_,'wdc')
    [epsi_,~] = topo2mat(epsi,x,z,x_,z_);
  end
  [sigm_,z_] = topo2mat(sigm,x,z,x_,z_);
elseif strcmp(topo_,'n')
  % ----------------------------------------------------------------------------
  sigm_=sigm;
  z_=z;
  if strcmp(wdc_,'w') | strcmp(wdc_,'wdc')
    epsi_=epsi;
  end
end
% ------------------------------------------------------------------------------
fprintf('\n there are these many nans in new sigm %i',sum(isnan(sigm_(:))))
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(1e+3*sigm_,x,z_);
colormap(rainbow2(2))
xlabel('Length (m)');
ylabel('Depth (m)');
title('Conductivity (mS/m)')
simple_figure()
% ------------------------------------------------------------------------------
if strcmp(wdc_,'w') | strcmp(wdc_,'wdc')
  figure;
  fancy_pcolor(epsi_,x,z_);
  colormap(rainbow2(0.6))
  xlabel('Length (m)');
  ylabel('Depth (m)');
  title('Permittivity ( )')
  simple_figure()
end
% ------------------------------------------------------------------------------
sigm_topo = struct;
sigm_topo.x = x;
sigm_topo.z = z_;
sigm_topo.sigm = sigm_;
sigm_topo.cut_off = cut_off;
if strcmp(wdc_,'w') | strcmp(wdc_,'wdc')
  epsi_topo = struct;
  epsi_topo.x = x;
  epsi_topo.z = z_;
  epsi_topo.epsi = epsi_;
end
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save sigma (and epsi if applicable) topo corrected (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  save(strcat(path_,'sigm_topo.mat'),'sigm_topo')
  if strcmp(wdc_,'w') | strcmp(wdc_,'wdc')
    save(strcat(path_,'epsi_topo.mat'),'epsi_topo')
  end
  % ----------------------------------------------------------------------------
  fprintf('\n\n       sigma topo (and epsi topo if applicable) has been saved in %s \n\n\n',...
  strcat(path_,'sigm_topo.mat'))
else
  fprintf('\n\n       ok, your sigma topo was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------
