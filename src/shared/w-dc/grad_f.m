function [dx_f,dz_f,D_x,D_z] = grad_f(f,DELTAS)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
[n,m] = size(f);

dx = DELTAS(:,:,1);
dz = DELTAS(:,:,2).';

D_x = Dxx(n,m) * sparse(1:n*m,1:n*m,1./dx(:));
D_z = Dxx(m,n) * sparse(1:n*m,1:n*m,1./dz(:));

dx_f = D_x * f(:);
dx_f = reshape(dx_f,[n,m]);

f_ = f.';
dz_f = D_z * f_(:);
dz_f = reshape(dz_f,[m,n]).';

end

function DX = Dxx(n,m)

% takes first derivative on n points,
% and does this for m times,
%
%                 n
%        .-------------------.
%        |                   |
%        |                   |
%    m   |       DX          |
%        |                   |
%        |                   |
%        .-------------------.
%
%
%       .-----.
%       |     |
%       |     | n     f is (n*m x 1)
%       |     | .
%       |  f  | .
%       |     | .
%       |     | n
%       |     |
%       .-----.
%
% DX * f = dx(f)
%
% where dx is in the direction of n.

DX = Dx(n);
id = speye(m);

DX = kron(id,DX);

end

function Dx_ = Dx(n)
%
% second degree accurate,
% first derivative matrix for
% 1D discretization on
% n pts.

v = 0.5 * ones(1,n-1);
v(end)=2;
Dx_ = diag(v,-1) + diag(-flip(v),1);
Dx_(1) = 1.5;
Dx_(end) = -1.5;
Dx_(end-2*n) = -0.5;
Dx_(2*n+1) = 0.5;

Dx_ = -sparse(Dx_);

end

