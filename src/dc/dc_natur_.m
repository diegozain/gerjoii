function [d_o,rhoa_o] = dc_natur_(geome_,parame_,finite_,gerjoii_,i_e)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% runs ER forward model for one source-sink pair (indexed by input 'i_e').
% this program reads sources and receivers made in experim_wdc.m or experim_dc.m.
% it then goes on to shoot and record electric voltage data.
% -
% each survey line is passed out of this function as d_o.
% ..............................................................................
% this path is defined in natur__dc
data_path_ = parame_.dc.data_path_;
% load source, receivers, current, and std
load(strcat(data_path_,'s_i_r_d_std_nodata','.mat'));
% defined in experim_dc,
%            s_i_r_d_std = dc_iris2gerjoii( src,i_o,rec,d_o,std_o )
% bundle sources, current, receivers, observed data and standard deviation,
% s_i_r_d_std{ i_e }{ 1 }(1:2)   gives source.
% s_i_r_d_std{ i_e }{ 1 }(3)     gives current.
% s_i_r_d_std{ i_e }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ i_e }{ 2 }(:,3)   gives observed data (=0 if synth experiment).
% s_i_r_d_std{ i_e }{ 2 }(:,4)   gives observed std.
% ------------------------------------------------
% dcgram = struct;
% dcgram.s_   = s_i_r_d_std{ i_e }{ 1 }(1:2);
% dcgram.i_   = s_i_r_d_std{ i_e }{ 1 }(3);
% dcgram.r_   = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
% dcgram.std_ = s_i_r_d_std{ i_e }{ 2 }(:,4);
% ------------------------------------------------
% for dc electrodes:
gerjoii_.dc.s_ = s_i_r_d_std{ i_e }{ 1 }(1:2);
gerjoii_.dc.i_ = s_i_r_d_std{ i_e }{ 1 }(3);
gerjoii_.dc.r_ = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
% fake zero data
parame_.natu.dc.d_2d = s_i_r_d_std{ i_e }{ 2 }(:,3);
parame_.natu.dc.std_2d = s_i_r_d_std{ i_e }{ 2 }(:,4);
clear s_i_r_d_std;
% choose source, receivers, measuring operator, observed data & std
gerjoii_ = dc_electrodes(geome_,parame_,finite_,gerjoii_);
% build M for that source
gerjoii_ = dc_M(finite_,gerjoii_);
% --------
%   fwd
% --------
% expand to robin
[parame_,~] = dc_robin( geome_,parame_,finite_ );
% fwd model
[gerjoii_,finite_] = dc_fwd2d( parame_,finite_,gerjoii_ );
% geometric factor (only for plotting)
gerjoii_ = dc_geomefactor_2d(parame_,finite_,gerjoii_);
% collect observed data (and apparent resistivities for geometric factor)
d_o = gerjoii_.dc.d_2d;
rhoa_o = gerjoii_.dc.d_2d .* gerjoii_.dc.k_2d;
end