function b = beamformer_(fo,r,d_,f,v,theta)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% b = zeros(ntheta,nv);
[nf,nr] = size(d_);
nv = numel(v);
ntheta = numel(theta);
k = [cos(theta).' sin(theta).'];

% kv*r.' is of size (theta by r)
% kv*r.' * d_(ifo,:).' is of size (theta by 1)
% 
b = zeros(ntheta,nv);
for i=1:nv
  kv = k/v(i);
  b(:,i) = exp(1i*2*pi*fo*kv*r.') * (d_(binning(f,fo),:).');
end
b = b/nr;
% % kv*r.' is of size (theta by r)
% % kv*r.' * d_.' is of size (theta by f)
% % 
% k_v_f = zeros(ntheta,nf,nv);
% for i=1:nv
%   kv = k/v(i);
%   k_v_f(:,:,i) = exp(1i*fo*kv*r.') * (d_.'); % * (some weight);
% end
% % k_v_f is to be stacked on frequencies,
% b = squeeze(sum(k_v_f,2)) / nf;
end