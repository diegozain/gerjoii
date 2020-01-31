function [d,t] = interp_fourier(d,t,dt,dt_)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
[nt,nr] = size(d);
% interpolate
n_interp = ceil((dt*nt-dt_)/dt_);
d = interpft(d,n_interp,1);
t = (0:dt_:t(end)).';
d = d(1:numel(t),:);
end