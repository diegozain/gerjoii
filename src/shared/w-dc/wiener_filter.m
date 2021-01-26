function a = wiener_filter(d,do)
% build a wiener filter 'a' that 
% matches d to do. 

nt = numel(d);
% fourier all
d  = fourier_d(d);
do = fourier_d(do);
% sizes and stuff
nt_= numel(d);
a  = zeros(nt_,1);
% pratt's least squares update
for i_=1:nt_
  di_ = d(i_);
  di_o_ = do(i_);
  a(i_) = (di_*di_o_') / (di_*di_');
end
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

  nt = numel(d);
  % fft can't do this by itself so we help it,
  nt_=2^nextpow2(nt);
  nt_extra = nt_-nt;
  d_extra = [d; zeros(nt_extra,1)];
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
  nt_ = numel(d_);
  nt_extra = nt_-nt;
  d_ = d_(1:end-nt_extra);
end