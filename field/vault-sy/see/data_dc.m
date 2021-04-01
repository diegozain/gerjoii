close all
clear
clc
% ------------------------------------------------------------------------------
fprintf('\n --------------------------------------------------------')
fprintf('\n   I will show you the dc-data!')
fprintf('\n --------------------------------------------------------\n\n')
% ------------------------------------------------------------------------------
dr  =0.5; % m
a   =1;
colo=1;
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me observed or recovered data (obs or reco):  ';
data_obre = input(prompt,'s');
% ------------------------------------------------------------------------------
ls('../');
prompt = '\n\n    Tell me what project you want:  ';
project_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(data_obre,'obs')
  data_obre = 'data-synth';
  path_ = strcat('../',project_, '/' ,data_obre,'/dc/');
elseif strcmp(data_obre,'reco')
  % data_obre = 'data-recovered';
  % path_ = strcat('../',project_,'/',data_obre,'/dc/');
end
% ------------------------------------------------------------------------------
load(strcat(path_,'kfactor_.mat'));
load(strcat(path_,'s_i_r_d_std.mat'));
% ------------------------------------------------------------------------------
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
% 
% example:
% >> s_i_r_d_std{1}
% 
% ans = 
% 
%     [1x3 double]                     [14x4 double]
%  srcs(x,z) and current (A)      recs(x,z), data (V), std_.
% ------------------------------------------------------------------------------
% rhoas.mat
% the data (V) converted to app. resistivity with geometric factor k_factor.mat
% ------------------------------------------------------------------------------
[src,rec,cur,d_o,std_,ns] = dc_gerjoii2iris_(s_i_r_d_std);
% ------------------------------------------------------------------------------
src_rec_dc = [src;rec];
n_electrodes = numel(unique(src_rec_dc(:)));
% ------------------------------------------------------------------------------
rhoas    = d_o .* kfactor_;
min_rhoa = min(rhoas(:));
max_rhoa = max(rhoas(:));
% ------------------------------------------------------------------------------
% 
% plot survey
%
% ------------------------------------------------------------------------------
abmn_coordx = dr*(0:n_electrodes-1).';
electr_real = [ abmn_coordx+2 , zeros(n_electrodes,1) ];
% set structures needed for plotting
gerjoii_.dc.electr_real = electr_real;
gerjoii_.dc.n_electrodes = n_electrodes;
gerjoii_.dc.n_exp = ns;
% end points of survey... OR full discretization of survey
geome_.X = [0 (electr_real(end,1)+2)];
% plot src-rec pairs
for i_e=1:gerjoii_.dc.n_exp
  s_all{i_e} = s_i_r_d_std{ i_e }{ 1 }(1:2);
  r_all{i_e} = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
end
dc_plot_srcrec_all(gerjoii_,geome_,s_all,r_all);
clear abmn_coordx s_all r_all geome_ gerjoii_ i_e;
% ------------------------------------------------------------------------------
%
%                            see pseudo-sections
%
% ------------------------------------------------------------------------------
% wenner
% ------------------------------------------------------------------------------
[pseus_do,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoas,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(pseus_rhoa,source_no,n_levels);
caxis([min_rhoa,max_rhoa])
colormap(rainbow2(colo))
axis normal
xlabel('Source #')
ylabel('n level')
title('Wenner (Ohm.m)');
simple_figure();
% ------------------------------------------------------------------------------
% save 
voltagram = struct;
voltagram.pseus_rhoa = pseus_rhoa;
voltagram.pseus_do   = pseus_do;
voltagram.source_no  = source_no;  
voltagram.n_levels   = n_levels;
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save wenner pseudo-section (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  if strcmp(data_obre,'data-synth')
    path2save = strcat(path_,'pseudo/','observed');
  elseif strcmp(data_obre,'data-recovered')
    path2save = strcat(path_,project_);
  end
  save(strcat(path2save,'-wen.mat'),'voltagram')
  % ----------------------------------------------------------------------------
  fprintf('\n\n       wenner pseudo-secton has been saved in %s \n\n\n',...
  strcat(path2save,'-wen.mat'))
else
  fprintf('\n\n       ok, your wenner pseudo-section was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------
%   dipole-dipole
% ------------------------------------------------------------------------------
[pseus_do,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoas,a,n_electrodes);
source_no = 1:0.5:ceil(size(pseus_rhoa,2)/2);
n_levels = 1:size(pseus_rhoa,1);
% ------------------------------------------------------------------------------
figure;
fancy_pcolor(pseus_rhoa,source_no,n_levels);
caxis([min_rhoa,max_rhoa])
colormap(rainbow2(colo))
axis normal
xlabel('Source #')
ylabel('n level')
title(['Dipole-dipole (Ohm.m) for a-spacing = ',num2str(a)]);
simple_figure();
% ------------------------------------------------------------------------------
% save 
voltagram = struct;
voltagram.pseus_rhoa= pseus_rhoa;
voltagram.pseus_do  = pseus_do;
voltagram.source_no = source_no;  
voltagram.n_levels  = n_levels;  
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save dipole-dipole pseudo-section (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  if strcmp(data_obre,'data-synth')
    path2save = strcat(path_,'pseudo/','observed');
  elseif strcmp(data_obre,'data-recovered')
    path2save = strcat(path_,project_);
  end
  save(strcat(path2save,'-dd.mat'),'voltagram')
  % ----------------------------------------------------------------------------
  fprintf('\n\n       dipole-dipole pseudo-secton has been saved in %s \n\n\n',...
  strcat(path2save,'-dd.mat'))
else
  fprintf('\n\n       ok, your dipole-dipole pseudo-section was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
prompt = '\n\n    do you want to save voltage data (y/n):  ';
save_ = input(prompt,'s');
% ------------------------------------------------------------------------------
if strcmp(save_,'y')
  if strcmp(data_obre,'data-synth')
    path2save = strcat(path_,'pseudo/','observed');
  elseif strcmp(data_obre,'data-recovered')
    path2save = strcat(path_,project_);
  end
  save(strcat(path2save,'-data.mat'),'d_o')
  % ----------------------------------------------------------------------------
  fprintf('\n\n       voltage data has been saved in %s \n\n\n',...
  strcat(path2save,'-data.mat'))
else
  fprintf('\n\n       ok, your voltage data was not saved.\n\n\n');
end
% ------------------------------------------------------------------------------

