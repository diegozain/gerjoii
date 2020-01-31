function d_windowed = window_d(d,ns)
% windows data d(t,r) for ns slices of time samples,
%
% ns is an integer -> # of sources.
[nt,nr] = size(d);
% T = nt_ * dt = dt*nt / ns
% 1/T = ns / dt*nt
% ns = dt*nt / T
%
nt_ = nt/ns;
d_windowed = zeros(nt_,nr,ns);
for i=0:ns-1
	d_windowed(:,:,i+1) = d(nt_*i+1:nt_*(i+1),:);
end
end
