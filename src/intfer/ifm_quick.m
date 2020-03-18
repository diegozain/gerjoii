function [Ba, cg_a, t_corr] = ifm_quick(d,dt,T_,a,f_low,f_high)
% 
% do a quick and dirty virtual gather: you don't have to think too much.
% ---
% Ba is virtual receiver gather of size (nt by nr),
%    i.e. (time by recs) for src 'a'.
% cg_a is correlation gather for source 'a'.
% t_corr is correlation time.
% ---
% d is one component data (nt by nr), ALL stations.
% T_ is time interval to split data into "sources".
% a is index of virtual source, eg d(:,a) is virtual source trace in d.
% ------------------------------------------------------------------------------
% bandpass
nbutter = 10;
d = butter_butter(d,dt,f_low,f_high,nbutter);
d = filt_gauss(d,dt,f_low,f_high,nbutter);
% ------------------------------------------------------------------------------
% window the data
% % ----
% % windows data d(t,r) for ns slices of time samples,
% % ns is an integer -> # of sources.
% d_windowed = window_d(d,ns);
% ----
% windows data d(t,r) for equal slices of time T_,
% T_ is a real number.
[Bs,ns] = window_dT(d,T_,dt);
% ------------------------------------------------------------------------------
% cross correlation
% ---------------
% Bs: shot gather with sources s and receivers b, size (time,recs,sources).
% a: index of receiver a
% dt: obvious.
% ---------------
% Ba: shot gather with source a and receivers b
% cg_a: correlation gather with source a and receivers b
% t_corr: correlation time of size 2t-1.
% ---------------
[Ba, cg_a, t_corr] = ifm_xcorr(Bs,a,dt);
end