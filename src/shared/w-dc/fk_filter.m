function [d, d_fk, fk_filt] = fk_filter(d,vel_,filt_TYPE)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% filter an (t,r) image in the (f,k) domain
%
% return (t,r) filtered image.
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
% k,f variables give center for gaussian.

% -----------------------------
% into fk-fourier
% -----------------------------

% fft can't do this by itself so we help it,
[nt,nr] = size(d);
nt_=2^nextpow2(nt); nr_=2^nextpow2(nr); 
nt_extra = nt_-nt; nr_extra = nr_-nr;
d = [d; zeros(nt_extra,nr)];
d = [d, zeros(nt+nt_extra,nr_extra)];
% (t,r) image to (f,k) domain
f_d_k = fft2(d);

% -----------------------------
% build filter in (f,k) domain
% -----------------------------

% dk = 1/dr/nr_; 
% df = 1/dt/nt_;
% k = (-nr_/2:nr_/2-1)*dk;
% f = (-nt_/2:nt_/2-1)*df;

if strcmp(filt_TYPE,'VEL_CONE')
% vel cone filter
vel_ = (nt_/nr_)*vel_;
fk_filt = vel_cone(vel_,nr_,nt_);
end

% ar = nr_*(ar/2)*sqrt(2); at = nt_*(at/2)*sqrt(2);
% R = 0:nr_-1; ro = nr_/2;
% T = 0:nt_-1; to = nt_/2;
% [RT,TR] = meshgrid(R,T);
% fk_filt = ((RT-ro)/ar).^2 + ((TR-to)/at).^2;
% fk_filt = - fk_filt;
% if strcmp(filt_TYPE,'LOW_PASS')
%   fk_filt = exp(fk_filt);
% elseif strcmp(filt_TYPE,'HI_PASS')
%   fk_filt = 1 - exp(fk_filt);
% end

fk_filt = fk_filt / max(abs(fk_filt(:)));
% fftshift filter to corners
f_filter_k = fftshift(fk_filt);

% -------
% filter
% -------

d = f_filter_k .* f_d_k;
% figure; imagesc(abs(fftshift(d)));axis normal;

% -----------
% bring back
% -----------

% fourier again
d = ifft2(d);
d = real(d);

% trim padded zeros because fft can't do this by itself
d = d(1:end-nt_extra,1:end-nr_extra);
% record filter
d_fk=fftshift(f_d_k);
end

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% -------------------------- private. keep out. --------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

function fk_filt = vel_cone(vel_,nr_,nt_)

k = (-nr_/2:nr_/2-1);
f = (-nt_/2:nt_/2-1);

fk_filt = zeros(nt_,nr_);
% vel_ = 6;
for it_=1:nt_/2
  % k = f/vel
  r_ = f(it_) / vel_;
  % % velocity cone is of width twice wavenumber (neg k, pos k)
  % width = 2*r_;
  % fk_filt(it_,:) = 1-(exp(- (k.^4 / width^3 ) ));
  fk_filt(it_,:) = 1 ./ ( 1+exp(-5*( k+r_ )) );
end
for it_=nt_/2:nt_
  % k = f/vel
  r_ = f(it_) / vel_;
  % % velocity cone is of width twice wavenumber (neg k, pos k)
  % width = 2*r_;
  % fk_filt(it_,:) = 1-(exp(- (k.^4 / width^3 ) ));
  fk_filt(it_,:) = 1-(1 ./ ( 1+exp(-5*( k+r_ )) ));
end
end
