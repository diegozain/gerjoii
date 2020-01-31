function alph = w_attenucoeff_dc(sigm_dc,epsi,muo,omeg)
% compute attenuation coefficient.
% ------------------------------------------------------------------------------
epsi = epsi*8.85e-12;
% ------------------------------------------------------------------------------
alph = omeg.*(muo/2*epsi.*(sqrt(1+(sigm_dc./omeg./epsi).^2)-1)).^.5;
% ------------------------------------------------------------------------------
% alph = ( sigm_dc*0.5 ) .* sqrt( muo./epsi ) ;
end
% dry sand
% eps_dc=5.7; eps_inf=3.4; tau=8; gamma=0.7; sigm_dc=0.45*1e+3; muo=4*pi*1e-7;
% [epsi,epsi_] = w_colecole(eps_inf,eps_dc,omeg,tau,gamma);
% alph = w_attenucoeff(sigm_dc,epsi,epsi_,muo,omeg);
% figure;plot(f,alph)