function [Dx,Dz] = Dx_Dz(n,m)
  % diego domenzain
  % fall 2018 @ BSU
  % ----------------------------------------------------------------------------
  % first degree derivative, 
  % second degree accurate.
  % 
  % fwd:             −1.5 	 2 	−0.5
  % ctd:        −0.5 	 0 	 0.5
  % bwd:   0.5 	−2 	 1.5
  %
  % Dx: vertical derivative of a matrix
  % Dz: horizontal derivative of a matrix.
  % they are for transposed matricies. dont whine.
  % ----------------------------------------------------------------------------
  % example:
  % [nz,nx] = size(a);
  % [Dz,Dx] = Dx_Dz(nz,nx);
  % ----------------------------------------------------------------------------
  Dx = DX(n,m);
  Dz = DZ(n,m);
end

% --------------------------------------------
%   z derivative
% --------------------------------------------

% first degree derivative, 
% second degree accurate.
% 
% fwd:             −1.5 	 2 	−0.5
% ctd:        −0.5 	 0 	 0.5
% bwd:   0.5 	−2 	 1.5

function Dz = DZ(n,m)
  % fwd
  fwd = [-1.5*ones(1,n) 2*ones(1,n) -0.5*ones(1,n) zeros(1,n*m-3*n)];
  I = 1:n;
  I = repmat(I,1,m);
  J = 1:n*m;
  dz_fwd = sparse(I,J,fwd);
  % center
  ctd = [-0.5*ones(1,n*m-2*n) zeros(1,n*m-2*n) 0.5*ones(1,n*m-2*n)];
  I = 1:n*m-2*n;
  I = repmat(I,1,3);
  J = [(1:n*m-2*n) (n+1:n*m-2*n+n) (n+n+1:n*m-2*n+n+n)];
  dz_ctd = sparse(I,J,ctd);
  % bwd
  bwd = [zeros(1,n*m-3*n) 0.5*ones(1,n) -2*ones(1,n) 1.5*ones(1,n)];
  I = 1:n;
  I = repmat(I,1,m);
  J = 1:n*m;
  dz_bwd = sparse(I,J,bwd);
  % together
  Dz = [dz_fwd; dz_ctd; dz_bwd];
end

% --------------------------------------------
%   x derivative
% --------------------------------------------

% first degree derivative, 
% second degree accurate.
% 
% fwd:             −1.5 	 2 	−0.5
% ctd:        −0.5 	 0 	 0.5
% bwd:   0.5 	−2 	 1.5

function Dx = DX(n,m)
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
  
  Dx = D_x(n);
  id = speye(m);
  
  Dx = kron(id,Dx);
end

function Dx_ = D_x(n)
  %
  % second degree accurate,
  % first derivative matrix for
  % 1D discretization on
  % n pts.
  %
  % fwd:             −1.5 	 2 	−0.5
  % ctd:        −0.5 	 0 	 0.5
  % bwd:   0.5 	−2 	 1.5
  
  fwd = [-1.5 2 -0.5];  
  dx_fwd = [fwd zeros(1,n-3)];
  dx_fwd = sparse(dx_fwd);
  
  ctd = [-0.5*ones(1,n-2) zeros(1,n-2) 0.5*ones(1,n-2)];
  I = 1:n-2;
  I = repmat(I,1,3);
  J = [(1:n-2) (1+1:n-2+1) (1+1+1:n-2+1+1)];
  dx_ctd = sparse(I,J,ctd);
  
  bwd = [0.5 -2 1.5];
  dx_bwd = [zeros(1,n-3) bwd];
  dx_bwd = sparse(dx_bwd);
  
  Dx_ = [dx_fwd; dx_ctd; dx_bwd];
end