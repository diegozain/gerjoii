function v = integrate_plane(v,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% 
% given a time plane 'v' sampled at dt, who is its antiderivative?
% 
% clearly, integral(v,dt) is unique up to a constant. 
% here we assume the constant of integration is zero.
% 
% it is a void method, so no significant extra memory is required.
% ------------------------------------------------------------------------------
% this method follows the integration scheme in integrate_.m,
% but does so as a void method.
% 
% this method is explained in detail in Idt.m
% ------------------------------------------------------------------------------
a = 0.5*dt;
b = 2*dt;

[nt,nr] = size(v);

v_ = zeros(1,nr);
v__= zeros(1,nr);
% ------------------------------------------------------------------------------
v_= v(3,:);
v(3,:) = b * v(2,:);
v(2,:) = a * (v(1,:) + v(2,:));
for it=4:nt
 v__  = v(it,:);
 v(it,:)= v(it-2,:) + b*v_;
 v_   = v__;
end
v(1,:) = 0;
end