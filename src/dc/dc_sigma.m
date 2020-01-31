function parame_ = dc_sigma(parame_,geome_)

n=geome_.n;
m=geome_.m;
sig_e=parame_.natu.sig_e;
lp=parame_.natu.lp;

%               n (x)
%          --------------
%          |            |
%          |  eps_r_z   |
%   m (z)  |  sig_e_z   |
%          |            |
%          |            |
%          --------------
%
%
%  this method has to build transposed. sorry :(

% build materials
%
i = 0;
for j=1:length(sig_e)-1
    zm = round(m/lp(j));
    sigz(i+1:i+zm) = sig_e(j);
    i = i + zm;
end

sigz(i+1:m) = sig_e(j+1);

% use outer product to form matrix!
%
sigma_dc = sigz .'* ones(1,n);

% --------------------
%         figure inside
% --------------------
% 
%            x (n)
%    ---.----------------.---
%       |                |
%     z |   a .---.b     |
%    (m)|     |   |      |
%       |   c ·---·      |
%       ·----------------·
% 
%           a = [az,ax]
%           b = [bz,bx]
%           c = [cz,cx]
%           sig_fig_pos = [a;b;c]
%
%           sig(az:cz,ax:bx) = fig

a = parame_.natu.sig_fig_pos(1,:);
b = parame_.natu.sig_fig_pos(2,:);
c = parame_.natu.sig_fig_pos(3,:);
sig_fig = parame_.natu.sig_fig;

z = a(1):c(1); x = a(2):b(2);

lx = ceil(parame_.natu.sig_fig_lxcenter/geome_.dx);
lz = ceil(parame_.natu.sig_fig_lzcenter/geome_.dy);
lxx = ceil(parame_.natu.lx/geome_.dx);

% sigma_dc(z,x-2*lxx)   = sig_fig;
% sigma_dc(z,x)   = sig_fig;
sigma_dc(z,x+2*lxx)   = sig_fig;

% % sigma_dc(z,x)   = sig_fig;
% % sigma_dc(z,x-5*lx)   = sig_fig;
% sigma_dc(z,x-3*lx)   = sig_fig;
% sigma_dc(z,x-lx)   = sig_fig;
% sigma_dc(z,x+lx)   = sig_fig;
% sigma_dc(z,x+3*lx)   = sig_fig;
% % sigma_dc(z,x+5*lx)   = sig_fig;

sigma_dc = sigma_dc';

parame_.natu.sigma_dc = sigma_dc;
end
