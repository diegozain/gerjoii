function s = w_pratt_src(d,d_o,s,dt,gaussian_,f_high)
% ------------------------------------------------------------------------------
% diego domenzain
% 
% update source a la Pratt:
% Seismic waveform inversion in the frequency domain,
% Part 1: Theory and verification in a physical scale model
% ------------------------------------------------------------------------------
% transform to real waveform (not-Yee)
s = -dtu(s,dt);
s = s.';
% ----------------------------------------------------------------------------
% get wiener *** magic ***
s = w_wiener(d,d_o,s);
% ------------------------------------------------------------------------------
% bring back to Yee grid
s =-integrate(double(s),dt,0);
s = s.*gaussian_;
s = filt_gauss(s,dt,-f_high,f_high,10);
s = s.*gaussian_;
end