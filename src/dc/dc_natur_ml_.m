function dc_natur_ml_(geome_,parame_,finite_,gerjoii_,ml_,im)
% diego domenzain
% fall 2020 @ CSM
% ..............................................................................
% run the 2D ER forward model for a bunch of sources to collect some 
% synthetic "real" data.
% ..............................................................................
load(strcat(parame_.dc.data_path_,'s_i_r_d_std_nodata.mat'));
% ..............................................................................
t_or_t = ml_.t_or_t;
eps_   = ml_.eps_;
sig_   = ml_.sig_;
lam_   = ml_.lam_;
I__    = ml_.I__;
% ..............................................................................
parame_.dc.data_path_ml = strcat('../data-field/',t_or_t,int2str(im),'/');
% ..............................................................................
if strcmp(t_or_t,'train/')
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
elseif strcmp(t_or_t,'test/')
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l_(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
end
% ..............................................................................
% dc
parame_.dc.sigma  = parame_.w.sigma.';
% expand to robin grid
[parame_,finite_] = dc_robin(geome_,parame_,finite_);
% ..............................................................................
% many experiments are to be done,
n_exp = gerjoii_.dc.n_exp;
parfor i_e=1:n_exp;
  d_o = dc_natur__(geome_,parame_,finite_,gerjoii_,i_e);
  % -------------------
  % collect some stuff
  % -------------------
  % store observed data in s_i_r_d_std
  s_i_r_d_std{i_e}{2}(:,3) = d_o;
end
% save
name = strcat(parame_.dc.data_path_ml,'s_i_r_d_std','.mat');
save( name , 's_i_r_d_std' );
% apparent resistivity
load(strcat(parame_.dc.data_path_,'kfactor_','.mat'));
% save
name = strcat(parame_.dc.data_path_ml,'kfactor_','.mat');
save( name , 'kfactor_' );
end