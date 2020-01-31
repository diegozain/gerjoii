function [kfourier,kfactor] = dc_kk_(geome_,parame_,finite_,gerjoii_,i_e)
% diego domenzain
% fall 2019 @ BSU
% ------------------------------------------------------------------------------
% runs ER forward model for one source-sink pair (indexed by input 'i_e').
% this program reads sources and receivers made in experim_wdc.m or experim_dc.m.
% it then goes on to solve for 2.5d fourier coefficients and the geometric factor.
% ..............................................................................
% this path is defined in kk__dc.m or in main script
data_path_ = parame_.dc.data_path_;
% load source, receivers, current, and std
load(strcat(data_path_,'s_i_r_d_std','.mat'));
% defined in experim_dc,
%            s_i_r_d_std = dc_iris2gerjoii( src,i_o,rec,d_o,std_o )
% bundle sources, current, receivers, observed data and standard deviation,
% s_i_r_d_std{ i_e }{ 1 }(1:2)   gives source.
% s_i_r_d_std{ i_e }{ 1 }(3)     gives current.
% s_i_r_d_std{ i_e }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ i_e }{ 2 }(:,3)   gives observed data (=0 if synth experiment).
% s_i_r_d_std{ i_e }{ 2 }(:,4)   gives observed std.
% ------------------------------------------------------------------------------
% dcgram = struct;
% dcgram.s_   = s_i_r_d_std{ i_e }{ 1 }(1:2);
% dcgram.i_   = s_i_r_d_std{ i_e }{ 1 }(3);
% dcgram.r_   = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
% dcgram.std_ = s_i_r_d_std{ i_e }{ 2 }(:,4);
% ------------------------------------------------------------------------------
% for dc electrodes:
gerjoii_.dc.s_ = s_i_r_d_std{ i_e }{ 1 }(1:2);
gerjoii_.dc.i_ = s_i_r_d_std{ i_e }{ 1 }(3);
gerjoii_.dc.r_ = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
% load data
parame_.natu.dc.d    = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
parame_.natu.dc.std_ = s_i_r_d_std{ i_e }{ 2 }(:,4);
clear s_i_r_d_std;
% choose source, receivers, measuring operator, observed data & std
gerjoii_ = dc_electrodes(geome_,parame_,finite_,gerjoii_);
% ------------------------------------------------------------------------------
%                               (ky,wy) weights 
% ------------------------------------------------------------------------------
% compute ky and w weights
finite_ = dc_kfourier(finite_,gerjoii_);
% store ky and w weights
% finite_.dc.ky_w(:,:,i_e) = finite_.dc.ky_w_;
kfourier = finite_.dc.ky_w_;
if mod(i_e,10)==0
  fprintf('   just finished (ky,wy) before shots    #%i\n',i_e+1);
end
% ------------------------------------------------------------------------------
%                               geometric factor
% ------------------------------------------------------------------------------
% build M for that source
gerjoii_ = dc_M(finite_,gerjoii_);
% expand to robin
[parame_,~] = dc_robin( geome_,parame_,finite_ );
% geometric factor
gerjoii_ = dc_geomefactor2_5d(parame_,finite_,gerjoii_);
% collect geometric factor
kfactor = full(gerjoii_.dc.k);
if mod(i_e,10)==0
  fprintf('   just finished geome-fact before shots #%i\n',i_e+1);
end
% % dcgram
% dcgram.d = gerjoii_.dc.d;
% dcgram.k = gerjoii_.dc.k; % rhoa_o=d.*k 
% % save
% name = strcat(data_path_,'line',num2str( i_e ),'.mat');
% save( name , 'dcgram' );
end