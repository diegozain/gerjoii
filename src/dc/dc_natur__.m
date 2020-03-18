function d = dc_natur__(geome_,parame_,finite_,gerjoii_,i_e)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% runs 2.5D ER forward model for one source-sink pair (indexed by input 'i_e').
% this program reads sources and receivers made in experim_wdc.m or experim_dc.m.
% it then goes on to shoot and record electric voltage data.
% -
% each survey line is passed out of this function as d_o.
% ..............................................................................
% choose source, receivers, measuring operator, observed data & std,
% and ky-fourier coefficients and w weights for 2.5d transform
[parame_,gerjoii_,finite_] = dc_load2_5d(parame_,gerjoii_,finite_,i_e);
gerjoii_ = dc_electrodes(geome_,parame_,finite_,gerjoii_);
% ..............................................................................
% build M for that source
gerjoii_ = dc_M(finite_,gerjoii_);
% ..............................................................................
% expand to robin
[parame_,~] = dc_robin( geome_,parame_,finite_ );
% ..............................................................................
% fwd model
[gerjoii_,finite_] = dc_fwd2_5d( parame_,finite_,gerjoii_ );
d = gerjoii_.dc.d;
% ..............................................................................
if mod(i_e,10)==0
  fprintf('   just finished er fwd models before shots #%i\n',i_e+1);
end
end