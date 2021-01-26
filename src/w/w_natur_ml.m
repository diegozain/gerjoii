function w_natur_ml(geome_,parame_,finite_,gerjoii_,ml_,is,im)
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
data_path_ml = strcat('../data-set/',t_or_t,int2str(im),'/');
% ..............................................................................
if strcmp(t_or_t,'train/')
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
elseif strcmp(t_or_t,'test/')
  [parame_.w.epsilon,parame_.w.sigma] = w_model_2l_(geome_.X,geome_.Y,eps_,sig_,lam_,I__(im,:));
end
% ..............................................................................
% choose source
load(strcat(data_path_,'s_r_','.mat'));
pis = parame_.w.pis;
pjs = parame_.w.pjs;
air = parame_.w.air;
% src + air + pml (on last pixel of air layer)
s_r_{is,1}(:,2) = pjs + s_r_{is,1}(:,2); % ix
s_r_{is,1}(:,1) = pis+air + s_r_{is,1}(:,1); % iz
% recs + air + pml (on last pixel of air layer)
s_r_{is,2}(:,1) = pjs + s_r_{is,2}(:,1); % ix
s_r_{is,2}(:,2) = pis+air + s_r_{is,2}(:,2); % iz
% record to gerjoii_
gerjoii_.w.s = s_r_{is,1}; % flip(s_r_{is,1},2);
gerjoii_.w.r = s_r_{is,2};
clear s_r_;
% build M for those receivers
gerjoii_ = w_M(gerjoii_,parame_.w.ny,parame_.w.nx);
% initialize observed data as zeros (because we are modeling nature now)
parame_.natu.w.d_2d = zeros( geome_.w.nt , gerjoii_.w.nr );
% build wavelet
wvlet_ = w_wavelet(geome_.w.T*1e-9,parame_.w.ampli,parame_.w.tau);
gerjoii_.w.wvlet_ = wvlet_;
% ----- fwd models ------
[~,gerjoii_] = w_fwd_(geome_,parame_,finite_,gerjoii_,0);
% ------ radargram ------
radargram = struct;
radargram = gerjoii_.w.d_2d;  % [s] x [m]
% save
name = strcat(data_path_ml,'/','line',num2str( is ),'.mat');
save( name , 'radargram' );
end