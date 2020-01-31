function filter_ = w_bleistein(t,sR,v_)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% computes time-frequency domain filter for 
% 2.5d -> 2d wavefield transform on observed data.
%
% assumes velocity is constant everywhere.
%
% See: 
% Norman Bleistein. Two-and-one-half dimensional in-plane wave propagation.
% Geophysical Prospecting
%
% frequency vector f has to be in this format:
% 
nt = numel(t);
nt_=2^nextpow2(nt);
dt = t(2)-t(1);
df = 1/dt/nt_;
f = (-nt_/2:nt_/2-1)*df;
f = f.';

f(f==0) = 1;

filter_ = ( sqrt( 1./abs(f) ) .* exp((i/4)*sign(f)) ) * sqrt(sR.');
filter_ = sqrt(v_)*filter_;
end