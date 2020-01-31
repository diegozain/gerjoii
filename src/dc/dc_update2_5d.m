function [dsigma,step_,Edc,v_curr] = dc_update2_5d(geome_,parame_,finite_,gerjoii_,i_e)
% diego domenzain
% fall 2019 @ BSU
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
% choose source, receivers, measuring operator, observed data & std,
% and ky-fourier coefficients and w weights for 2.5d transform
[parame_,gerjoii_,finite_] = dc_load2_5d(parame_,gerjoii_,finite_,i_e);
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
[gerjoii_,finite_] = dc_fwd2_5d( parame_,finite_,gerjoii_ );
% ..............................................................................
% current potential
% v_curr = gerjoii_.dc.u.';
% v_curr = reshape(v_curr,[finite_.dc.nx,finite_.dc.nz]);
v_curr = gerjoii_.dc.u;
v_curr = v_curr(1+parame_.dc.robin:finite_.dc.nx-parame_.dc.robin,...
                1:finite_.dc.nz-parame_.dc.robin);
% v_curr = full( v_curr );
% v_curr = smooth2d(v_curr,gerjoii_.dc.regu.az,gerjoii_.dc.regu.ax);
v_curr = abs(v_curr(:));
% ..............................................................................
% attenuate noise
% signal = 1./(parame_.natu.dc.std_ + 1);
% gerjoii_.dc.e_ = signal .* gerjoii_.dc.e_;
% % i_amps = gerjoii_.dc.s_i_r_d_std{ i_e }{ 1 }(3);
% % gerjoii_.dc.e_ = i_amps * gerjoii_.dc.e_;
% ..............................................................................
% obj
% Edc = 0.5*( gerjoii_.dc.e_.' * gerjoii_.dc.e_);
Ndc = sparse_diag(ones(size(parame_.natu.dc.std_)));
Edc = dc_E(parame_.natu.dc.d,gerjoii_.dc.d,Ndc,gerjoii_.dc.obj_FNC);
Edc = Edc / ( parame_.natu.dc.d(:).' * parame_.natu.dc.d(:) );
% ..............................................................................
% gradient of data
gerjoii_ = dc_gradient2_5d( parame_,finite_,gerjoii_ );
% ..............................................................................
% reference conductivity
sigma_error = parame_.dc.sigma-parame_.dc.sigma_o;
gerjoii_.dc.sigma_error = sigma_error;
% ..............................................................................
% filter gradient
gerjoii_ = dc_regularize2_5d( gerjoii_ );
% ..............................................................................
% xgrad push 
if isfield(gerjoii_,'wdc')
  if strcmp(gerjoii_.wdc.sig_too,'YES')
    % ..........................................................................
    % push, low-pass space-frequency, and normalize
    % ..........................................................................
    gerjoii_.dc.g = gerjoii_.dc.g - gerjoii_.wdc.dsigmx.';
    ax = gerjoii_.dc.regu.ax; az = gerjoii_.dc.regu.az;
    gerjoii_.dc.g = image_gaussian(full(gerjoii_.dc.g),az,ax,'LOW_PASS');
    gerjoii_.dc.g = normali(gerjoii_.dc.g);
  end
end
% ..............................................................................
% step size
if isfield(gerjoii_.dc,'pica_me')
  step_ = dc_pica2_5d( geome_,parame_,finite_,gerjoii_ );
else
  step_ = dc_stepparabola2_5d(geome_,parame_,finite_,gerjoii_,Edc);
end
% ..............................................................................
% update
dsigma = -step_*gerjoii_.dc.g(:);
% ..............................................................................
end
