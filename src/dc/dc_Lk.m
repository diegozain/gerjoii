function finite_ = dc_Lk(parame_,finite_,gerjoii_)
%
%   diego domenzain
%   spring 2017
%   Boise State University
%
%					z
%			-----------------
%
%		|	1-------a-------3
%		|	| o-----------o |
%		|	| |           | |
%	x	|	b |           | d
%		|	| |           | |
%		|	| o-----------o |
%		|	2-------c-------4
%
%
%   grid inside -o- is inner grid.
%   -o- is inner grid boundary.
%
% output: 
% M is such that M*phi = q
%
% edge b has neumann, edges a,c,d have robin.
%
% input:
% n,m: size of n x m grid.
% SIGMA: conductivity in matrix form.
% DELTAS: grid size information, edge by edge in matrix form, 
%         DELTAS(:,:,i) i=1 vertical, i=2 horizontal.
%         ghost edges on a/b share values with ghost edges c/d.
% ALPHAS: matrix with alpha coefficients for Robin boundary.
% corners: corner coefficients for Robin boundary.

SIGMA = parame_.dc.sigma_robin;
DELTAS = finite_.dc.DELTAS;
n = finite_.dc.nx ; % geome_.n;
m = finite_.dc.nz ; % geome_.m;
s_dc = gerjoii_.dc.s;
ky = finite_.dc.ky;

s_dc = s_dc(1:n);
% s_dc is (n x 1) vector.
% only sources on the surface are supported by now!
[ALPHAS,corners] = alphas(n,m,DELTAS,s_dc,ky);

%---------------------------------------------------------------------%

% to transform code into all Neuman BC, 
% include edges a,d,c for Neu edges, then erase Robin part.

% to transform code into all Robin BC, 
% modify alphas.m to include all edges,
% include edge b for Robin edges, then erase Neu part.

%---------------------------------------------------------------------%

MM = zeros(n,m,6);

% this MM is the real trick to build M.
% it has 5 copies of the grid,
%
% MM(:,:,1) entries for M of DOWN neighbors of (:,:)
% MM(:,:,2) entries for M of UP neighbors of (:,:)
% MM(:,:,3) entries for M of RIGHT neighbors of (:,:)
% MM(:,:,4) entries for M of LEFT neighbors of (:,:)
% MM(:,:,5) entries for M of GHOST neighbors of (:,:)
% MM(:,:,6) entries for M of -STACK of all neighbors of (:,:)

% for what follows, node i has neighbor j (grid indexed like book).
% node i has (matrix form) coordinates (l,h)
% neighbor j has (matrix form) coordinates (lj,hj).

%---------------------%
% i & its j neighbors %
%---------------------%
% i:
l = 2:n-1;
h = 2:m-1;
% vertical (down) neighbor
% j:
lj_r = 3:n;
hj_r = h;
% vertical (up) neighbor
% j:
lj_l = 1:n-2;
hj_l = h;
% horizontal (right) neighbor
% j:
lj_d = l;
hj_d = 3:m;
% horizontal (left) neighbor
% j:
lj_u = l;
hj_u = 1:m-2;

%----------------------------------------------------------------------
%             inner nodes 
%----------------------------------------------------------------------

% vertical (down) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l+1,h) /
%                (\sigma(l,h) + \sigma(l+1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l+1,h,1) )
%
% j:
lj = lj_r;
hj = hj_r;
MM(l,h,1) = -2*SIGMA(l,h).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,h) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                   (2*DELTAS(lj_r,hj_r,1))); 
               
% vertical (up) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l-1,h) /
%                (\sigma(l,h) + \sigma(l-1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l,h,1) )
%
% j:
lj = lj_l;
hj = hj_l;
MM(l,h,2) = -2*SIGMA(l,h).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,h) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                   (2*DELTAS(l,h,1)));
               
% horizontal (right) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h+1) /
%                (\sigma(l,h) + \sigma(l,h+1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h+1,2) )
%
% j:
lj = lj_d;
hj = hj_d;
MM(l,h,3) = -2*SIGMA(l,h).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,h) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                   (2*DELTAS(lj_d,hj_d,2))); 
               
% horizontal (left) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h-1) /
%                (\sigma(l,h) + \sigma(l,h-1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h,2) )
%
% j:
lj = lj_u;
hj = hj_u;
MM(l,h,4) = -2*SIGMA(l,h).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,h) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                   (2*DELTAS(l,h,2)));
			   
%----------------------------------------------------------------------
%            NEU nodes 
%----------------------------------------------------------------------

% edge b
%

% vertical (down) neighbor
% j:
lj = lj_r;
hj = 1;
hj_d = 2;
hj_r = 1;
MM(l,1,1) = -2*SIGMA(l,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,1,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                   (2*DELTAS(lj_r,hj_r,1)));
               
% vertical (up) neighbor
% j:
lj = lj_l;
hj = 1;
MM(l,1,2) = -2*SIGMA(l,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,1,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                   (2*DELTAS(l,1,1)));
               
% horizontal (right) neighbor
% j:
lj = lj_d;
hj = 2;
MM(l,1,3) = -2*SIGMA(l,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(l,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(l,1,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                   (2*DELTAS(lj_d,hj_d,2)));
%-------------%
% NEU corners %
%-------------%
% corner 1

% vertical (down) neighbor
% j:
lj = 2;
hj = 1;
MM(1,1,1) = -2*SIGMA(1,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(1,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(1,1,2) + DELTAS(1,2,2)) ./ ...
                   (2*DELTAS(2,1,1)));
               
% horizontal (right) neighbor
% j:
lj = 1;
hj = 2;
MM(1,1,3) = -2*SIGMA(1,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(1,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(1,1,1) + DELTAS(2,1,1)) ./ ...
                   (2*DELTAS(1,2,2)));

%-------------%
% NEU corners %
%-------------%
% corner 2

% vertical (up) neighbor
% j:
lj = n-1;
hj = 1;
MM(n,1,2) = -2*SIGMA(n,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(n,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(n,1,2) + DELTAS(n,2,2)) ./ ...
                   (2*DELTAS(n,1,1)));

% horizontal (right) neighbor
% j:
lj = n;
hj = 2;
MM(n,1,3) = -2*SIGMA(n,1).*SIGMA(lj,hj) ./ ...
                   (SIGMA(n,1) + SIGMA(lj,hj)) .* ...
                   ((DELTAS(n,1,1) + DELTAS(1,1,1)) ./ ...
                   (2*DELTAS(n,2,2)));
        
%----------------------------------------------------------------------
%             ROBIN nodes 
%----------------------------------------------------------------------

%     nR = (m-1) + n + (m-1);

%---------
% edge a
%---------

% i:
l = 1;
h = 2:m-1;

% vertical (down) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l+1,h) /
%                (\sigma(l,h) + \sigma(l+1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l+1,h,1) )
%
MM(l,h,1) = -2*SIGMA(l,h).*SIGMA(l+1,h) ./ ...
                   (SIGMA(l,h) + SIGMA(l+1,h)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                   (2*DELTAS(l+1,h,1)));
               
% horizontal (right) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h+1) /
%                (\sigma(l,h) + \sigma(l,h+1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h+1,2) )
%
MM(l,h,3) = -2*SIGMA(l,h).*SIGMA(l,h+1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h+1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                   (2*DELTAS(l,h+1,2)));
               
% horizontal (left) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h-1) /
%                (\sigma(l,h) + \sigma(l,h-1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h,2) )
%
MM(l,h,4) = -2*SIGMA(l,h).*SIGMA(l,h-1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h-1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                   (2*DELTAS(l,h,2)));
               
% vertical (up) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l-1,h) /
%                (\sigma(l,h) + \sigma(l-1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l,h,1) )
%
MM(l,h,5) = -SIGMA(l,h).* ...
                  ( (DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                   (2) ) .* ...
                   ALPHAS(l,h); 
                
%---------
% edge d
%---------

% i:
l = 2:n-1;
h = m;

% vertical (up) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l+1,h) /
%                (\sigma(l,h) + \sigma(l+1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l+1,h,1) )
%
MM(l,h,1) = -2*SIGMA(l,h).*SIGMA(l+1,h) ./ ...
                   (SIGMA(l,h) + SIGMA(l+1,h)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2*DELTAS(l+1,h,1)));
               
% horizontal (right) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h+1) /
%                (\sigma(l,h) + \sigma(l,h+1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h+1,2) )
%
MM(l,h,5) = -SIGMA(l,h).*...
                   ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                   (2)) .* ...
                   ALPHAS(l,h);
               
% horizontal (left) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h-1) /
%                (\sigma(l,h) + \sigma(l,h-1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h,2) )
%
MM(l,h,4) = -2*SIGMA(l,h).*SIGMA(l,h-1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h-1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                   (2*DELTAS(l,h,2)));
               
% vertical (up) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l-1,h) /
%                (\sigma(l,h) + \sigma(l-1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l,h,1) )
%
MM(l,h,2) = -2*SIGMA(l,h).*SIGMA(l-1,h) ./ ...
                   (SIGMA(l,h) + SIGMA(l-1,h)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2*DELTAS(l,h,1)));
               
%---------
% edge c
%---------

% i:
l = n;
h = 2:m-1;

% vertical (down) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l+1,h) /
%                (\sigma(l,h) + \sigma(l+1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l+1,h,1) )
%
MM(l,h,5) = -SIGMA(l,h).*...
                   ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2)) .* ...
                   ALPHAS(l,h);
               
% horizontal (right) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h+1) /
%                (\sigma(l,h) + \sigma(l,h+1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h+1,2) )
%
MM(l,h,3) = -2*SIGMA(l,h).*SIGMA(l,h+1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h+1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                   (2*DELTAS(l,h+1,2)));
               
% horizontal (left) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h-1) /
%                (\sigma(l,h) + \sigma(l,h-1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h,2) )
%
MM(l,h,4) = -2*SIGMA(l,h).*SIGMA(l,h-1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h-1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                   (2*DELTAS(l,h,2)));
               
% vertical (up) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l-1,h) /
%                (\sigma(l,h) + \sigma(l-1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l,h,1) )
%
MM(l,h,2) = -2*SIGMA(l,h).*SIGMA(l-1,h) ./ ...
                   (SIGMA(l,h) + SIGMA(l-1,h)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                   (2*DELTAS(l,h,1)));

%------------               
% corner 3
%------------

%i
l = 1;
h = m;

% vertical (down) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l+1,h) /
%                (\sigma(l,h) + \sigma(l+1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l+1,h,1) )
%
MM(l,h,1) = -2*SIGMA(l,h).*SIGMA(l+1,h) ./ ...
                   (SIGMA(l,h) + SIGMA(l+1,h)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2*DELTAS(l+1,h,1)));

% vertical (up) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l-1,h) /
%                (\sigma(l,h) + \sigma(l-1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l,h,1) )
%
MM(l,h,5) = -SIGMA(l,h).*...
                  ( (DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2) ) .* ...
                   corners(1,1);
               
% horizontal (right) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h+1) /
%                (\sigma(l,h) + \sigma(l,h+1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h+1,2) )
%
MM(l,h,5) = MM(l,h,5) - SIGMA(l,h).*...
                   ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                   (2)) .* ...
                   corners(2,1);
               
% horizontal (left) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h-1) /
%                (\sigma(l,h) + \sigma(l,h-1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h,2) )
%
MM(l,h,4) = -2*SIGMA(l,h).*SIGMA(l,h-1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h-1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                   (2*DELTAS(l,h,2)));


%------------               
% corner 4
%------------

%i
l = n;
h = m;

% vertical (down) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l+1,h) /
%                (\sigma(l,h) + \sigma(l+1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l+1,h,1) )
%
MM(l,h,5) = -SIGMA(l,h).*...
                   ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2)) .* ...
                   corners(1,2);
               
% vertical (up) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l-1,h) /
%                (\sigma(l,h) + \sigma(l-1,h)) \odot
%               ( (\Delta(l,h,2) + \Delta(l,h+1,2)) /
%                  2\Delta(l,h,1) )
%
MM(l,h,2) = -2*SIGMA(l,h).*SIGMA(l-1,h) ./ ...
                   (SIGMA(l,h) + SIGMA(l-1,h)) .* ...
                   ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                   (2*DELTAS(l,h,1)));
               
% horizontal (right) GHOST neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h+1) /
%                (\sigma(l,h) + \sigma(l,h+1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h+1,2) )
%
MM(l,h,5) = MM(l,h,5) - SIGMA(l,h).*...
                   ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                   (2)) .* ...
                   corners(2,2); 
               
% horizontal (left) neighbor
%
% this entry is -2\sigma(l,h) \odot \sigma(l,h-1) /
%                (\sigma(l,h) + \sigma(l,h-1)) \odot
%               ( (\Delta(l,h,1) + \Delta(l+1,h,1)) /
%                  2\Delta(l,h,2) )
%
MM(l,h,4) = -2*SIGMA(l,h).*SIGMA(l,h-1) ./ ...
                   (SIGMA(l,h) + SIGMA(l,h-1)) .* ...
                   ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                   (2*DELTAS(l,h,2)));               

%-------------------------------------------------------------------------%
               
% stack of neighbors
%
MM(:,:,6) =  - MM(:,:,1) - MM(:,:,2) ...
             - MM(:,:,3) - MM(:,:,4) ...
             - MM(:,:,5);

%----------------------------------------------------------------------
%             build M 
%----------------------------------------------------------------------

I = zeros(n*m,1);
J = zeros(n*m,1);
V = zeros(n*m,1);

%--------------------------------------
% inner
%--------------------------------------

k=1;
for l=2:n-1
    for h=2:m-1
        i = coordP([l,h],n);
        % vertical (down) neighbors
        j = i + 1;
        J(k) = j;
        I(k) = i;
        V(k) = MM(l,h,1);
        k=k+1;
        % vertical (up) neighbors
        j = i - 1;
        J(k) = j;
        I(k) = i;
        V(k) = MM(l,h,2);
        k=k+1;
        % horizontal (right) neighbors
        j = i + n;
        J(k) = j;
        I(k) = i;
        V(k) = MM(l,h,3);
        k=k+1;
        % horizontal (left) neighbors
        j = i - n;
        J(k) = j;
        I(k) = i;
        V(k) = MM(l,h,4);
        k=k+1;
        % inner nodes
        J(k) = i;
        I(k) = i;
        V(k) = MM(l,h,6);
        k=k+1;
    end
end

%--------------------------------------
% neu edge b
%--------------------------------------

h=1;
for l=2:n-1
    i = coordP([l,h],n);
    % vertical (down) neighbors
    j = i + 1;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,1);
    k=k+1;
    % vertical (up) neighbors
    j = i - 1;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,2);
    k=k+1;
    % horizontal (right) neighbors
    j = i + n;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,3);
    k=k+1;
    % inner nodes
    J(k) = i;
    I(k) = i;
    V(k) = MM(l,h,6);
    k=k+1;
end

%--------------------------------------
% corner 1
%--------------------------------------

i = 1;
% vertical (down) neighbor
j = i + 1;
J(k) = j;
I(k) = i;
V(k) = MM(1,1,1);
k=k+1;
% horizontal (right) neighbor
j = i + n;
J(k) = j;
I(k) = i;
V(k) = MM(1,1,3);
k=k+1;
% inner node
J(k) = i;
I(k) = i;
V(k) = MM(1,1,6);
k=k+1;

%--------------------------------------
% corner 2
%--------------------------------------

i = n;
% vertical (up) neighbor
j = i - 1;
J(k) = j;
I(k) = i;
V(k) = MM(n,1,2);
k=k+1;
% horizontal (right) neighbor
j = i + n;
J(k) = j;
I(k) = i;
V(k) = MM(n,1,3);
k=k+1;
% inner node
J(k) = i;
I(k) = i;
V(k) = MM(n,1,6);
k=k+1;

%--------------------------------------
% robin edge a
%--------------------------------------

l=1;
for h=2:m-1
    i = coordP([l,h],n);
    % vertical (down) neighbors
    j = i + 1;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,1);
    k=k+1;
    % horizontal (left) neighbors
    j = i - n;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,4);
    k=k+1;
    % horizontal (right) neighbors
    j = i + n;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,3);
    k=k+1;
    % inner nodes
    J(k) = i;
    I(k) = i;
    V(k) = MM(l,h,6);
    k=k+1;
end

%--------------------------------------
% robin edge d
%--------------------------------------

h=m;
for l=2:n-1
    i = coordP([l,h],n);
    % vertical (down) neighbors
    j = i + 1;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,1);
    k=k+1;
    % vertical (up) neighbors
    j = i - 1;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,2);
    k=k+1;
    % horizontal (left) neighbors
    j = i - n;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,4);
    k=k+1;
    % inner nodes
    J(k) = i;
    I(k) = i;
    V(k) = MM(l,h,6);
    k=k+1;
end

%--------------------------------------
% robin edge c
%--------------------------------------

l=n;
for h=2:m-1
    i = coordP([l,h],n);
    % horizontal (left) neighbors
    j = i - n;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,4);
    k=k+1;
    % vertical (up) neighbors
    j = i - 1;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,2);
    k=k+1;
    % horizontal (right) neighbors
    j = i + n;
    J(k) = j;
    I(k) = i;
    V(k) = MM(l,h,3);
    k=k+1;
    % inner nodes
    J(k) = i;
    I(k) = i;
    V(k) = MM(l,h,6);
    k=k+1;
end

%--------------------------------------
% corner 3
%--------------------------------------

i = n*(m-1) + 1;
% vertical (down) neighbor
j = i + 1;
J(k) = j;
I(k) = i;
V(k) = MM(1,m,1);
k=k+1;
% horizontal (left) neighbor
j = i - n;
J(k) = j;
I(k) = i;
V(k) = MM(1,m,4);
k=k+1;
% inner node
J(k) = i;
I(k) = i;
V(k) = MM(1,m,6);
k=k+1;

%--------------------------------------
% corner 4
%--------------------------------------

i = n*m;
% vertical (up) neighbor
j = i - 1;
J(k) = j;
I(k) = i;
V(k) = MM(n,m,2);
k=k+1;
% horizontal (left) neighbor
j = i - n;
J(k) = j;
I(k) = i;
V(k) = MM(n,m,4);
k=k+1;
% inner node
J(k) = i;
I(k) = i;
V(k) = MM(n,m,6);

%-------------------------------------------------------------------------%

Lk = sparse(I,J,V);

finite_.dc.Lk = -Lk + (ky^2)*sparse_diag( SIGMA(:) );
finite_.dc.ALPHASk = ALPHAS;
finite_.dc.cornersk = corners;
end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%-------------------------private function--------------------------------%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

function [ALPHAS,corners] = alphas(n,m,DELTAS,s_dc,ky)
%
%   diego domenzain
%   spring 2017
%   Boise State University
%
%   1-------b-------2
%   | o-----------o |
%   | |           | |
%   a |           | c
%   | |           | |
%   | o-----------o |
%   3-------d-------4
%
%
% beta_ = sign(sources)
% co = cateto opuesto
% ca = cateto adyacente
%  r = sqrt(co^2 + ca^2)
% nR = size of \Gamma_R
% nN = size of \Gamma_N
%
% 1.
%              .--------------.
%              |       ca     |
%       .---------------.     |
%       |               |     |
%       |               |     |
%  nR   |      co       |     |
%       |               |-----.
%       |               |
%       .---------------.  
%
%               nN
%
% 2.
%              .--------------.
%              | cos(theta)/r |
%       .---------------.     |
%       |               |     |   *   beta_
%       |               |     |
%  nR   |    ln(r)      |     |
%       |               |-----.
%       |               |
%       .---------------.  
%
%               nN
%
% 3.
%              
%              
%       .----.     
%       | a  |     
%       | l  |     
%  nR   | p  |    
%       | h  |
%       | a  |
%       .----.  
%         1
%              
%

%     nR = (m-1) + n + (m-1);

% s_dc is (n x 1) vector.
% only sources on the surface are supported by now!
beta_ = sign(s_dc);

%-------------------
% opposite sides
%-------------------

% left side
%
co_left  = zeros(m-1,n);
co_left(1,:) = DELTAS(:,2,2)';
for i=2:m-1
co_left(i,:) = co_left(i-1,:) + DELTAS(:,i+1,2)';
end

% bottom side
%
co_down  = zeros(n,n);
for i=1:n-1
for j=1+i:n
    co_down(i,j) = co_down(i,j-1) + DELTAS(j,1,1);
    co_down(j,i) = co_down(i,j);
end
end

% right side
%
co_right = flip(co_left);
co_right = flip(co_right,2);

co = [co_left; co_down; co_right];

%--------------------
% adjacent sides
%--------------------

% left side
%
ca_left  = zeros(m-1,n);
for j=2:n
ca_left(1:m-1,j) = ca_left(1:m-1,j-1) + DELTAS(j,1,1);
end

% bottom side
%
ca_down  = sum( DELTAS(1,2:m,2) ) * ones(n,n);

% right side
%
ca_right = flip(ca_left);
ca_right = flip(ca_right,2);

ca = [ca_left; ca_down; ca_right];

%---------------------------------------------------------------------%

% hypothenuses
%
r = sqrt( co.^2 + ca.^2 );

% % pre-alpha
% %
% lnr  = log(r);
% cos_ = ca ./ (r.^2); 
numerat = ky * besselk(1,ky*r) .* (ca./r);
denumer = besselk(0,ky*r);

% dot prod beta_
%
denumer = denumer * beta_;
numerat = numerat * beta_;

% alpha
%
alpha_s = numerat ./ denumer;

% build ALPHAS in grid
%
ALPHAS = zeros(n,m);

ALPHAS(1,2:m-1) = alpha_s(1:m-2);
ALPHAS(2:n-1,m) = alpha_s(m+1:m+n-2);
ALPHAS(n,2:m-1) = flip(alpha_s(m+n+1:end));

corner3 = [alpha_s(m-1); alpha_s(m)];
corner4 = [alpha_s(m+n-1); alpha_s(m+n)];

corners = [corner3 corner4];

end
