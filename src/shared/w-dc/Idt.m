function Idt_ = Idt(nt,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% for a memory light version of this idea, please see integrate_.m
% ------------------------------------------------------------------------------
% 
% given a time series 'y' sampled at dt, who is its antiderivative?
% 
% clearly, integral(y) is unique up to a constant. 
% here we assume the constant of integration is zero.
% 
% the idea is that if the antiderivative is y_, then
% 
% y_ = Idt_ * y;
% 
% where Idt_ is an (nt x nt) matrix
% 
% ------------------------------------------------------------------------------
% Why this particular Idt_ works:
% 
% although here Idt_ is constructed explicitly, 
% the idea was born by building a 2nd order derivative matrix Dt,
% and then looking at its inverse, i.e. inv(Dt).
% 
% obviously, some technical details on the constant of integration ambiguity
% had to be taken into account in building Dt.
% See integrate.m for more details on Dt.
% 
% turned out that inv(Dt) (=Idt_) is quite nice and can be built explicitly.
% ------------------------------------------------------------------------------
% example of Idt_:
% 
% 0
% a a
% 0 b
% a a b
% 0 b 0 b
% a a b 0 b
% 
% where a=0.5*dt, b=2*dt
% ------------------------------------------------------------------------------
% this construction uses explicit indicies for values a and b:
% 
% Ia Ja
% 2  1 
% 2  2
% 4  1
% 4  2
% 6  1
% 6  2
% etc
% 
% Ib Jb
% 3  2
% 4  3
% 5  2
% 5  4
% 6  3
% 6  5
% 7  2
% 7  4
% 7  6
% etc
% ------------------------------------------------------------------------------

a = 0.5*dt;
b = 2*dt;

% -- a values
% this one goes every two rows
na = 2*floor(nt*0.5);
Ia = zeros(na,1);
Ja = zeros(na,1);
Va = a*ones(na,1);
it_=1;
for it=2:2:nt
 for jt=1:2
  % fprintf('%i %i\n',it,jt)
  Ia(it_) = it;
  Ja(it_) = jt;
  it_=it_+1;
 end
end

% -- b values
% this one is like a staggered triangular matrix on nt-1 points.
% ** nt odd **
% the number of entries is: (sum of first nt/2 odd numbers)
% ** nt even **
% the number of entries is: (sum of first nt/2 - 1 even numbers)
if mod(nt,2)==1
 nb = floor(nt*0.5)^2;
elseif mod(nt,2)==0
 nb = (nt*0.5-1)*(nt*0.5);
end
Ib = zeros(nb,1);
Jb = zeros(nb,1);
Vb = b*ones(nb,1);
it_=1;
for it=3:nt
 jt_ = 2 + mod(it+1,2);
 for jt=jt_:2:(it-1)
  % fprintf('%i %i\n',it,jt)
  Ib(it_) = it;
  Jb(it_) = jt;
  it_=it_+1;
 end
end

I = [Ia;Ib];
J = [Ja;Jb];
V = [Va;Vb];

Idt_ = sparse(I,J,V,nt,nt);
end

% % test
% t=linspace(0,2*pi,100).';dt=t(2)-t(1);nt=numel(t);y_sin=sin(t);y_cos=cos(t);
% Idt_ = Idt(nt,dt);
% y_sin_=Idt_*y_sin;y_cos_=Idt_*y_cos;
% figure;hold on;plot(t,y_cos);plot(t,-y_sin_)
% figure;hold on;plot(t,y_sin);plot(t,y_cos_) 
