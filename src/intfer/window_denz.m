function d_windowed = window_denz(d,T_,dt)
% window 3 component data d of size (time x components x receivers)
% output is of size (time x components x receivers x windows)
% NOTE: # of components can be 3, (E,N,Z), or 2, (E,N), (E,Z), (N,Z).
% ---
[nt,ncomp,nr] = size(d);
if nargin>2
	% T_ = nt_ * dt = dt*nt / ns
	% 1/T_ = ns / dt*nt
	% ns = dt*nt / T_
	%
	ns = fix(dt*nt / T_);
	nt_ = fix(nt/ns);
	d_windowed = zeros(nt_,ncomp,nr,ns);
	for i_=0:ns-1
		d_windowed(:,:,:,i_+1) = d(nt_*i_+1:nt_*(i_+1),:,:);
	end
else
	ns = T_;
	% T = nt_ * dt = dt*nt / ns
	% 1/T = ns / dt*nt
	% ns = dt*nt / T
	%
	nt_ = nt/ns;
	d_windowed = zeros(nt_,nr,ns);
	for i_=0:ns-1
		d_windowed(:,:,i_+1) = d(nt_*i_+1:nt_*(i_+1),:);
	end
end
end