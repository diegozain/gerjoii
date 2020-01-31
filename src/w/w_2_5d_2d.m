function d_2d = w_2_5d_2d(d,filter_)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% -------------
% fft wavefield
% -------------
[nt,nr] = size(d);
% fft can't do this by itself so we help it,
nt_ = 2^nextpow2(nt);
nt_extra = nt_-nt;
d_extra = cat( 1,d,zeros(nt_extra,nr) );
% t data to f domain
f_d_f = fft(d_extra,[],1);
% df = 1/dt/nt_;
% f = (-nt_/2:nt_/2-1)*df;

% ----------------
% bleistein filter
% ----------------
% filter_ = sqrt(v_) * filter_;
f_d_f = f_d_f .* filter_;

% ---------------
% ifft wavefield
% ---------------
d = ifft(f_d_f,[],1);
% trim padded zeros because fft can't do this by itself
d = d(1:end-nt_extra,:);

d_2d = real(d);
end