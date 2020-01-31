function d = hmo_inv(d,d_hmo,t,rx,dsr,v,to)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% inverse hyperbolic moveout of a shot-gather
% ..............................................................................
[nt,nr] = size( d );
t_h = zeros(nr,1);
% to binned
ito = binning(t,to);
% receiver distance from source
% rx = 0:drx:(drx*(nr-1));
rx = rx-rx(1);
dsR = (rx + dsr).';
% loop in receivers
for ir=1:nr
  % time 
  t_ = sqrt( ((dsR(ir)^2 - dsr^2)/v^2) + to^2 );
  % collect hyperbolic times
  t_h(ir) = t_;
  % correct for to
  t_ = t_-to;
  if or(t_<t(1),t_>t(nt))
    break;
  end
  % bin t_
  it_ = binning(t,t_);
  % shift
  d( it_:nt , ir ) = d_hmo( 1:nt-it_+1 , ir );
end
end