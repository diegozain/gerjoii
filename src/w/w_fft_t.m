function [u_,f] = w_fft_t(u,dt)

% -------------
% fft wavefield
% -------------
[nz,nx,nt] = size(u);
% fft can't do this by itself so we help it,
nt_=2^nextpow2(nt);
nt_extra = nt_-nt;
u_extra = cat( 3,u,zeros(nz,nx,nt_extra) );
% t data to f domain
f_u_f = fft(u_extra,[],3);
df = 1/dt/nt_;
f = (-nt_/2:nt_/2-1)*df;

% % NOTE:
% % ---------------
% % ifft wavefield
% % ---------------
% u = ifft(f_u_f,[],3);
% % trim padded zeros because fft can't do this by itself
% u = u(:,:,1:end-nt_extra);

% make it look like something we can actually read from
u_ = fftshift(f_u_f,3);
% get rid of negative part
u_ = u_( :,:,ceil(nt_/2)+1:nt_-1 );
f = f( ceil(nt_/2)+1:nt_-1 );

% u is of size ( nz,nx,(nt_/2)-1 )

end