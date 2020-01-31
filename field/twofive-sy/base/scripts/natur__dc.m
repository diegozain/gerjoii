% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% run the ER forward model for a bunch of sources to collect some 
% synthetic "real" data.
% ..............................................................................
% path for data storage and experiment parameters retreival
data_path_ = parame_.dc.data_path_;
% many experiments are to be done,
n_exp = gerjoii_.dc.n_exp;
% print some funny stuff so user is amused
fprintf('\n----------->x< er forward models\n');
fprintf('  # of fwd models    : %i\n',n_exp);
fprintf('  # of src-rec pairs : %i\n\n',n_shots);
% d_os and rhoa_os are cells exactly like the cell s_i_r_d_std{:}{2}(:,3)
d_os     = cell(n_exp,1);
rhoa_os  = d_os;
kfactors = d_os;
tic;
parfor i_e=1:n_exp;
  [d_o,rhoa_o] = dc_natur_(geome_,parame_,finite_,gerjoii_,i_e);
  % -------------------
  % collect some stuff
  % -------------------
  % store observed data in s_i_r_d_std
  s_i_r_d_std{i_e}{2}(:,3) = d_o;
  % ............................................................................
  % NOTE: this is only for plotting
  d_os{i_e} = d_o;
  % apparent resistivities are ONLY for ploting data as pseudo sections
  % they are computed by: rhoa_o = gerjoii_.dc.d_2d .* gerjoii_.dc.k_2d
  rhoa_os{i_e}  = rhoa_o;
  kfactors{i_e} = rhoa_o./d_o;
  % ............................................................................
end
% save
name = strcat(data_path_,'s_i_r_d_std','.mat');
save( name , 's_i_r_d_std' );
% ............................................................................
% ------- this next part is only for plotting data as pseudo sections --------
% ............................................................................
src_r_d_o = [];
rhoa_o_   = [];
kfactor_  = [];
for i_e=1:n_exp;
  % rhoa_o_ = column vector of rhoa_os ( use full() )
  rhoa_o_ = [rhoa_o_; full(rhoa_os{i_e}(:)) ];
  kfactor_ = [kfactor_; full(kfactors{i_e}(:)) ];
  % recs and srcs
  rec = s_i_r_d_std{i_e}{2}(:,1:2);
  % nr = # of receivers for this experiment
  nr = size(rec,1);
  src = s_i_r_d_std{i_e}{1}(1:2);
  src = repmat(src,[nr,1]);
  % src_r_d_o = 3 column matrix: src, rec, full(d_o)
  src_r_d_o = [ src_r_d_o; src , rec , full(d_os{i_e}(:)) ];
end
% save
name = strcat(data_path_,'rhoa_o_','.mat');
save( name , 'rhoa_o_' );
name = strcat(data_path_,'kfactor_','.mat');
save( name , 'kfactor_' );
toc;
% clear
clear s_i_r_d_std kfactor_ rhoa_o_ kfactors rhoa_os d_os;