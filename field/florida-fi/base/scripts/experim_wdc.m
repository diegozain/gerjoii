% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
%
%   wave experiments
%
% ..............................................................................
% builds experiment parameters.
% 
% depends on structures: 
% 
%     parame_, finite_ and geome_
%
% structure gerjoii_ has to be defined already,
% so when joining with the dc it doesn't get re-written.
% ------------------------------------------------------------------------------
% all type of sources.
% lo wavelength [m]
parame_.w.lo = parame_.w.c/( sqrt( parame_.w.eps_max ))/parame_.w.fo;
% round to nearest-bigger decimal (e.g. 0.561924 -> 0.6)
parame_.w.lo = ceil( parame_.w.lo/0.1 )*0.1;
% ------------------------------------------------------------------------------
% optional: number of sources
gerjoii_.w.ns = 30;
% mute?
gerjoii_.w.MUTE = parame_.w.MUTE;
% ..............................................................................
%
%   dc experiments
%
% ..............................................................................
gerjoii_.dc.electr_real  = parame_.dc.electr_real;
gerjoii_.dc.n_electrodes = parame_.dc.n_electrodes;
gerjoii_.dc.n_exp        = parame_.dc.n_exp;
