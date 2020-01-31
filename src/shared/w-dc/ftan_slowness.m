function [disper_g_sf,dro_snr] = ftan_slowness(dro,dt,f,v,alph,dsr)
	
% Apply frequency-time analysis (FTAN) to a seismic dro. All
% preprocessing (e.g., windowing) should be done prior to calling this
% function.
%
% INPUT:
%   dro = data time series at receiver ro size( 1, nt )
%   dt    = time sample interval in dro [s]
%	f = frequency
%	v = velocity
%   alph = a dimensionless parameter determining the narrowness of the filtering
%   dsr  = source-receiver dsrance [m]
%
% OUTPUT:
%   disper_g = frequency vs. slowness matrix; size( nv, nf )
%   f   = frequency vector for fvMatrix; size( nf, 1 )
%   v   = velocity vector for fvMatrix; size( 1, nv )
%   dro_snr = frequency dependent signal to noise ratio ( nf, 1 )

% check the shape of dro input
%
if size(dro,1) ~= 1
  dro = transpose( dro );
end

nt   = numel( dro ); 
nfft  = nt; % number of points in FFT: must be the same as nt
w  = 2 * pi * makeFFTvector( dt, nfft); 
t = ( 0 : nt-1 ) .* dt; 

nf = numel(f); 
nv = numel(v); 

% ----------------------------------------------------
% FTAN - it is just appling a frequency filter (gaussian)
% ----------------------------------------------------

% dispersion on (freq x time)
%
disper_g_ft = zeros( nf , nt );

% dispersion on (group vel x freq)
%
disper_g_sf = zeros( nv, nf);

% make sure to taper the edges to zero before fft
%
taper = tukeywin(nt,0.1);
dro = dro .* taper';

for ii = 1 : nf 
	% [rad] central frequency of Guassian
	%
  wo =  2 * pi * f(ii); 
  % make the narrowband filter (Gaussian as in Levshin's work)
	% equation 6 in Bensen et al. (2007)
	%
  gfl = exp( -alph * ( ( ( w - wo ) ./ wo ).^2 ) );
	% fft of analytic signal
	%
  dro_ = fft( hilbert(dro), nfft ) ./ nfft;
	% multiply by narrowband filter and inverse FFT
	% Equation 5 in Bensen et al. (2007)
	%
	dro_ = ifft( dro_ .* gfl, nfft);
  disper_g_ft( ii, : ) = dro_;
	% interpolate from time to slowness using a spline
	% spline( x, y(x), new x ) = new y( new x )
	%
	disper_g_sf( :, ii ) = spline( t, abs(dro_) , v ./ dsr );
end

% Compute the SNR of the bandpassed dros
%
tmin = dsr/v(nv);
tmax = dsr/v(1);
nmin = round(tmin/dt);
nmax = min([round(tmax/dt) nt]); % make sure nmax is not larger than nt
sigIdx = nmin : nmax;
noiIdx = nmax : nt;

dro_snr = zeros( nf, 1 );
% for ii = 1 : nf
%   dro_snr( ii ) = max( abs( disper_g_ft( ii, sigIdx ) ) ) /...
% 	rms( disper_g_ft( ii, noiIdx ) );
% end

end