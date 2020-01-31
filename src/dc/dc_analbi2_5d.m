function u_2l = dc_analbi2_5d(parame_,finite_,gerjoii_)
%
% compute analytical solution u in 2.5d
% for a 2 layered halfspace,
%
% - sig * div( grad( u ) ) = i*s,
%
% u = 

n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;
DELTAS = finite_.dc.DELTAS;
% 2 layered conductivity
sigma_1 = parame_.dc.sigma_1;
sigma_2 = parame_.dc.sigma_2;
h = parame_.dc.sigma_h;
n_accu_2l = parame_.dc.n_accu_2l;
% source 
s = gerjoii_.dc.s;
% current in Amperes. (under construction)
i_amps = 1;

[CO,ca] = dc_coca(n,m,DELTAS,s);

r  = sqrt(CO(:,:,1).^2 + ca(:,:).^2);
r_ = sqrt(CO(:,:,2).^2 + ca(:,:).^2);

b = (sigma_1-sigma_2)/(sigma_1+sigma_2);
I_ = 1:n_accu_2l;

b = b.^I_;

a  = zeros(n,m);
a_ = zeros(n,m);

for i_=1:n_accu_2l
	a  = a  +  2*b(i_) * 1./(sqrt( r.^2  + (2*i_*h)^2 ));
	a_ = a_ +  2*b(i_) * 1./(sqrt( r_.^2 + (2*i_*h)^2 ));
end

a  = 1./(r) + a;
a_ = 1./(r_) + a_;

u_2l = ( i_amps / (2*pi*sigma_1) ) * (a - a_);

end