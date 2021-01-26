function [d,s] = wiener(d,do,s)
% build and apply a wiener filter 'a' that 
% matches d to do. 
if nargin<3
  s = d;
end
nt = numel(d);
% fourier all
d = fourier_d(d);
do= fourier_d(do);
s = fourier_d(s);
% % ---
% % magic # 1
% a = do ./ (d+ 1e-4);% 1e-4);
% ---
% magic # 2
% works well. from Lisa Groos,
% The role of attenuation in 2D full-waveform inversionof shallow-seismic body and Rayleigh waves
a = zeros(size(d));
for i_=1:numel(d)
a(i_) = do(i_)*d(i_)' / (d(i_)*d(i_)' + 1e-10);
end
% convolve
d = a .* d;
s = a .* s;
% bring back to time
d = ifourier_d_(d,nt);
d = real(d);
% -
s = ifourier_d_(s,nt);
s = real(s);

% nt_=2^nextpow2(nt);
% dt=0.1061;
% a = fftshift(a,1);
% a = a( ceil(nt_/2)+1:nt_-1, : );
% df= 1/dt/nt_;
% f = (-nt_/2:nt_/2-1)*df;
% f = f( ceil(nt_/2)+1:nt_-1 );
% figure;
% plot(f,abs(a))
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function d = fourier_d(d)
  % given d of size (nt by nr),
  % compute fourier transform for the time direction.
  % this method returns d_ unshifted and padded.

  nt = numel(d);
  % fft can't do this by itself so we help it,
  nt_=2^nextpow2(nt);
  nt_extra = nt_-nt;
  d_extra = [d; zeros(nt_extra,1)];
  % t data to f domain
  d = fft(d_extra,[],1);
  
  % df= 1/dt/nt_;
  % f = (-nt_/2:nt_/2-1)*df;
  % f = f( ceil(nt_/2)+1:nt_-1 );

  % % ifft would go here, BEFORE fftshift
  % d = ifft(d_);
  % % trim padded zeros because fft can't do this by itself
  % d = d(1:end-nt_extra, : );
  % % d would now be (up to machine precission),
  % % identical to original d (same size even).
end

function d_ = ifourier_d_(d_,nt)
  % given d_ of size (nf by nr),
  % compute its fourier inverse d of size (nt by nr).
  % d_ has to be unshifted and padded.
  d_ = ifft(d_,[],1);
  % crop down padded stuff
  nt_ = numel(d_);
  nt_extra = nt_-nt;
  d_ = d_(1:end-nt_extra);
end