function [d_hmo,t_h] = hmo(d,t,rx,dsr,v,to)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% do hyperbolic moveout to d (t by csg) gather.
% ------------------------------------------------------------------------------
% d is data matrix (time by receivers)
% t is time vector
% rx are real x-coordinates of receivers.
%    can be absolute or relative to source location.
% dsr is distance from source to closest receiver.
% v is vector of velocities to try.
% to is time when shot was made in t.
% ------------------------------------------------------------------------------
% let dsR be distance from source to receivers, i.e. 
% dsR = dsr + (rx-rx(1));
% depth
% z = v*sqrt( (to/v)^2 - (dsr/2/v)^2 );
% time 
% t_ = 2*sqrt( (dsR(ir)/2/v)^2 + (z/v)^2 );
% time and depth together
% t_ = sqrt( ((dsR(ir)^2 - dsr^2)/v^2) + to^2 );
% ------------------------------------------------------------------------------
% 1. initialize d_hmo as zero matrix (t_o by cmp). t = t_o.
% 2. choose pair (to,vt). to is from t, vt is from v.
% 3. for each trace in d, i.e. choose r, do 4 and 5
% 4. compute what time it should become from t using hyperbolic moveout.
% 5. compute nmoed amplitude for this particular (to,vt).
% ------------------------------------------------------------------------------
[nt,nr] = size( d );
d_hmo = zeros( nt,nr );
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
  d_hmo( 1:nt-it_+1 , ir ) = d( it_:nt , ir );
end
end
% ------------------------------------------------------------------------------
% example
% ------------------------------------------------------------------------------
%{
v=vel_;
to=to_;
drx=dr;
rx = 0:drx:(drx*(nr-1));
dsR = rx + dsr;
dummy = zeros(nt,nr);
for it=1:nt
  for ir=1:nr
    t_ = sqrt( ((dsR(ir)^2 - dsr^2)/v^2) + to^2 );
    % z = v*sqrt( (to/v)^2 - (dsr/2/v)^2 );
    % t_ = 2*sqrt( (dsR(ir)/2/v)^2 + (z/v)^2 );
    it_ = binning( t,t_ );
    dummy(it_,ir) = 1;
  end
end
figure;imagesc(rx,t,dummy); colorbar;axis normal

d_hmo = hmo(dummy,t,drx,dsr,v,to);
figure;imagesc(rx,t,d_hmo); colorbar;axis normal
%}
