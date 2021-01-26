function [stft_, f, gau_] = stft(x, dt, t, alph, width_)
%
% 
% ------------------------------------------------------------------------------
x = x(:);
t = t(:);
nt= numel(x);
% ------------------------------------------------------------------------------
nt_=2^nextpow2(nt)+nt*0.1;
df = 1/dt/nt_;
f  = (1:ceil(nt_/2)-1)*df;

nt_extra = nt_-nt;
x = [x; zeros(nt_extra,1)];
t = [t ; ((t(nt)+dt) : dt : (dt*nt_extra+t(nt))).'];
% ------------------------------------------------------------------------------
gau_ = zeros(nt,numel(x));
nf   = numel(f);
stft_= zeros(nf, nt);
for il = 1:nt
    
    lo = t(il);
    
    gau = exp( -alph * ( ( ( t - lo ) ./ width_ ).^2 ) );

    x_ = x.*gau;
    
    x_ = fft(x_);

    x_ = x_(1:ceil(nt_/2)-1);

    stft_(:, il) = x_;
    gau_(il,:) = gau;
end
end