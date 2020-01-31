function [dsigma,step_,Edc] = dc_update_2d(geome_,parame_,finite_,gerjoii_,i_e)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% clean w first
if isfield(gerjoii_,'w')
  gerjoii_=rmfield(gerjoii_,'w');
end
if isfield(parame_,'w')
  parame_=rmfield(parame_,'w');
end
if isfield(finite_,'w')
  finite_=rmfield(finite_,'w');
end
% ..............................................................................
% choose source, receivers, measuring operator, observed data & std
[parame_,gerjoii_] = dc_load(parame_,gerjoii_,i_e);
gerjoii_ = dc_electrodes(geome_,parame_,finite_,gerjoii_);
% ..............................................................................
% build M for that source
gerjoii_ = dc_M(finite_,gerjoii_);
% ..............................................................................
% --------
%   update
% --------
% ..............................................................................
% expand to robin
[parame_,~] = dc_robin( geome_,parame_,finite_ );
% ..............................................................................
% fwd model
[gerjoii_,finite_] = dc_fwd2d( parame_,finite_,gerjoii_ );
% ..............................................................................
% attenuate noise
% signal = 1./(parame_.natu.dc.std_2d + 1);
% gerjoii_.dc.e_2d = signal .* gerjoii_.dc.e_2d;
% % i_amps = gerjoii_.dc.s_i_r_d_std{ i_e }{ 1 }(3);
% % gerjoii_.dc.e_2d = i_amps * gerjoii_.dc.e_2d;
% ..............................................................................
% obj
% Edc = 0.5*( gerjoii_.dc.e_2d.' * gerjoii_.dc.e_2d);
Ndc = sparse_diag(ones(size(parame_.natu.dc.std_2d)));
Edc = dc_E(parame_.natu.dc.d_2d,gerjoii_.dc.d_2d,Ndc,gerjoii_.dc.obj_FNC);
Edc = Edc / ( parame_.natu.dc.d_2d(:).' * parame_.natu.dc.d_2d(:) );
% ..............................................................................
% gradient of data
gerjoii_ = dc_gradient_2d( parame_,finite_,gerjoii_ );
% ..............................................................................
% reference conductivity
sigma_error = parame_.dc.sigma-parame_.dc.sigma_o;
gerjoii_.dc.sigma_error = sigma_error;
% ..............................................................................
% filter gradient
gerjoii_ = dc_regularize_2d( gerjoii_ );
% ..............................................................................
% xgrad push 
if isfield(gerjoii_,'wdc')
  if strcmp(gerjoii_.wdc.sig_too,'YES')
    % ..........................................................................
    % push, low-pass space-frequency, and normalize
    % ..........................................................................
    gerjoii_.dc.g_2d = gerjoii_.dc.g_2d - gerjoii_.wdc.dsigmx.';
    ax = gerjoii_.dc.regu.ax; 
    az = gerjoii_.dc.regu.az;
    gerjoii_.dc.g_2d = image_gaussian(full(gerjoii_.dc.g_2d),az,ax,'LOW_PASS');
    gerjoii_.dc.g_2d = normali(gerjoii_.dc.g_2d);
  end
end
% ..............................................................................
% step size
if isfield(gerjoii_.dc,'pica_me')
  step_ = dc_pica( geome_,parame_,finite_,gerjoii_ );
else
  step_ = dc_stepparabola_2d(geome_,parame_,finite_,gerjoii_,Edc);
end
% ..............................................................................
% update
dsigma = -step_*gerjoii_.dc.g_2d(:);
% ..............................................................................
end
