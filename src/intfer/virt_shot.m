function [v_r, t_corr] = virt_shot(d,virt,dt)

	[nt,nr] = size(d);
	v_r = zeros(2*nt-1,nr);

	for i=1:nr
		v_r(:,i) = xcorr(d(:,i),d(:,virt)); 
	end

	t_corr = dt*[(-nt+1:-1) (0:nt-1)];

end