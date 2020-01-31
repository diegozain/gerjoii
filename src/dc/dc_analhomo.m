function u_green = dc_analhomo(parame_,finite_,gerjoii_)
%
% compute analytical solution u in 2d
% for a homogeneous halfspace,
%
% - sig * div( grad( u ) ) = i*s,
%
% u = - ( i/(pi*sig) ) * ( log(r) - log(r_) )

n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;
DELTAS = finite_.dc.DELTAS;
% homogeneous conductivity
sig = parame_.dc.sigma(1);
% source 
s = gerjoii_.dc.s;
% current in Amperes. (under construction)
i_amps = 1;

[CO,ca] = dc_coca(n,m,DELTAS,s);

r  = sqrt(CO(:,:,1).^2 + ca(:,:).^2);
r_ = sqrt(CO(:,:,2).^2 + ca(:,:).^2);

u_green     = - (i_amps/ ( pi*sig ) ) * ( log(r) - log(r_) );

end
