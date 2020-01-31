function s = w_pratt_src(d,d_o,s,dt,gaussian_)
% update source a la Pratt:
% Seismic waveform inversion in the frequency domain,
% Part 1: Theory and verification in a physical scale model
% ------------------------------------------------------------------------------
% transform to real waveform (not-Yee)
s = -dtu(s,dt);
% ------------------------------------------------------------------------------
% apply wiener fielter for all frequencies
[s,a] = w_wiener(d,d_o,s);
% ------------------------------------------------------------------------------
% mute around selected event
s  = s.*gaussian_;
% nt= numel(s);
% s = s.*tukeywin(nt,0.1);
% ------------------------------------------------------------------------------
% bring back to Yee grid
s =-integrate(double(s),dt,0);
s = s.*gaussian_;
end