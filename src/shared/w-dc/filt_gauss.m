function [d_filt,gaussian_] = filt_gauss(d,dt,f_low,f_high,steep)
% diego domenzain 2018.
%
% performs gaussian filter between f_low and f_high of data d:
% 
% 1. fft data (with padded zeros)
% 2. build f
% 3. build filter in f
% 4. fftshift filter 
% 5. filter by multiplication in f-domain
% 6. fft data back to time
% 7. trim padded zeros
% -------------------------------------------------------
% fourier: d(r,t), df -> d(r,f), f
% -------------------------------------------------------
[nt,nr] = size(d);

% tukey before fourier
d = d .* repmat(tukeywin(nt,0.1),[1,nr]);
% fft can't do this by itself so we help it,
nt_=2^nextpow2(nt);
nt_extra = nt_-nt;
d_extra = [d; zeros(nt_extra,nr)];

% t data to f domain
f_d_f = fft(d_extra,[],1);
df = 1/dt/nt_;
f = ((-nt_/2:nt_/2-1)*df).';

% build filter in f domain
width = f_high - f_low;
middle = f_low + (width*0.5);
gaussian_ = exp( -((f-middle).^steep) / ((df*0.5)*width^(steep-1)) );
% figure; plot(f,gaussian_,'.-','Markersize',8); pause
gaussian_ = fftshift(gaussian_);
gaussian_ = repmat(gaussian_,[1,nr]);

% filter
d_filt = f_d_f .* gaussian_;
d_filt = ifft(d_filt);
d_filt = real(d_filt);

% trim padded zeros because fft can't do this by itself
d_filt = d_filt(1:end-nt_extra,:);

% remember filter
gaussian_ = fftshift(gaussian_,1);
end