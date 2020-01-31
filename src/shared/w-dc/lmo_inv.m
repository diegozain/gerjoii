function d = lmo_inv(d,d_lmo,t,rx,vel_t)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% inverse linear moveout of a shot-gather
% ..............................................................................
[nt,nr] = size( d );
rx = rx-rx(1);
% get time to shift
t__ = rx./vel_t; % [ns]
for ir=1:nr
  % get time zero for given receiver
  t_ = t__(ir);
  % get time-zero in time-index
  it_ = binning(t,t_);
  % shift 
  d( it_:nt , ir ) = d_lmo( 1:nt-it_+1 , ir );
end
end