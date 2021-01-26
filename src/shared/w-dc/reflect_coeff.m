function R = reflect_coeff(epsi,epsi_,sigm,sigm_,mu,mu_,fo)

% sigm in S/m
% fo in Hz
% epsi in relative (fix this)
% mu in relative (fix this)

wo = 2*pi*fo; % rad

muo = 4*pi*1e-7; % H/m
epsio = 8.8541878128*1e-12; % F/m

epsi = epsi*epsio;
epsi_= epsi_*epsio;

mu = mu*muo;
mu_= mu_*muo;

v = 1./sqrt(mu.*epsi);
v_= 1./sqrt(mu_.*epsi_);

k_ = wo * sqrt(epsi_.*mu_/2) .* sqrt( sqrt(1 + (sigm_./(epsi_.*wo))^2) + 1);
ki_= wo * sqrt(epsi_.*mu_/2) .* sqrt( sqrt(1 + (sigm_./(epsi_.*wo))^2) - 1);

K_ = k_ + 1i*ki_;

b = ( (mu.*v) ./ (mu_.*wo) ) .* K_;

R = abs( (1-b) ./ (1+b) );

end