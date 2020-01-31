function [d,t,t_sr] = w_timeshift(d,t,v,dsr,t_fa)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% time shift a (time by receiver) data to begin at t=0 when source was shot.
% relative to linear arrival v, source-receiver spacing dsr,
% and first arrival time t_fa.
% returns both d and t shifted.
% ------------------------------------------------------------------------------
[nt,nr]=size(d);
dt=abs(t(2)-t(1));
% using velocity of propagation and dsr get time from src to first rec
t_sr = dsr/v;
% get time-zero (when src originated)
t_zero = t_fa - t_sr;
% get time-zero in time-index
it_zero = binning(t,t_zero);
% shift
d = d( it_zero:nt, : );
t=dt*(0:(size(d,1)-1));
end