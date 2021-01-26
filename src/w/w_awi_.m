function [s_adj_,Eawi_] = w_awi_(T,d,do,dt,f_high)
%
% diego domenzain
% 2020 at Mines. Covid year.
%
% compute the adjoint sources for all traces in a shot-gather
% using the AWI scheme as detailed in:
% 
% Adaptive waveform inversion: Practice
% Lluís Guasch, Michael Warner, and Céline Ravaut
% ------------------------------------------------------------------------------
% f_high = parame_.w.f_high*1e-9
% dt = parame_.w.dt*1e+9
% ------------------------------------------------------------------------------
[nt,nr]= size(do);
s_adj_ = zeros(nt,nr);
Eawi_  = 0;
for ir = 1:nr
  d_r = d(:,ir);
  do_r= do(:,ir);
  
  % wiener filter a la lluis
  a = wiener_filter(do_r,d_r);
  
  % objective function value
  Eawi = w_Eawi(a,T);
  Eawi_= Eawi_ + Eawi;
  
  % magic happens here
  s_adj = w_awi(a,Eawi,T,do_r);
  s_adj_(:,ir) = s_adj;
end
Eawi_ = Eawi_/nr;
% adjoint sources are pretty wild, so let's low-pass them
s_adj_ = filt_gauss(s_adj_,dt,-f_high,f_high,10);
% adjoint sources are tiny :(
res = d-do;
res = filt_gauss(res,dt,-f_high,f_high,10);
s_adj_ = max(abs(res(:)))*normali(s_adj_);
end