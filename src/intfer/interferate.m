function [v_g, c_g, t_corr] = interferate(d_windowed,virt,dt)

	[nt_,nr,ns] = size(d_windowed);
	
	% virtual shot gather
	%
	v_g = zeros(2*nt_-1,nr);
	
	% correlation gather
	%
	c_g = zeros(2*nt_-1,ns);

	for i=1:ns
		d_is = squeeze(d_windowed(:,:,i));
		v_r = xcorr2( d_is , d_is(:,virt) );
		c_g(:,i) = v_r(:,virt);
		v_g = v_g + v_r;
	end

	t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];

end