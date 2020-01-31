function [t_,z] = v_hyperbola(v,to,rx,dsr);
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% compute hyperbola in time as a function of source-receivers geometry and 
% cummulative velocity at depth for a given pick of (velocity,to) from 
% the hyperbolic velocity semblance.
% ------------------------------------------------------------------------------
% distance from source to recs
dsR = dsr + (rx-rx(1));
% depth
z = v*sqrt( (to/v)^2 - (dsr/(2*v))^2 );
% time 
t_ = 2*sqrt( (dsR./(2*v)).^2 + (z/v)^2 );
% time and depth together
t_ = sqrt( ((dsR.^2 - dsr^2) ./ (v^2)) + to^2 );
end