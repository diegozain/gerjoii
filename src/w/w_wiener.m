function [s,a] = w_wiener(d,d_o,s)
% give estimate of source signature according to Pratt:
% Seismic waveform inversion in the frequency domain, Part 1: Theory and verification in a physical scale model
%
% d and d_o are synthetic and observed shot gathers of size (nt by nr).
% s is initial guess for source of size (nt by 1).
% a is filter used for source estimation.
% 
% returns s in time domain.

% fourier all
d_   = fourier_d(d);
d_o_ = fourier_d(d_o);
s_   = fourier_d(s);
% sizes and stuff
[nt_,~] = size(d_);
a_      = zeros(nt_,1);
% pratt's least squares update
for i_=1:nt_
  di_ = d_(i_,:);
  di_o_ = d_o_(i_,:)';
  a_(i_) = (di_*di_o_) / (di_*di_');
end
% bring back to time
s_ = a_ .* s_;
[nt,~] = size(d);
s = ifourier_d_(s_,nt);
s = real(s);
a = ifourier_d_(a_,nt);
a = real(a);
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function d_ = fourier_d(d)
  % given d of size (nt by nr),
  % compute fourier transform for the time direction.
  % this method returns d_ unshifted and padded.

  [nt,nr] = size(d);
  % fft can't do this by itself so we help it,
  nt_=2^nextpow2(nt);
  nt_extra = nt_-nt;
  d_extra = [d; zeros(nt_extra,nr)];
  % t data to f domain
  d_ = fft(d_extra,[],1);
  
  % df = 1/dt/nt_;
  % f = (-nt_/2:nt_/2-1)*df;

  % % ifft would go here, BEFORE fftshift
  % d = ifft(d_);
  % % trim padded zeros because fft can't do this by itself
  % d = d(1:end-nt_extra, : );
  % % d would now be (up to machine precission),
  % % identical to original d (same size even).
end

function d = ifourier_d_(d_,nt)
  % given d_ of size (nf by nr),
  % compute its fourier inverse d of size (nt by nr).
  % d_ has to be unshifted and padded.
  d = ifft(d_,[],1);
  % crop down padded stuff
  [nt_,~] = size(d_);
  nt_extra = nt_-nt;
  d = d(1:end-nt_extra, : );
end