function u = w_2d_2_5d(u,s,vz,filter_,sinbeta)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% transforms wavefield u computed with a 2d solver
% into a 2.5d wavefield.
% See: 
% Norman Bleistein. Two-and-one-half dimensional in-plane wave propagation.
% Geophysical Prospecting
%
% s is source position (x,z) coordinates.
% vz is vertical velocity profile.
% filter_ is frequency half of bleistein filter.
% sinbeta is the sine of beta where beta is the angle between s and a pt (x,z).
%


[nt,nr] = size(d);

% -------------
% fft wavefield
% -------------
[nz,nx,nt] = size(u);
% fft can't do this by itself so we help it,
nt_=2^nextpow2(nt);
nt_extra = nt_-nt;
u_extra = cat( 3,u,zeros(nz,nx,nt_extra) );
% t data to f domain
f_u_f = fft(u_extra,[],3);
% df = 1/dt/nt_;
% f = (-nt_/2:nt_/2-1)*df;

% ----------------
% bleistein filter
% ----------------
% check units of c in w_eps2vz      % <-----------
% code w_sinbeta.m                  % <-----------
p = w_rayparam(nx,nz,s,sinbeta,vz);   % <-----------
% % make this a 3d multiplication   % <-----------
% filter_ = filter_ .* sqrt(1./p);
f_u_f = f_u_f .* filter_;

% ---------------
% ifft wavefield
% ---------------
u = ifft(f_u_f,[],3);
% trim padded zeros because fft can't do this by itself
u = u(:,:,1:end-nt_extra);

end