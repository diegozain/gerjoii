function dtu_ = dtu(u,dt)
% diego domenzain
% fall 2018 @ BSU
% ------------------------------------------------------------------------------
% takes time derivative
% of an (nt x 1) time-series u.
%
% 2nd degree accurate.
%
nt = numel(u);
dtu_ = zeros(nt,1);
%
dtu_(1)     = (1/(dt)) * ((-3/2)*u(1) + 2*u(2) - (1/2)*u(3));
dtu_(2:nt-1) = (1/(dt)) * ((-1/2)*u(1:nt-2) + (1/2)*u(3:nt));
dtu_(nt)     = (1/(dt)) * ((3/2)*u(nt) - 2*u(nt-1) + (1/2)*u(nt-2));
%
dtu_ = dtu_.';
end
