function [d,t] = interp_fourier1d(d,t,dt,dt_)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
nt = numel(d);
% interpolate
n_interp = ceil((dt*nt-dt_)/dt_);
d = interpft(d,n_interp,1);
t = (t(1):dt_:t(end)).';
whos t
whos d
d = d(1:numel(t));
end