function [disper_vxf,disper_sxf] = masw(d_,x,sx,f,f_disp)
% ..............................................................................
% dylan mikesell told me how to do this circa 2018
% ..............................................................................
% d_ fourier transform of the data
% x  receiver coordinates
% sx slowness vector
% f  frequencies of the data
% f_disp frequencies to scan over
% ..............................................................................
vx = 1./sx;
[nt,~] = size(d_);
nsx = length(sx);
nvx = length(vx);
nf_disp = length(f_disp);
nf = numel(f);
% ..............................................................................
% dispersion on (vel x freq)
%
disper_vxf = zeros(nvx,nf_disp);
% ..............................................................................
% dispersion on (slow x freq)
%
disper_sxf = zeros(nsx,nf_disp);
% ..............................................................................
for i_=1:nf_disp
	% choose frequency
	%
	fo = f_disp(i_);
	ifo = binning(f,fo);
	% reduce data to just that frequency
	%
	d_fo = d_(ifo,:)';
	d_fo = d_fo ./ abs( d_fo );
	% build Lfo matrix
	%
	Lfo = Lfo_radon(x,sx,fo);
	% radon domain data
	%
	% [p,~] = irls(Lfo,d_fo,1,1e-10,1e+3);
	% p = pcg(Lfo'*Lfo , Lfo'*d_fo);
	p = Lfo' * d_fo;
	% take power
	%
	p = abs( p ) ./ max( abs(p) );
	% put together
	%
	disper_sxf(:,i_) = p;
  % interpolate from slowness to velocity
	% interp1( x, y(x), new x ) = new y( new x )
  %
	p = interp1( 1./sx, abs(p), vx, 'pchip' );
	disper_vxf(:,i_) = p ./ max(p);
end
end