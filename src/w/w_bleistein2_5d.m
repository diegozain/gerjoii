function filter_ = w_bleistein2_5d(f)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% computes frequency dependent part for the full bleistein filter, 
% i.e. this part is to be combined with p=w_rayparam() to get 
% the full filter.
%
% See: 
% Norman Bleistein. Two-and-one-half dimensional in-plane wave propagation.
% Geophysical Prospecting
%
% frequency vector f has to be in this format:
% 
% nt = numel(t);
% nt_=2^nextpow2(nt);
% df = 1/dt/nt_;
% f = (-nt_/2:nt_/2-1)*df;

w=2*pi*f;
filter_ = exp(-sign(w)*(i*pi*0.25)) * sqrt(abs(w)/(2*pi));

end