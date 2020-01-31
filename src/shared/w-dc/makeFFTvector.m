function f = makeFFTvector(dt,nfft)
%
% Make the frequency vector that corresponds to MATLAB's FFT() function.
% The vector start at DC (i.e., f = 0) and ends at f = -df. This frequency
% vector computation was taken from
% http://blogs.uoregon.edu/seis/wiki/unpacking-the-matlab-fft/
%
% USAGE: f = makeFFTvector(dt,nfft)
%
% INPUT:
%   dt = time sample interval
%   nfft = number of samples in the FFT(data,nfft) function.
% OUTPUT:
%   f = vector of frequencies%
%
% Writen by Dylan Mikesell (mikesell@mit.edu)
%
% Version 0.1 (12 September 2014)

df     = 1  / dt / nfft;            % sample interval in fourier domain
fny   = 1 / dt  / 2;                % Nyquist sampling frequency
f = ( 0 : ( nfft - 1 ) ) .* df;

% set the correct negative part of frequency array
%
f( f >= fny ) = f( f >= fny ) - ( fny * 2 );

return