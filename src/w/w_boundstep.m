function k = w_boundstep(epsi,depsi,epsi_max_)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% build nice vectors with [min,max]
depsi_=min(depsi(:));
depsi__=max(depsi(:));
%
epsi_min=min(epsi(:));
epsi_max=max(epsi(:));
% epsi = [epsi_min,epsi_max];
% get bounds
% this comes from bounding the update with possible values,
% between relative permittivity of 1 and the max our model can handle:
%
% 1 < epsi * exp(k*epsi*depsi) < epsi_max_
% 0 < log(epsi) + k*epsi*depsi < log(epsi_max_)
%
% since the update direction is assumed good,
% we only have to be careful about wether depsi is pos or neg
% when solving for k (epsi>1 always):
% 
%    -log(epsi)/epsi/depsi < k < log(epsi_max)/epsi/depsi  for depsi>0
% log(epsi_max)/epsi/depsi < k <  -log(epsi)/epsi/depsi    for depsi<0
%
neg=-log(epsi)./(epsi .* depsi );
neg = neg(find(depsi < 0));
neg = min(neg(:));
pos=log(epsi_max_)./(epsi.* depsi );
pos = pos(find(depsi > 0));
pos = min(pos(:));
% get bound from bounds
% the idea for the damper is:
%
% epsi_min close to epsi_max ---> allows more dynamic range (damper<damper below)
% epsi_min far from epsi_max ---> allows less dynamic range (damper>damper above)
damper = ((epsi_max-epsi_min)/(epsi_max+epsi_min))^2 +...
 (epsi_max-epsi_min) + 1/(epsi_max+epsi_min);
% the minimum value of neg,pos is the one that ensures
% we're good to go on the low side (epsi=1),
% but we still need to correct for upper bound (epsi=epsi_max_)
k=min([neg,pos])*(1/( damper*( epsi_max_ ) ));
end