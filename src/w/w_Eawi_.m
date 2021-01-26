function Eawi_ = w_Eawi_(T,d,do)
%
% diego domenzain
% 2020 at Mines. Covid year.

[nt,nr]= size(do);
Eawi_  = 0;
for ir = 1:nr
  d_r = d(:,ir);
  do_r= do(:,ir);
  
  % wiener filter a la lluis
  a = wiener_filter(do_r,d_r);
  
  % objective function value
  Eawi = w_Eawi(a,T);
  Eawi_= Eawi_ + Eawi;
end
Eawi_ = Eawi_/nr;
end