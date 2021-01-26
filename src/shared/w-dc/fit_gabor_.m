function [wo,bo,to,co,E_] = fit_gabor_(s_o,t,p,to_yn)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% fits observed amplitudes 's_o' to a gabor wavelet with a kink 'gabor_':
%
% s_o(t) = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to) + co)  <-- kink is co
%
% and it does so in a least square sense.
%
% NOTE:
% s_o and t have to be column vectors.
% ------------------------------------------------------------------------------
% p(1) = wo
% p(2) = bo
% p(3) = to
% p(4) = co
% ------------------------------------------------------------------------------
step_ = 1e-3;
k=linspace(-1e-3,1,6).';
nd = numel(s_o);
np = 4;
% first guess for wo,bo,to,co (p=[wo;bo;to;co])
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
  s = gabor_(t,p);
  % errors
  e_ = s-s_o;
  E = norm(e_)/nd;
  % jacobian
  J = gabor_J_(t,p);
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
    figure;plot(t,real(J))
    break;
  end
  E_=[E_ E];
  if iter>1 && E-E_(end-1)>0
    fprintf('your gabor kink inversion stopped at iteration %i\n',iter)
    p=p_buffer;
    break
  end
end
wo=p(1);
bo=p(2);
to=p(3);
co=p(4);
end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
function s = gabor_(t,p)
wo=p(1);
bo=p(2);
to=p(3);
co=p(4);
s = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to)+co);
end
function J = gabor_J_(t,p)
  % exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to)+co)
  % Exp[-((t-c)^2)/(b^2)] * Cos[a*(t-c)+d]
  % 
  % Diff[Exp[-((t-c)^2)/(b^2)] * Cos[a*(t-c)+d] , a]
  % (t - c) .* (-exp(-((t - c).^2)/(b^2))) .* sin(a*(t - c) + d)
  % 
  % Diff[Exp[-((t-c)^2)/(b^2)] * Cos[a*(t-c)+d] , b]
  % ((2*(t - c).^2).*exp(-((t - c).^2)/(b^2)).*cos(a*(t - c) + d))/(b^3)
  % 
  % Diff[Exp[-((t-c)^2)/(b^2)] * Cos[a*(t-c)+d] , c]
  % a*exp(-(t - c).^2/b^2) .* sin(a*(t - c) + d) + (2*(t - c) .* exp(-(t - c).^2/b^2) .* cos(a*(t - c) + d))/b^2
  % 
  % Diff[Exp[-((t-c)^2)/(b^2)] * Cos[a*(t-c)+d] , d]
  % -exp(-(t - c).^2/b^2) .* sin(a*(t - c) + d)
  
a=p(1); % wo
b=p(2); % bo
c=p(3); % to
d=p(4); % co
J=zeros(numel(t),3);
J(:,1) = (t - c) .* (-exp(-((t - c).^2)/(b^2))) .* sin(a*(t - c) + d);
J(:,2) = ((2*(t - c).^2).*exp(-((t - c).^2)/(b^2)).*cos(a*(t - c) + d))/(b^3);
J(:,3) = a*exp(-(t - c).^2/b^2) .* sin(a*(t - c) + d) + (2*(t - c) .* exp(-(t - c).^2/b^2) .* cos(a*(t - c) + d))/b^2;
J(:,4) = -exp(-(t - c).^2/b^2) .* sin(a*(t - c) + d);
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
  E__ = gabor_(t,p_);
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
wo=2;
bo=2;
to=20;
co=0.5;
po=[wo;bo;to;co]
s_o_ = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to)+co);
figure;plot(t,s_o_,'k');hold on;

p=[wo*0.1;to]
[wo,to]=fit_ricker(s_o_,t,p,'n');
s_o = ( 1-0.5*(wo^2)*(t-to).^2 ) .* exp( -0.25*(wo^2)*(t-to).^2 );
plot(t,s_o,'g');

p=[wo;bo*4;to]
[wo,bo,to,E_] = fit_gabor(s_o_,t,p,'n');
s_o = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to));
plot(t,s_o,'b');

p=[wo;bo;to;co*2]
[wo,bo,to,co,E_] = fit_gabor_(s_o_,t,p,'n');
s_o = exp(-((t-to).^2)./(bo^2)) .* cos(wo*(t-to)+co);
plot(t,s_o,'r');

p=[wo;bo;to;co]

figure;
plot(E_,'.-','markersize',15)

%}