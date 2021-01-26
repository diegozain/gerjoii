function R = reflect_coeff_(epsi,epsi_,sigm,sigm_,mu,mu_,fo)

% epsi relative (e/eo)
% mu relative (mu/muo)
% sigm = sigm/(muo*epsio) where sigm is in S/m, muo is in H/m, epsio is in F/m

muo = 4*pi*1e-7; % H/m
epsio = 8.8541878128*1e-12; % F/m

wo = 2*pi*fo; % rad

v = 1/(mu.*epsi);
v_= 1/(mu_.*epsi_);

sigm = sigm/(muo*epsio);
sigm_= sigm_/(muo*epsio);

k_ = wo * sqrt(epsi_.*mu_/2) .* sqrt( sqrt(1 + (sigm_./(epsi_.*wo))^2) + 1);
ki_= wo * sqrt(epsi_.*mu_/2) .* sqrt( sqrt(1 + (sigm_./(epsi_.*wo))^2) - 1);

K_ = k_ + 1i*ki_;

b = ( (mu.*v) ./ (mu_*wo) ) .* K_;

R = abs( (1-b) ./ (1+b) );

end