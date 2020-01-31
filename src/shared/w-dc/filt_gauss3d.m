function u = filt_gauss3d(u,dt,f_low,f_high,steep)
% diego domenzain 2018.
%
% performs gaussian filter between f_low and f_high of wavefield u:
% 
% 1. fft data (with padded zeros)
% 2. build f
% 3. build filter in f
% 4. fftshift filter 
% 5. filter by multiplication in f-domain
% 6. fft data back to time
% 7. trim padded zeros

% -------------------------------------------------------
% fourier: d(x,z,t), df -> d(x,z,f), f
% -------------------------------------------------------
[nz,nx,nt] = size(u);
% tukey before fourier
tkw = zeros(1,1,nt);
tkw(1,1,:) = tukeywin(nt,0.1);
tkw = repmat(tkw,[nz,nx,1]);
u = u.*tkw; 
clear tkw;
% fft can't do this by itself so we help it,
nt_=2^nextpow2(nt);
nt_extra = nt_-nt;
u = cat(3,u,zeros(nz,nx,nt_extra));
% t data to f domain
u = fft(u,[],3);
df = 1/dt/nt_;
f = ((-nt_/2:nt_/2-1)*df).';
% build filter in f domain
width = f_high - f_low;
middle = f_low + (width*0.5);
gaussian__ = exp( -((f-middle).^steep) / ((df*0.5)*width^(steep-1)) );
gaussian__ = fftshift(gaussian__);
gaussian_ = zeros(1,1,numel(f));
gaussian_(1,1,:) = gaussian__;
gaussian_ = repmat(gaussian_,[nz,nx,1]);
% filter
u = u .* gaussian_;
u = ifft(u,[],3);
u = real(u);
% trim padded zeros because fft can't do this by itself
u = squeeze(u(:,:,1:end-nt_extra));
% % remember filter
% gaussian_ = fftshift(gaussian_,3);
end