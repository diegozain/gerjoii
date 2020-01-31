function d_lmo = lmo(d,t,rx,vel_t)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% do linear moveout to d (t by cmp) gather.
% ..............................................................................
% 1. initialize d_lmo as zero matrix (t_o by csg). t = t_o.
% 2. choose pair (to,vt). to is from t, vt is from vel_t.
% 3. for each trace in d, i.e. choose r, do 4 and 5
% 4. compute what time it should become from t using linear moveout.
% 5. compute nmoed amplitude for this particular (to,vt).
% ..............................................................................
[nt,nr] = size( d );
d_lmo = zeros( nt,nr );
rx = rx-rx(1);
if numel(vel_t) == 1
  % get time to shift
  t__ = rx./vel_t; % [ns]
  for ir=1:nr
    % get time zero for given receiver
    t_ = t__(ir);
    % get time-zero in time-index
    it_ = binning(t,t_);
    % shift 
    d_lmo( 1:nt-it_+1 , ir ) = d( it_:nt , ir );
  end
end
if numel(vel_t) > 1
  vel_t = repmat( vel_t,[nt,1] );
  for i=1:nt
    to = t(i);
    vt = vel_t(i);
    for j=1:nr
      x = rx(j);
      t_ = t_reflect( to, x, vt ); 
      d_lmo(i,j) = lmo_interpol( d(:, j), t, t_ ); 
    end
  end
end
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function t_ = t_reflect(to, x, vt)
t_ = to + (x/vt);
end
function amp_nmo = lmo_interpol(d, t, t_)
amp_nmo = d( binning(t,t_) );
end
%{
nr = 8; nt = 100;
r = linspace(1,5,nr);
t = linspace(0,10,nt);
vt = 2;
d = zeros(nt,nr);
for i=1:10:nt
  for j=1:nr
    t_ = t(i) + (r(j)/vt);
    it_ = binning( t,t_ );
    d(it_,j) = 1;
  end
end
figure;imagesc(r,t,d); colorbar;axis image
vel_t = vt/2;
d_lmo = nmo(d,t,r,vel_t);
figure;imagesc(r,t,d_lmo); colorbar;axis image
%}
