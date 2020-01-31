function [d_windowed,ns] = window_dT(d,T_,dt)
% windows data d(t,r) for equal slices of time T_,
%
% T_ is a real number.
[nt,nr] = size(d);
% T_ = nt_ * dt = dt*nt / ns
% 1/T_ = ns / dt*nt
% ns = dt*nt / T_
%
ns = fix(dt*nt / T_);
nt_ = fix(nt/ns);
d_windowed = zeros(nt_,nr,ns);
for i=0:ns-1
	d_windowed(:,:,i+1) = d(nt_*i+1:nt_*(i+1),:);
end
end