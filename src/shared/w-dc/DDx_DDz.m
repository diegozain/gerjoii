function [DDx,DDz] = DDx_DDz(n,m)
  % diego domenzain
  % spring 2019 @ BSU
  % ----------------------------------------------------------------------------
  % second degree derivative, 
  % second degree accurate.
  % 
  % fwd:               2 	−5 	 4 	−1
  % ctd:          1 	−2 	1
  % bwd: −1 	 4 	−5 	 2
  
  DDx = DDX(n,m);
  DDz = DDZ(n,m);
  
end

% --------------------------------------------
%   z derivative
% --------------------------------------------

% second degree derivative, 
% second degree accurate.
% 
% fwd:               2 	−5 	 4 	−1
% ctd:          1 	−2 	1
% bwd: −1 	 4 	−5 	 2

function DDz = DDZ(n,m)
  
  fwd = [2*ones(1,n) -5*ones(1,n) 4*ones(1,n) -1*ones(1,n) zeros(1,n*m-4*n)];
  I = 1:n;
  I = repmat(I,1,m);
  J = 1:n*m;
  dz_fwd = sparse(I,J,fwd);
  
  ctd = [1*ones(1,n*m-2*n) -2*ones(1,n*m-2*n) 1*ones(1,n*m-2*n)];
  I = 1:n*m-2*n;
  I = repmat(I,1,3);
  J = [(1:n*m-2*n) (n+1:n*m-2*n+n) (n+n+1:n*m-2*n+n+n)];
  dz_ctd = sparse(I,J,ctd);
  
  bwd = [zeros(1,n*m-4*n) -1*ones(1,n) 4*ones(1,n) -5*ones(1,n) 2*ones(1,n)];
  I = 1:n;
  I = repmat(I,1,m);
  J = 1:n*m;
  dz_bwd = sparse(I,J,bwd);
  
  DDz = [dz_fwd; dz_ctd; dz_bwd];
  
end

% --------------------------------------------
%   x derivative
% --------------------------------------------

% second degree derivative, 
% second degree accurate.
% 
% fwd:               2 	−5 	 4 	−1
% ctd:          1 	−2 	1
% bwd: −1 	 4 	−5 	 2

function DDx = DDX(n,m)
  
  % takes second derivative on n points,
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
  
  DDx = DD_x(n);
  id = speye(m);
  
  DDx = kron(id,DDx);
end

function DDx_ = DD_x(n)
  %
  % second degree accurate,
  % second derivative matrix for
  % 1D discretization on
  % n pts.
  % 
  % fwd:               2 	−5 	 4 	−1
  % ctd:          1 	−2 	1
  % bwd: −1 	 4 	−5 	 2
  
  fwd = [2 -5 4 -1];  
  dx_fwd = [fwd zeros(1,n-4)];
  dx_fwd = sparse(dx_fwd);
  
  ctd = [1*ones(1,n-2) -2*ones(1,n-2) 1*ones(1,n-2)];
  I = 1:n-2;
  I = repmat(I,1,3);
  J = [(1:n-2) (1+1:n-2+1) (1+1+1:n-2+1+1)];
  dx_ctd = sparse(I,J,ctd);
  
  bwd = [-1 4 -5 2];
  dx_bwd = [zeros(1,n-4) bwd];
  dx_bwd = sparse(dx_bwd);
  
  DDx_ = [dx_fwd; dx_ctd; dx_bwd];
end