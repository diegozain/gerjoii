function [s,a] = w_ernst(d,d_o,s)
% give estimate of source signature according to Pratt:
% Application of a new 2D time-domain full-waveform inversion scheme to crosshole radar data
%
% d and d_o are synthetic and observed shot gathers of size (nt by nr).
% s is initial guess for source of size (nt by 1).
% a is filter used for source estimation.
% 
% returns s in time domain.

% fourier all
[nt,~] = size(d);
d    = fourier_d(d);
d_o_ = fourier_d(d_o);
s    = fourier_d(s);
% sizes and stuff
[nt_,~]= size(d);
a      = zeros(nt_,1);
% pratt's least squares update
for i_=1:nt_
  di_ = d(i_);
  di_o_ = d_o_(i_);
  a(i_) = di_o_ ./ (di_+1e-10);
end
% convolve
s = s .* a;
% bring back to time
s = ifourier_d_(s,nt);
s = real(s);
a = ifourier_d_(a,nt);
a = real(a);
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function d = fourier_d(d)
  % given d of size (nt by nr),
  % compute fourier transform for the time direction.
  % this method returns d_ unshifted and padded.

  [nt,nr] = size(d);
  % fft can't do this by itself so we help it,
  nt_=2^nextpow2(nt);
  nt_extra = nt_-nt;
  d_extra = [d; zeros(nt_extra,nr)];
  % t data to f domain
  d = fft(d_extra,[],1);
  
  % df = 1/dt/nt_;
  % f = (-nt_/2:nt_/2-1)*df;

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
  [nt_,~] = size(d_);
  nt_extra = nt_-nt;
  d_ = d_(1:end-nt_extra, : );
end