function y = integrate_line(y,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% 
% given a time series 'y' sampled at dt, who is its antiderivative?
% 
% clearly, integral(y,dt) is unique up to a constant. 
% we assume the constant of integration is zero.
% ------------------------------------------------------------------------------
% this code does the idea of Idt.m but no matrix storage is needed.
% if you ** dont ** want to visualize the matrix Idt_, use this method.
% ------------------------------------------------------------------------------
a = 0.5*dt;
b = 2*dt;

nt= numel(y);

y_ =0;
y__=0;
% ------------------------------------------------------------------------------
y_ = y(3);
y(3) = b * y(2);
y(2) = a * (y(1) + y(2));
for it=4:nt
 y__  = y(it);
 y(it)= y(it-2) + b*y_;
 y_   = y__;
end
y(1) = 0;
end

% % test:
% t=linspace(0,2*pi,1000).';dt=t(2)-t(1);nt=numel(t);y_sin=sin(t);y_cos=cos(t);
% y_sin_=integrate_line(y_sin,dt);y_cos_=integrate_line(y_cos,dt);
% figure;hold on;plot(t,y_cos);plot(t,-y_sin_+1,'--')
% figure;hold on;plot(t,y_sin);plot(t,y_cos_,'--')
