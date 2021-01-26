function [wo,bo,to,E_] = fit_gabor(s_o,t,p,to_yn)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% fits observed amplitudes 's_o' to a gabor wavelet 'gabor':
%
% s_o(t) = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to))
%
% and it does so in a least square sense.
%
% NOTE:
% s_o and t have to be column vectors.
% ------------------------------------------------------------------------------
% p(1) = wo
% p(2) = bo
% p(3) = to
% ------------------------------------------------------------------------------
step_ = 1e-3;
k=linspace(-1e-1,1,4).';
nd = numel(s_o);
np = 3;
% first guess for wo,bo,to (p=[wo;bo;to])
if nargin < 3
  p = ones(np,1);
end
to=p(3);
% optimization
iter = 0;
E_=[];
E = Inf;
while ( E > 1e-20 & iter < 1500)
  % save p in case of NaN
  p_buffer = p;
  % fwd 
  s = gabor(t,p);
  % errors
  e_ = s-s_o;
  E = norm(e_)/nd;
  % jacobian
  J = gabor_J(t,p);
  % gradient
  g = ( (J.')*e_);
  if strcmp(to_yn,'n')
    g(3)=0;
  end
  g = normali(g);
  % % hessian 
  % g = (J.'*J + step_*speye(np) )\g;
  % find stepsize
  step_ = step_p(t,p,g,E,k)*1e-3;
  dp = -step_*g;
  % update
  p = p.*exp(p.*dp);
  p=real(p);
  % counter
  iter=iter+1;
  if sum(isnan(p)) > 0
    p=p_buffer;
    fprintf('\n oh no... I got a NaN @ iter %i so I give you last not-NaN\n\n',iter);
    % figure;plot(t,real(J));
    break;
  end
  E_=[E_ E];
  if iter>1 && E-E_(end-1)>0
    fprintf('your gabor inversion stopped at iteration %i\n',iter)
    p=p_buffer;
    break
  end
end
wo=p(1);
bo=p(2);
to=p(3);
end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
function s = gabor(t,p)
wo=p(1);
bo=p(2);
to=p(3);
s = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to));
end
function J = gabor_J(t,p)
a=p(1); % wo
b=p(2); % bo
c=p(3); % to
J=zeros(numel(t),3);
J(:,1) = (t-c) .* sin((t-c)*a) .* (-exp(-( (c-t).^2 )/(b^2) ));
J(:,2) = ((2*(t-c).^2) .* cos((t-c)*a) .* exp(-( ((t-c).^2) )/(b^2) )) / b^3;
J(:,3) = exp(-(((t-c).^2))/(b^2)).*(2*(t-c).*cos((t-c)*a)+(a*b^2).*sin((t-c)*a))/b^2;
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
  E__ = gabor(t,p_);
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
% ------------------------------------------------------------------------------
%                           test 
% ------------------------------------------------------------------------------
%{
close all
clear
clc
t=(0:0.01:100).';
wo=3;
bo=2;
to=20;
gabor = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to));
s_o = real(gabor);
figure;plot(t,s_o)
po=[wo;bo;to]
p=[wo*0.5;bo*2;to];
[wo,bo,to,E_] = fit_gabor(s_o,t,p,'n');
gabor = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to));
hold on;plot(t,gabor)
figure;plot(E_)

%}