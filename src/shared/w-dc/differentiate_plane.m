function v = differentiate_plane(v,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% 
% given a time plane 'v' sampled at dt, who is its derivative?
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

[nt,nr]= size(v);

v_ =zeros(1,nr);
v__=zeros(1,nr);
% ------------------------------------------------------------------------------
v_ = v(1,:);
v(1,:) = a*v(1,:) + b*v(2,:) + c*v(3,:);

for it=2:2:(nt-2)
 v__    = v(it,:);
 v(it,:)= c*v_ - c*v(it+1,:);
 v_     = v(it+1,:);
 v(it+1,:)= c*v__- c*v(it+2,:);
end

% NOTE: this part with ifs is ugly. 
% I should fix it one day.
if mod(nt,2)==1
 v__ = v(nt-1,:);
 v(nt-1,:) = c*v_ - c*v(nt,:);
 v(nt,:) = -c*v_ - d*v__ - a*v(nt,:);
else
 v(nt,:) = -c*v__ - d*v_ - a*v(nt,:);
end
end

