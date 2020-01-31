function [image_,kx,kz] = fourier_2d(image_,dx,dz)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
[nz,nx] = size(image_);
nz_=2^nextpow2(nz); nx_=2^nextpow2(nx); 
nz_extra = nz_-nz; nx_extra = nx_-nx;
image_ = [image_; zeros(nz_extra,nx)];
image_ = [image_, zeros(nz+nz_extra,nx_extra)];
% (x,z) image to (kx,kz) domain
image_ = fft2(image_);
image_ = fftshift(image_);
% frequency intervals
[nz_,nx_] = size(image_);
dkx = 1/dx/nx_;
dkz = 1/dz/nz_;
kx=(-nx_/2:nx_/2-1)*dkx;
kz=(-nz_/2:nz_/2-1)*dkz;
end