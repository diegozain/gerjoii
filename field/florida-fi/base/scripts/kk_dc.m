% diego domenzain
% fall 2019 @ BSU
% ..............................................................................
% get ky-fourier coefficients, w weights and geometric factors for the 2.5d data
% ..............................................................................
% this path is defined in main script
data_path_ = parame_.dc.data_path_;
% many experiments are to be done,
n_exp   = gerjoii_.dc.n_exp;
n_shots = parame_.dc.n_shots;
% print some funny stuff so user is amused
fprintf('\n----------->x< er 2.5d fourier weights & geometric factors\n');
fprintf('  # of fwd models    : %i\n',n_exp);
fprintf('  # of src-rec pairs : %i\n\n',n_shots);
% set-up 
ky_w = zeros(finite_.dc.n_ky,2,gerjoii_.dc.n_exp);
kfactor_ = [];
tic;
parfor i_e=1:n_exp;
  [kfourier,kfactor] = dc_kk_(geome_,parame_,finite_,gerjoii_,i_e);
  % ............................................................................
  ky_w(:,:,i_e) = kfourier;
  kfactor_ = [kfactor_; kfactor];
  % ............................................................................
end
% save
name = strcat(data_path_,'ky_w','.mat');
save( name , 'ky_w' );
name = strcat(data_path_,'kfactor_','.mat');
save( name , 'kfactor_' );
toc;
% clear
clear ky_w kfactor_;