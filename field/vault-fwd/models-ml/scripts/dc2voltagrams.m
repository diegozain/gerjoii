close all
clear
clc
% ------------------------------------------------------------------------------
% create voltagram structures from all ER data 
% so we can make pictures of their pseudosections in python.
% ------------------------------------------------------------------------------
n_models = 48;
a_max    = 3;
% % ----------------------------------------------------------------------------
% extract what you want
prompt = '\n\n    Do you want train or test:  ';
path__ = input(prompt,'s');
path__ = strcat('../data-set/',path__,'/');
% ------------------------------------------------------------------------------
fprintf(' \n');
for im=1:n_models;
  path_ = strcat(path__,num2str(im));
  path_ = strcat(path_,'/');
  % ----------------------------------------------------------------------------
  load(strcat(path_,'kfactor_.mat'));
  load(strcat(path_,'s_i_r_d_std.mat'));
  % ----------------------------------------------------------------------------
  [src,rec,cur,d_o,std_,ns] = dc_gerjoii2iris_(s_i_r_d_std);
  rhoas = d_o .* kfactor_;
  save( strcat(path_,'rhoas','.mat'),'rhoas' )
  % ----------------------------------------------------------------------------
  src_rec_dc = [src;rec];
  n_electrodes = numel(unique(src_rec_dc(:)));
  % ----------------------------------------------------------------------------
  [~,pseus_rhoa] = dc_pseus_wenn(src,rec,d_o,rhoas,n_electrodes);
  % ----------------------------------------------------------------------------
  % fill up those nanis!
  pseus_rhoa = ave_nan(pseus_rhoa);
  % ----------------------------------------------------------------------------
  voltagram = struct;
  voltagram.pseus_rhoa = pseus_rhoa;
  save( strcat(path_,'wen.mat') ,'voltagram')
  % ----------------------------------------------------------------------------
  for a=1:a_max
    [~,pseus_rhoa] = dc_pseus_dd(src,rec,d_o,rhoas,a,n_electrodes);
    % --------------------------------------------------------------------------
    % fill up those nanis!
    pseus_rhoa = ave_nan(pseus_rhoa);
    % --------------------------------------------------------------------------
    voltagram = struct;
    voltagram.pseus_rhoa= pseus_rhoa;
    save( strcat(path_,'dd_',int2str(a),'.mat'),'voltagram' )
  end
  % ----------------------------------------------------------------------------
  if mod(im,fix(n_models*0.3)) == 1
    fprintf('   just finished voltagram # %i\n',im)
  end
end
% ------------------------------------------------------------------------------
