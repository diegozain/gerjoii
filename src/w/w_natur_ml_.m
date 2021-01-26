function w_natur_ml_(geome_,parame_,finite_,gerjoii_,ml_,is,im)
% diego domenzain
% spring 2020 @ CSM
% ..............................................................................
% runs GPR forward model for one source (indexed by input 'is').
% this program reads sources and receivers made in experim_wdc.m or experim_w.m.
% it then goes on to shoot and record electromagnetic wave data.
% -
% this is meant for machine learning labels.
% each survey data is saved as line[is].mat, and saved in data_path_ml, which 
% is defined in w_fwd_2l.m
% ONLY the data matrix (time by receivers) is saved. NO UNITS of space or time!!
% ..............................................................................
% this path loads src-recs and is defined in natur__w, wdc_begin_ or wdc_forward_
data_path_   = parame_.w.data_path_;
% ..............................................................................
t_or_t = ml_.t_or_t;
eps_   = ml_.eps_;
sig_   = ml_.sig_;
lam_   = ml_.lam_;
I__    = ml_.I__;
% ..............................................................................
data_path_ml = strcat('../data-field/',t_or_t,int2str(im),'/');
% ..............................................................................
if strcmp(t_or_t,'train/')
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
elseif strcmp(t_or_t,'test/')
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l_(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
end
% ..............................................................................
% ----- load meta  ------
[parame_,gerjoii_] = w_load(parame_,gerjoii_,is);
% ----- fwd models ------
[~,gerjoii_] = w_fwd_(geome_,parame_,finite_,gerjoii_,0);
% ------ radargram ------
radargram = struct;
radargram = gerjoii_.w.d_2d;  % [s] x [m]
% save
name = strcat(data_path_ml,'/','line',num2str( is ),'.mat');
save( name , 'radargram' );
end