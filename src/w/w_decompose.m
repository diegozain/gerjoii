function [u_wu,u_wd] = w_decompose(u_w)
% diego domenzain.
% boise state university, 2018. while at TUDelft.
% ------------------------------------------------------------------------------
% decompose wavefield u_w into up and down components 
% using fourier fk filters.
% ------------------------------------------------------------------------------
% u_w is a (nz,nx,nt) cube
% record original size
[nz,nx,nt] = size(u_w);
% put in fourier space
u_w = fft_zt(u_w);
[nkz,~,nft] = size(u_w);
% down filter first
f = f_down(nkz,nx,nft);
u_wd = f .* u_w;
% up filter
f = ~f;
u_wu = f .* u_w;
% bring back
u_wd = ifft_kzft(u_wd,nz,nt);
u_wu = ifft_kzft(u_wu,nz,nt);
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% -----------------------------  private  --------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function u_w_ = fft_zt(u_w)
  % ---------------------------------
  % fourier on plane (z,t) -> (k,x,f)
  % ---------------------------------
  % expand
  [nz,nx,nt] = size(u_w);
  nz_=2^nextpow2(nz); nt_=2^nextpow2(nt); 
  nz_extra = nz_-nz; nt_extra = nt_-nt;
  u_w = cat(1,u_w,zeros(nz_extra,nx,nt)) ; % [u_w; zeros(nz_extra,nx,nt)];
  u_w = cat(3,u_w,zeros(nz+nz_extra,nx,nt_extra)) ; % [u_w, zeros(nz+nz_extra,nx,nt_extra)];
  % fourier
  u_w_ = zeros(nz_,nx,nt_);
  for i=1:nx
    u_w_(:,i,:) = fft2(  squeeze(u_w(:,i,:))  );
  end
end
function u_w = ifft_kzft(u_w_,nz,nt)
  % ------------------------------------
  % ifourier on plane (kz,ft) -> (z,x,t)
  % ------------------------------------
  
  [nkz,nx,nft] = size(u_w_);
  u_w = zeros(nkz,nx,nft);
  for i=1:nx
    u_w__ = ifft2(  squeeze(u_w_(:,i,:))  );
    u_w(:,i,:) = real(u_w__);
  end
  
  % trim padded edges
  u_w = u_w(1:nz,:,1:nt);
end
function fu = f_down(nz,nx,nt)
  % ------------------------------------
  % fk filter for down going waves,
  % 
  % ft
  % 0 1
  % 1 0 kz
  %
  % although it actually returns fu in 
  % shiffted domain.
  % ------------------------------------
  if mod(nt,2) == 1
    nt_half = ceil(nt/2);
  else
    nt_half = (nt/2) + 1;
  end
  if mod(nz,2) == 1
    nz_half = ceil(nz/2);
  else
    nz_half = (nz/2) + 1;
  end
  % 2d version: (kz,kt) plane
  fu = zeros(nz,nt);
  fu(1:nz_half-1,nt_half:nt) = 1;
  fu(nz_half+1:nz,1:nt_half-1) = 1;
  % fft shift 
  fu = fftshift(fu);
  % 3d version: (kz,x,kt) cube
  fu = repmat(fu,[1,1,nx]);
  fu = permute(fu,[1 3 2]);
end









