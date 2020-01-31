function B_At = interferateDI(d,dt)
% interferometry by multidimensional deconvolution,
% or more simply, just by deconvolution.
%
% input:
% d is the observed data, a cube of size (nt,nr,ns)
% dt is the discretization interval on the observed time.
% output:
% f is frequency vector
% B_At a cube of size (nt,na,nb) where one vertical plane 
% with a fixed is the virtual shot gather with virtual source a.
%
% Let ia be the index of receiver a, it would be called as,
% d_virt = squeeze(B_At(:,ia,:));

[nt,nr,ns] = size(d);
% ............................
% fourier to frequency domain
% ............................
% fft can't do this by itself so we help it,
nt_=2^nextpow2(nt);
nt_extra = nt_-nt;
d_extra = cat(1,d; zeros(nt_extra,nr,ns));
% t data to f domain
f_d_f = fft(d_extra,[],1);
df = 1/dt/nt_;
f = ((-nt_/2:nt_/2-1)*df).';
% ............................
% take A_S and B_S
% ............................
B_At = zeros(nt_,nr,nr);
parfor i_=1:nt_
  % size has to be (ns,na)
  A_S = squeeze(f_d_f(i_,:,:)).';
  B_S = A_S;
  % NOTE: check regularization techniques on A_S^{-1}
  B_A = A_S \ B_S;
  B_At(i_,:,:) = B_A;
end
% ............................
% fourier to time domain
% ............................
B_At = ifft(B_At,[],1);
B_At = real(B_At);
% trim padded zeros because fft can't do this by itself
B_At = B_At(1:end-nt_extra,:,:);
end