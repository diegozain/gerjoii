function s_adj = w_awi(a,Eawi,T,do)
%
% diego domenzain
% 2020 at Mines. Covid year.
%
% compute the adjoint source using the AWI scheme as detailed in:
% Adaptive waveform inversion: Practice
% Lluís Guasch, Michael Warner, and Céline Ravaut
% ------------------------------------------------------------------------------
% a is the weiner filter matching synthetic d with observed d (in time domain)
% Eawi is the objective function value of the AWI scheme
% T is a weird weight diagonal matrix
% do is the observed data
%
% s_adj is the adjoint source
% ------------------------------------------------------------------------------
nt= numel(a);
a = (T^2 - 2*Eawi*eye(nt)) * (a/(a.'*a));
% fourier all
a = fourier_d(a);
do= fourier_d(do);
% sizes and stuff
nt_= numel(a);
s_adj = zeros(nt_,1);
% lluis's adjoint source
for i_=1:nt_
  ai_  = a(i_);
  do_i_= do(i_);
  s_adj(i_) = (do_i_/(do_i_*do_i_')) * ai_;
end
% bring back to time
s_adj = ifourier_d_(s_adj,nt);
s_adj = real(s_adj);
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