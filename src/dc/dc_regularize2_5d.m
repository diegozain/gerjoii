function gerjoii_ = dc_regularize2_5d(gerjoii_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% regularize adjoint gradient g by suppressing k-frequencies larger 
% than (ax,az) [1/m].
% 
% choose (ax,az) in order to smear together objects in the xz-plane that
% are (1/ax,1/az) apart.
% 
% for example, if a-spacing is 1 on dipole-dipole, then receivers that are 
% 'a' apart should be smeared together to remove singularities in adjoint, 
% so a good choice is ax<1 [1/m]. ax=0.5 [1/m] seems to work great.
% 
% example:
% ax = 0.5; az = 0.5; % [1/m]
% ax = ax*geome_.dx; az = az*geome_.dy;

ax = gerjoii_.dc.regu.ax; az = gerjoii_.dc.regu.az;
g = full( gerjoii_.dc.g );
[g,g_,filt_] = image_gaussian(g,az,ax,'LOW_PASS');
g = g/max(abs(g(:)));
g_ = abs(g_)/max(abs(g_(:)));

% reference conductivity
sigma_error = gerjoii_.dc.sigma_error;
if max(abs(sigma_error(:))) > 0
  beta_ = gerjoii_.dc.regu.beta_;
  sigma_error = image_gaussian(sigma_error,az,ax,'LOW_PASS');
  sigma_error = normali(sigma_error);
  g = g + beta_*(sigma_error);
  g = g/max(abs(g(:)));
end

% ------------------------------
% ****---- experimental ----****
% ------------------------------

% total_g_ = sum(g_(:));
% signal_g_ = sum( g_(:) .* filt_(:) );
% beta_ = signal_g_/total_g_;
% fprintf(' signal = %2.2d\n',signal_g_ );
% fprintf(' beta   = %2.2d\n',beta_);

% dx = geome_.dx;
% dz = geome_.dy;
% g = full( gerjoii_.dc.g_2d );
% beta_ = gerjoii_.dc.regu.beta_;
% [g,ax,az,beta__] = find_axaz(g,dx,dz,beta_);
% g = g/max(abs(g(:)));
% % regularization parameters
% gerjoii_.dc.regu.ax=ax; gerjoii_.dc.regu.az=az;
% gerjoii_.dc.regu.beta__=beta__;

% update direction
gerjoii_.dc.g = g;

end

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

function [g,ax,az,beta__] = find_axaz(g,dx,dz,beta_)

ax=0; az=0; % [1/m]
increment=1e-1;
beta__ = 0;
while beta__ < beta_
  ax = ax+increment; az = az+increment; % [1/m]
  ax = ax*dx; az = az*dz;
  % compute filtered gradient, gradient in k-freq domain and k-filter (gaussian)
  [g__,g_,filt_] = image_gaussian(g,az,ax,'LOW_PASS'); 
  % normalize power in k-freq
  g_ = abs(g_)/max(abs(g_(:)));
  % compute:
  % \int g_ d\Omega and \int f*g_ d\Omega 
  % where \Omega is (kx,kz) domain.
  % then compute ratio to see if this matches our choice for beta, 
  % (d\Omega=dkx*dkz cancels out in division)
  total_g_ = sum(g_(:));
  signal_g_ = sum( g_(:) .* filt_(:) );
  beta__ = signal_g_/total_g_;
  % bring ax and az back to [1/m]
  ax = ax/dx; az = az/dz;
end
g=g__;
end