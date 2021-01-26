function [H,d] = conv_mat(h,s)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% given the time domain convolution
% 
% h*s = d
% 
% this function gives the time domain matrix representation
% 
% H * s = d
% 
%  s is a time series of size n
%  h is a time series of size m
%  H is an (m+n-1 by n) matrix
%
% it can also give d of the same size as s.
% 
% usage: [H,d] = conv_mat( h , s )
%
% ------------------------------------------------------------
% 
% NOTE:
% 
% convolution in the frequency domain is done this way,
% ( padding is VERY important!!!!!!!! )
% 
% pad = m+n-1;                                
% d = ifft( fft(h,pad) .* fft(s,pad) ,pad )
%  
% ------------------------------------------------------------
%
% If you'd rather get the representation
% 
%  S * h = d
% 
%  S is an (n+m-1 by m) matrix
% 
%  it can also give d of the same size as h.
%
% usage: [S,d] = conv_mat( s , h )
%
% ------------------------------------------------------------
% 
% it also does cross-correlation matricies:
% 
% Hstar = conv_mat(flip(h),s); Hstar * s
%
% xcorr(s,h) = Hstar * s

m = numel(h);
n = numel(s);
H = sparse(m+n,n);
for k=0:n-1
  H(1+k:m+k, k+1 ) = h;
end
% same size as s
% option 1. cut H
% option 2. cut result d
H = H(ceil((n-1)/2)+1-ceil(n/2)+m-ceil(m/2):end-ceil(m/2),:);
% convolution
d = H*s;

% % option 2. cut result d
% d = d(ceil((n-1)/2)+1-ceil(n/2)+m-ceil(m/2):end-ceil(m/2));
end

% example:
% 
% d = h * s 
% 
% s is the source (size ns)
% d = d(s,h) is synth data (size nt)
% d_o is observed data (size nt)
% h is the earth's green function response (size nh = nd-ns+1)
%
% source estimation:
%
%    . initial guess for s and h
%    . S  = conv_mat(s,h);
%    . h_ = S\d; % h_ is size of h
%    . H_ = conv_mat(h_,s);
%    . s = H_\d; % s is size of s
%
% ------------------------------------------------------------------------------
% another example:
%
% s = randn(100,1);
% h = ones(5,1); h = h/norm(h); nh=numel(h);
% [H,s_] = conv_mat(h,s);
% s__ = conv(s,h,'same');
% 
% figure;
% hold on
% plot(s,'k-','Linewidth',2);
% plot(s_,'r-','Linewidth',2);
% plot(s__,'b--','Linewidth',2);
% hold off
% axis tight









