function [d,b,c] = fit_hyperbola(a_o,x,p)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% fits observed amplitudes 'a_o' to a hyperbola 'a':
%
% a(x) = d/(x+b)^c = a_o
%
% dd(a) = 1/(b+x)
% db(a) = -cd / ((b+x)^(c+1))
% dc(a) = (-d*log(b + x)) / ((b + x)^c)
%
% and it does so in a least square sense.
%
% NOTE:
% a_o and x have to be column vectors.
% ------------------------------------------------------------------------------
pica_ = 1e-1;
nd = numel(a_o);
% first guess for d,b,c (p=[d;b;c])
if nargin < 3
  p = ones(3,1);
end
% optimization
iter = 0;
E = Inf;
while ( E > 1e-15 & iter < 1005)
  % save p in case of NaN
  p_buffer = p;
  % fwd 
  a = hyperbola(x,p);
  % errors
  e_ = a-a_o;
  E = norm(e_)/nd;
  % jacobian
  J = hyperbola_J(x,p);
  % gradient
  g = ( (J.')*e_);
  g = normali(g);
  % find stepsize
  step_ = pica(x,a,p,pica_,-g,e_)
  dp = step_*g;
  % update
  p = real(p + dp);
  % counter
  iter=iter+1;
  if sum(isnan(p)) > 0
    p=p_buffer;
    break;
  end
end
d=p(1);b=p(2);c=p(3);
end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
function a = hyperbola(x,p)
d=p(1);b=p(2);c=p(3);
a = d ./ ((x+b).^c);
end
function J = hyperbola_J(x,p)
d=p(1);b=p(2);c=p(3);
J=zeros(numel(x),3);
J(:,1) = 1 ./ (b+x).^c;
J(:,2) = -c*d ./ ((b+x).^(c+1));
J(:,3) = (-d*log(abs(b + x))) ./ ((b + x).^c);
end
function step_ = pica(x,a,p,pica_,dp,e_)  
% fwd 
a_ = hyperbola(x,p+pica_*dp)-a;
step_ = pica_* ( ( (a_.')*e_ ) / ((a_.')*a_) );
end