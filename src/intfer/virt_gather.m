function [v_g, c_g, t_corr] = virt_gather(d_windowed,virt,dt)

	[nt_,nr,ns] = size(d_windowed);
	
	% virtual shot gather
	%
	v_g = zeros(2*nt_-1,nr);
	
	% correlation gather
	%
	c_g = zeros(2*nt_-1,ns);

	for i=1:ns
		[v_r, ~] = virt_shot(squeeze(d_windowed(:,:,i)),virt,dt);
		c_g(:,i) = v_r(:,virt);
		v_g = v_g + v_r;
	end

	t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];

end