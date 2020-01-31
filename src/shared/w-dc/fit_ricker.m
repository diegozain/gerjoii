function [wo,to] = fit_ricker(s_o,t,p,to_yn)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% fits observed amplitudes 's_o' to a ricker wavelet 'ricker':
%
% s_o(t) = ( 1-0.5*(wo^2)*(t-to).^2 ) .* exp( -0.25*(wo^2)*(t-to).^2 )
%
% ds(wo) = 1/4 wo (to - t)^2 e^(-0.25 wo^2 (to - t)^2) (wo^2 (to - t)^2 - 6)
% ds(to) = 0.25 wo^2 e^(-0.25 wo^2 (to - t)^2) ...
%  (wo^2 to^3 - 3 wo^2 to^2 t + 3 wo^2 to t^2 - wo^2 t^3 - 6 to + 6 t)
%
% and it does so in a least square sense.
%
% NOTE:
% s_o and t have to be column vectors.
% ------------------------------------------------------------------------------
step_ = 1e-4;
k=linspace(-1e-2,5e-2,2).';
nd = numel(s_o);
np = 2;
% first guess for wo,to (p=[wo;to])
if nargin < 3
  p = ones(np,1);
end
to=p(2);
% optimization
iter = 0;
E = Inf;
while ( E > 1e-20 & iter < 3000)
  % save p in case of NaN
  p_buffer = p;
  % fwd 
  s = ricker(t,p);
  % errors
  e_ = s-s_o;
  E = norm(e_)/nd;
  % jacobian
  J = ricker_J(t,p);
  % gradient
  g = ( (J.')*e_);
  g = normali(g);
  % hessian 
  % g = (J.'*J + step_*speye(np) )\g;
  % find stepsize
  step_ = step_p(t,p,g,E,k)*0.1;
  dp = -step_*g;
  % update
  % p = real(p + dp);
  p = p.*exp(p.*dp);
  if strcmp(to_yn,'n')
    p(2)=to;
  end
  % counter
  iter=iter+1;
  if sum(isnan(p)) > 0
    p=p_buffer;
    break;
  end
end
wo=p(1);to=p(2);
end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
function s = ricker(t,p)
wo=p(1);to=p(2);
s = ( 1-0.5*(wo^2)*(t-to).^2 ) .* exp( -0.25*(wo^2)*(t-to).^2 );
end
function J = ricker_J(t,p)
wo=p(1);to=p(2);
J=zeros(numel(t),2);
J(:,1) = (0.25*wo*(to - t).^2) .* ...
exp(-0.25*(wo^2)*(to - t).^2) .* ((wo^2)*(to - t).^2 - 6);
J(:,2) = 0.25*(wo^2)*exp(-0.25*(wo^2)*(to - t).^2) .* ...
((wo^2)*(to^3)-3*(wo^2)*(to^2)*t + (3*wo^2)*to*(t.^2)-(wo^2)*(t.^3)-(6*to)+6*t);
end
% -----------------------------------------------------------------------------
function step_ = step_p(t,p,g,E,k)
% 
% E is with k=0.
E_=zeros(numel(k),1);
% ------------------------------------------------------------------------------
for i_=1:numel(k)
  % fwd & obj fnc (sum of squares)
  % p_ = p - k(i_)*g;
  p_ = p.*exp(-k(i_)*p.*g);
  E__ = ricker(t,p_);
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