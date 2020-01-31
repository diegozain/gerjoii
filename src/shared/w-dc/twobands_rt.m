function [d,gaussian_,f] = twobands_rt(d,dt,f1,f2,f3,f4,n_order)

% -------------------------------------------------------
% fourier: d(r,t), df -> d(r,f), f
% -------------------------------------------------------

[nt,nr] = size(d);

% fft can't do this by itself so we help it,
nt_=2^nextpow2(nt);
nt_extra = nt_-nt;
d_extra = [d; zeros(nt_extra,nr)];

% t data to f domain
f_d_f = fft(d_extra,[],1);
df = 1/dt/nt_;
f = (-nt_/2:nt_/2-1)*df;
f = f.';

% ----------------------------------
% filter
% ----------------------------------
if mod(n_order,2)==1
  n_order = n_order+1;
  fprintf('\n the order has to be even... idiot.\n')
end

% first band
f1_ = f2-f1;
f1__ = f1 + f1_/2;
f1_ = f1_^(n_order-1);
gaussian_1 = exp(- ((f-f1__).^n_order / f1_ ) );
% figure; plot(t,gaussian_2); axis tight

% second band
f3_ = f4-f3;
f3__ = f3 + f3_/2;
f3_ = f3_^(n_order-1);
gaussian_2 = exp(- ((f-f3__).^n_order / f3_ ) );
% figure; plot(t,gaussian_2); axis tight

% both together <3
gaussian_ = (1-(gaussian_1 .* gaussian_2)) .* (gaussian_1 + gaussian_2);
gaussian_ = (1-(gaussian_ .* flip(gaussian_))) .* (gaussian_ + flip(gaussian_));
gaussian_ = gaussian_/max(abs(gaussian_(:)));

% fftshift and (nf,nr)-matrix
gaussian_ = fftshift(gaussian_);
gaussian__ = repmat(gaussian_,[1,nr]);

% grand climax (actually filtering)
f_d_f = gaussian__.*f_d_f;
% ----------------------------------
% ifft
% ----------------------------------
% NOTE:
% ifft 
d = ifft(f_d_f);
% trim padded zeros because fft can't do this by itself
d = d(1:end-nt_extra, : );
% d is now (up to machine precission),
% identical to original d (same size even).
d = real(d);
gaussian_=fftshift(gaussian_);

end

% f1=0.02;f2=0.1;f3=0.33;f4=0.53;n_order=10;
% d = twobands_rt(d,dt,f1,f2,f3,f4,n_order);
% figure; plot(f,gaussian_); axis tight



