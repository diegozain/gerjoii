% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% run the 2.5D ER forward model for a bunch of sources to collect some 
% synthetic "real" data.
% ..............................................................................
% path for data storage and experiment parameters retreival
data_path_ = parame_.dc.data_path_;
data_path__= parame_.dc.data_path__;
% many experiments are to be done,
n_exp = gerjoii_.dc.n_exp;
n_shots = parame_.dc.n_shots;
% print some funny stuff so user is amused
fprintf('\n----------->x< er forward models\n');
fprintf('  # of fwd models    : %i\n',n_exp);
fprintf('  # of src-rec pairs : %i\n\n',n_shots);
% load s_i_r_d_std so it can be re-written
load(strcat(data_path_,'s_i_r_d_std','.mat'));
rhos=[];
tic;
parfor i_e=1:n_exp;
  d = dc_natur__(geome_,parame_,finite_,gerjoii_,i_e);
  % -------------------
  % collect some stuff
  % -------------------
  % store observed data in s_i_r_d_std
  s_i_r_d_std{i_e}{2}(:,3) = d;
  rhos = [rhos;d];
end
% apparent resistivity
load(strcat(data_path_,'kfactor_','.mat'));
rhos = rhos .* kfactor_;
% save
name = strcat(data_path__,'s_i_r_d_std','.mat');
save( name , 's_i_r_d_std' );
name = strcat(data_path__,'rhos','.mat');
save( name , 'rhos' );
toc;