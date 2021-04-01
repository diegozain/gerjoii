function v = integrate_cube(v,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% 
% given a time cube 'v' sampled at dt, who is its antiderivative?
% 
% clearly, integral(v,dt) is unique up to a constant. 
% here we assume the constant of integration is zero.
% 
% tight memory requirements: no extra copy of 'v' is stored.
% ------------------------------------------------------------------------------
% this method follows the integration scheme in integrate_line.m,
% and does so as a void method. 
% 
% the idea of this method is explained in detail in Idt.m
% ------------------------------------------------------------------------------
a = 0.5*dt;
b = 2*dt;

[nz,nx,nt] = size(v);

v_ = zeros(nz,nx);
v__= zeros(nz,nx);
% ------------------------------------------------------------------------------
v_= v(:,:,3);
v(:,:,3) = b * v(:,:,2);
v(:,:,2) = a * (v(:,:,1) + v(:,:,2));
for it=4:nt
 v__  = v(:,:,it);
 v(:,:,it)= v(:,:,it-2) + b*v_;
 v_   = v__;
end
v(:,:,1) = zeros(nz,nx);
end