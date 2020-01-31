function [xy_image, image_kk, kk_filter] = filter_cog(image_xy,a,b)

% filter an (x,y) image in the (kx,ky) domain
%
% return (x,y) filtered image.
%
% for gaussian type filters (pastel_2d.m), use
%
% filt_TYPE = pastel_TYPE, which can can be
%
% 'HI_PASS'
% upside down cake
%
% 'LOW_PASS'
% upright cake
%
% kx,ky variables give center for gaussian.

% fft can't do this by itself so we help it,
[m,n] = size(image_xy);
m_=2^nextpow2(m); n_=2^nextpow2(n); 
m_extra = m_-m; n_extra = n_-n;
image_xy = [image_xy; zeros(m_extra,n)];
image_xy = [image_xy, zeros(m+m_extra,n_extra)];
% (x,y) image to (kx,ky) domain
k_image_k = fft2(image_xy);

% build filter in (kx,ky) domain

% dkx = 1/geome_.dx/n_; 
% dky = 1/geome_.dy/m_;
% kx = (-n_/2:n_/2-1)*dkx;
% ky = (-m_/2:m_/2-1)*dky;

a = m_*a; 
b = m_*b*2; % (b/2)*sqrt(2);
kx = 0:n_-1;
ky = 0:m_-1;

% first band
gaussian_1 = exp(- ((ky-((m_/2)-a)).^2 / b ) );
% second band
gaussian_2 = exp(- ((ky+((m_/2)+a)).^2 / b ) );
% both together <3
gaussian_ = (1-(gaussian_1 .* gaussian_2)) .* (gaussian_1 + gaussian_2);
gaussian_ = (1-(gaussian_ .* flip(gaussian_))) .* (gaussian_ + flip(gaussian_));
gaussian_ = gaussian_/max(abs(gaussian_(:)));
% repeat
kk_filter = repmat(gaussian_.',[1,n_]);

% fftshift filter to corners
k_filter_k = fftshift(kk_filter);

% filter
xy_image = k_filter_k .* k_image_k;
% fourier again
xy_image = ifft2(xy_image);
xy_image = real(xy_image);

% trim padded zeros because fft can't do this by itself
xy_image = xy_image(1:end-m_extra,1:end-n_extra);
% record filter
image_kk=fftshift(k_image_k);
end
