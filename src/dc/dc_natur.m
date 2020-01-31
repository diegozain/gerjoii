function [d_o,rhoa_o] = dc_natur(geome_,parame_,finite_,gerjoii_,i_e)
% choose source, receivers, measuring operator, observed data & std
[gerjoii_,parame_] = dc_electrodes(geome_,parame_,finite_,gerjoii_,i_e);
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