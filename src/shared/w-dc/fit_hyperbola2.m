function [d,b,c] = fit_hyperbola2(a_o,x,p)
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
step_ = 1e-4;
k=linspace(-1e-2,5e-2,2).';
nd = numel(a_o);
np = 3;
% first guess for d,b,c (p=[d;b;c])
if nargin < 3
  p = ones(np,1);
end
% optimization
iter = 0;
E = Inf;
while ( E > 1e-20 & iter < 3000)
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
  % hessian 
  % g = (J.'*J + step_*speye(np) )\g;
  % find stepsize
  step_ = step_p(x,p,g,E,k);
  dp = -step_*g;
  % update
  % p = real(p + dp);
  p = p.*exp(p.*dp);
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
% -----------------------------------------------------------------------------
function step_ = step_p(x,p,g,E,k)
% 
% E is with k=0.
E_=zeros(numel(k),1);
% ------------------------------------------------------------------------------
for i_=1:numel(k)
  % fwd & obj fnc (sum of squares)
  % p_ = p - k(i_)*g;
  p_ = p.*exp(-k(i_)*p.*g);
  E__ = hyperbola(x,p_);
  E__ = sum(E__(:).^2) / numel(E__);
  E_(i_) = E__;
end
% ------------------------------------------------------------------------------
% bundle
E_ = [E;E_]; E = E_;
k = [0;k];
% ------------------------------------------------------------------------------
% parabola approx
p = polyfit(k,E,2);
% find zero of parabola (updbte = -step*gradient)
step_ = -p(2)/(2*p(1));
end