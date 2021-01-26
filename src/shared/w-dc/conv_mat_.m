function H = conv_mat_(h,s)
% same as conv_mat.m but using toeplitz.m builder.
h=h.';
nh = numel(h);
ns = numel(s);
h = [h zeros(1,ns-1)];
h_= [h(1) zeros(1,ns-1)];
H = toeplitz(h_,h);
H = H.';
H = H(ceil((nh-1)/2)+1:nh+ns-1-floor((nh-1)/2),:);
% d = H*s;

end
