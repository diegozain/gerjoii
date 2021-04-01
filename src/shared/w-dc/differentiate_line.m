function y = differentiate_line(y,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% 
% given a time series 'y' sampled at dt, who is its derivative?
% 
% second order accurate.
% 
% ------------------------------------------------------------------------------
% this code does finds the derivative with minimal storage,
% it is a void method.
% ------------------------------------------------------------------------------
% for a time series of size 5, the diff operator is:
% a b  c
% c 0 -c
% 0 c  0 -c
% 0 0  c  0 -c
% 0 0 -c  d -a
% ------------------------------------------------------------------------------
a = -1.5/dt;
b = 2/dt;
c = -0.5/dt;
d = 2/dt;

nt= numel(y);

y_ =0;
y__=0;
% ------------------------------------------------------------------------------
y_ = y(1);
y(1) = a*y(1) + b*y(2) + c*y(3);

for it=2:2:(nt-2)
 y__    = y(it);
 y(it)  = c*y_ - c*y(it+1);
 y_     = y(it+1);
 y(it+1)= c*y__- c*y(it+2);
end

% NOTE: this part with ifs is ugly. 
% I should fix it one day.
if mod(nt,2)==1
 y__ = y(nt-1);
 y(nt-1) = c*y_ - c*y(nt);
 y(nt) = -c*y_ - d*y__ - a*y(nt);
else
 y(nt) = -c*y__ - d*y_ - a*y(nt);
end
end

% % test:
% t=linspace(0,2*pi,1001).';dt=t(2)-t(1);nt=numel(t);y_sin=sin(t);y_cos=cos(t);
% y_sin_=differentiate_line(y_sin,dt);y_cos_=differentiate_line(y_cos,dt);
% figure;hold on;plot(t,y_cos);plot(t,y_sin_,'--')
% figure;hold on;plot(t,-y_sin);plot(t,y_cos_,'--')

