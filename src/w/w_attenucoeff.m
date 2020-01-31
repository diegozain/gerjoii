function alph = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg)
% compute attenuation coefficient.
% ------------------------------------------------------------------------------
% alph = ( (sigm_dc + (epsi_/8.85e-12).*omeg)*0.5 ) .* sqrt( muo./(epsi/8.85e-12) ) ;
% ------------------------------------------------------------------------------
epsi = epsi*8.85e-12;
sigmw= sigm_dc + omeg.*epsi_*8.85e-12;
alph = omeg.*(muo/2*epsi.*(sqrt(1+(sigmw./omeg./epsi).^2)-1)).^.5;
end
% dry sand
% eps_dc=5.7; eps_inf=3.4; tau=8; gamma=0.7; sigm_dc=0.45*1e+3; muo=4*pi*1e-7;
% [epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamma);
% alph = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
% figure;plot(f,alph)