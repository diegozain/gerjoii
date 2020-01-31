function parame_ = w_epsilon(parame_,geome_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% build permittivity.
% this is one specific builder for layered media. 
% use fancier methods, this is boring.
% ..............................................................................
n=geome_.n;
m=geome_.m;
epsilon_z=parame_.natu.epsilon_z;
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
% build materials
%
i = 0;
for j=1:length(epsilon_z)-1
    zm = round(m/lp(j));
    ez(i+1:i+zm) = epsilon_z(j);
    i = i + zm;
end
ez(i+1:m)   = epsilon_z(j+1);
% use outer product to form matrix!
%
epsilon_w   = ez .'* ones(1,n);
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

a = parame_.natu.eps_fig_pos(1,:);
b = parame_.natu.eps_fig_pos(2,:);
c = parame_.natu.eps_fig_pos(3,:);
eps_fig = parame_.natu.eps_fig;

lx = ceil(parame_.natu.eps_fig_lxcenter/geome_.dx);
lz = ceil(parame_.natu.eps_fig_lzcenter/geome_.dy);
lxx = ceil(parame_.natu.lx/geome_.dx);
lzz = ceil(parame_.natu.lz/geome_.dy);

z = (a(1)+lzz):(c(1)+lz); x = a(2):b(2);

% epsilon_w(z,x)   = eps_fig;
epsilon_w(z,x-1*lxx)   = eps_fig;
epsilon_w(z,x+1*lxx)   = eps_fig;

% % smooth parameters
% %
% for i=1:8
%      epsilon_w = smooth(epsilon_w(:));
%      epsilon_w = reshape(epsilon_w,[n,m])';
%      epsilon_w = smooth(epsilon_w(:));
%      epsilon_w = reshape(epsilon_w,[n,m])';     
% end

parame_.natu.epsilon_w = epsilon_w;
end
