function v_analy = v_hyperbolic(d,t,rx,dsr,v,to)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% get velocity analysis (hyperbolic velocity semblance) 
% from shot gather d(time,receivers)
% --
% d is data matrix (time by receivers)
% t is time vector
% rx are real x-coordinates of receivers.
%    can be absolute or relative to source location.
% dsr is distance from source to closest receiver.
% v is vector of velocities to try.
% to is time when shot was made in t. 
%     if t is corrected for t(1)=0, and t=0 is when shot was fired then 
%     to should be zero.
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
% v_analy is semblance matrix (time by velocity)
% ------------------------------------------------------------------------------
% get sizes
[nt,nr] = size( d );
nv = numel(v);
v_analy = zeros(nt,nv);
% chop to_ from t to begin at to
to_ = t(binning(t,to):nt);
% ------------------------------------------------------------------------------
% normalizer solves this problem:
% faster speed -> flatter hyperbola -> less hyperbolic moveout -> more stack
% ---------------------------------
% v_normalizer = (1./v).^2;
% ---------------------------------
v_normalizer = (nv:-1:1).^(0.2);
% ---------------------------------
% v_normalizer_ = (nv:-1:1).^(0.2);
% v_normalizer__ = (1:1:nv).^(0.2);
% v_normalizer = v_normalizer_.*v_normalizer__;
% ---------------------------------
% v_normalizer = ones(size(v));
% ---------------------------------
v_normalizer = v_normalizer/max(v_normalizer);
% ------------------------------------------------------------------------------
% reduce its size 
to_ = to_(1:fix(nt/10):end);
nto = numel(to_);
% box car filter
nh = fix(nt/15);
h = ones(nh,1)/nh;
% loop over velocities and times_o
for iv=1:nv
  for ito=1:nto
    % do hyperbolic moveout
    d_hmo = hmo(d,t,rx,dsr,v(iv),to_(ito));
    stack_ = (sum(d_hmo,2)/nr).^2; % (exp((linspace(0,3,nt)).'));
    stack_ = conv(stack_,h,'same');
    stack_ = v_normalizer(iv) * stack_;
    v_analy(:,iv) =  v_analy(:,iv) + stack_;
  end
  v_analy(:,iv) = v_analy(:,iv)/nto;
  % figure(100);
  % plot(t,v_analy(:,iv));
  % pause;
end
% % normalize somehow??
v_analy = v_analy/max(v_analy(:));
% v_analy = exp(v_analy);
% v_analy = v_analy/max(v_analy(:));
end