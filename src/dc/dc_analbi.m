function u_2l = dc_analbi(n,m,DELTAS,s_dc,i_amps,sigma_1,sigma_2,h,n_accu)
%
% compute analytical solution u in 2.5d
% for a 2 layered halfspace,
%
% - sig * div( grad( u ) ) = i*s,
%
% u = - ( i / (pi*sigma_1) ) * sum( a - a_)

[CO,ca] = dc_coca(n,m,DELTAS,s_dc);

r  = sqrt(CO(:,:,1).^2 + ca(:,:).^2);
r_ = sqrt(CO(:,:,2).^2 + ca(:,:).^2);

b = (sigma_1-sigma_2)/(sigma_1+sigma_2);
I_ = 1:n_accu;

b = b.^I_;

a  = zeros(n,m);
a_ = zeros(n,m);

for i_=1:n_accu
	a  = a  +  2*b(i_) * log(sqrt( r.^2  + (2*i_*h)^2 ));
	a_ = a_ +  2*b(i_) * log(sqrt( r_.^2 + (2*i_*h)^2 ));
end

a  = log(r) + a;
a_ = log(r_) + a_;

u_2l = - ( i_amps / (pi*sigma_1) ) * (a - a_);

end


%h = 1.6;
%sigma_1 = 0.2;
%sigma_2 = 0.2;
%n_accu = 10;

%figure(101)
%contour(X,Y,u_2l',I)
%axis ij
%axis image
%colorbar


