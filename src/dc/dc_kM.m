function kMdc = dc_kM(s_dc,Mdc,DELTAS,n,m,nd)

% computes geometric correction for potential:
%
% L = L(conductivity = 1)
%
% L*u = s --> d = M*u --> k = i / d

sig_ones = ones(n,m);
error_dc  = zeros(nd,1);

[~,k_dc,~,~,~,~] = dc_fwd(sig_ones,s_dc,Mdc,error_dc,DELTAS,n,m);

k_dc = 1 ./ k_dc;

kMdc = diag(k_dc) * Mdc;

% I = find(s_dc);
% kMdc( I , : ) = 0;

kMdc = sparse(kMdc);

end
