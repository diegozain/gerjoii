function [dp,y,s,r] = broflegos_l(y,s,r,g_,g,p_,p)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% s(k-1) = p(k)-p(k-1)
% y(k-1) = g(k)-g(k-1)
% r(k-1) = 1/( (y(k-1).')*s(k-1) )
s_ = p_-p;
y_ = g_-g;
r_ = 1/( (y_.')*s_ );
s = [s , s_];
y = [y , y_];
r = [r , r_];
% optional: release previous info
m=size(y,2);
if m>20
s(:,1)=[];
y(:,1)=[];
r(1)=[];
end
m=size(y,2);
a=zeros(m,1);
q=g_;
% reverse sweep (gets q as a recurseve fnc of g & p)
for i_=0:(m-1)
  s_ = s(:,m-i_);
  y_ = y(:,m-i_);
  r_ = r(m-i_);
  a_ = r_*(s_.')*q;
  q = q-a_*y_;
  a(m-i_) = a_;
end
dp = - ( ((s(:,m).')*y(:,m))/((y(:,m).')*y(:,m)) ) * q;
% forward sweep
for i_=1:m
  b=r(i_)*(y(:,i_).')*dp;
  dp = dp + (a(i_)-b)*s(:,i_);
end
dp=-dp;
end