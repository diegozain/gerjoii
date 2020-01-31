function Sdc = dc_S(parame_,finite_,Udc)
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
	% Sdc is such that Sdc * a = g. (a adjoint, g gradient)
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
	% Udc: potential field in matrix form.
    
    %---------------------------------------------------------------------%
    
    

	% this file should go with a manual.pdf
	% read that for more information.


    
    %---------------------------------------------------------------------%
    
    n = finite_.dc.nx ; % geome_.n;
    m = finite_.dc.nz ; % geome_.m;
    SIGMA = parame_.dc.sigma_robin;
    DELTAS = finite_.dc.DELTAS;
    ALPHAS = finite_.dc.ALPHAS;
    corners = finite_.dc.corners;
	
    SB = zeros(n,m,4);
    SA = zeros(n,m,4);
    SD = zeros(n,m,4);

    SR = zeros(n,m);
    
    % these S(B,A,D) are the real trick to build S.
    % they have 4 copies of the grid. For example SA
    %
    % SA(:,:,1) entries for SA of DOWN neighbors of (:,:)
    % SA(:,:,2) entries for SA of UP neighbors of (:,:)
    % SA(:,:,3) entries for SA of RIGHT neighbors of (:,:)
    % SA(:,:,4) entries for SA of LEFT neighbors of (:,:)

    % SR(:,:) entries for Robin nodes
    
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
    %
    %
    %
    %
    % j:
    lj = lj_r;
    hj = hj_r;	

   SB(l,h,1) = ((DELTAS(l,h,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(lj_r,hj_r,1))) .* ...
			Udc(lj,hj);

   SA(l,h,1) = ((DELTAS(l,h,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(lj_r,hj_r,1))) .* ...
			Udc(l,h);

    
   SD(l,h,1) = 2*( SIGMA(lj,hj) ./ ...
                 ( SIGMA(l,h) + SIGMA(lj,hj) ) ).^2;

                   
    % vertical (up) neighbor
    %
    %
    %
    %
    %
    %
    % j:
    lj = lj_l;
    hj = hj_l;

    SB(l,h,2) = ((DELTAS(l,h,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(lj,hj);

    SA(l,h,2) = ((DELTAS(l,h,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l,h);

    SD(l,h,2) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(l,h) + SIGMA(lj,hj) ) ).^2;

                   
    % horizontal (right) neighbor
    %
    %
    %
    %
    %
    %
    % j:
    lj = lj_d;
    hj = hj_d;

    SB(l,h,3) = ((DELTAS(l,h,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                       (2*DELTAS(lj_d,hj_d,2))) .* ...
			Udc(lj,hj);

    SA(l,h,3) = ((DELTAS(l,h,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                       (2*DELTAS(lj_d,hj_d,2))) .* ...
			Udc(l,h);

    SD(l,h,3) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(l,h) + SIGMA(lj,hj) ) ).^2;
                   
    % horizontal (left) neighbor
    %
    %
    %
    %
    %
    %
    % j:
    lj = lj_u;
    hj = hj_u;

    SB(l,h,4) = ((DELTAS(l,h,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(lj,hj);

    SA(l,h,4) = ((DELTAS(l,h,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h);

    SD(l,h,4) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(l,h) + SIGMA(lj,hj) ) ).^2;
					   
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

    SB(l,1,1) = ((DELTAS(l,1,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(lj_r,hj_r,1))) .* ...
			Udc(lj,hj);

    SA(l,1,1) = ((DELTAS(l,1,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(lj_r,hj_r,1))) .* ...
			Udc(l,1);

    SD(l,1,1) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(l,1) + SIGMA(lj,hj) ) ).^2;
                   
    % vertical (up) neighbor
    % j:
    lj = lj_l;
    hj = 1;

    SB(l,1,2) = ((DELTAS(l,1,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(l,1,1))) .* ...
			Udc(lj,hj);

    SA(l,1,2) = ((DELTAS(l,1,2) + DELTAS(lj_d,hj_d,2)) ./ ...
                       (2*DELTAS(l,1,1))) .* ...
			Udc(l,1);

    SD(l,1,2) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(l,1) + SIGMA(lj,hj) ) ).^2;
                   
    % horizontal (right) neighbor
    % j:
    lj = lj_d;
    hj = 2;

    SB(l,1,3) = ((DELTAS(l,1,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                       (2*DELTAS(lj_d,hj_d,2))) .* ...
			Udc(lj,hj);

    SA(l,1,3) = ((DELTAS(l,1,1) + DELTAS(lj_r,hj_r,1)) ./ ...
                       (2*DELTAS(lj_d,hj_d,2))) .* ...
			Udc(l,1);

    SD(l,1,3) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(l,1) + SIGMA(lj,hj) ) ).^2;


    %-------------%
    % NEU corners %
    %-------------%
	% corner 1
    
    % vertical (down) neighbor
    % j:
    lj = 2;
    hj = 1;

    SB(1,1,1) = ((DELTAS(1,1,2) + DELTAS(1,2,2)) ./ ...
                       (2*DELTAS(2,1,1))) .* ...
			Udc(lj,hj);

    SA(1,1,1) = ((DELTAS(1,1,2) + DELTAS(1,2,2)) ./ ...
                       (2*DELTAS(2,1,1))) .* ...
			Udc(1,1);

    SD(1,1,1) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(1,1) + SIGMA(lj,hj) ) ).^2;
                   
    % horizontal (right) neighbor
    % j:
    lj = 1;
    hj = 2;

    SB(1,1,3) = ((DELTAS(1,1,1) + DELTAS(2,1,1)) ./ ...
                       (2*DELTAS(1,2,2))) .* ...
			Udc(lj,hj);

    SA(1,1,3) = ((DELTAS(1,1,1) + DELTAS(2,1,1)) ./ ...
                       (2*DELTAS(1,2,2))) .* ...
			Udc(1,1);

    SD(1,1,3) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(1,1) + SIGMA(lj,hj) ) ).^2;
    
    %-------------%
    % NEU corners %
    %-------------%
	% corner 2
    
    % vertical (up) neighbor
    % j:
    lj = n-1;
    hj = 1;

    SB(n,1,2) = ((DELTAS(n,1,2) + DELTAS(n,2,2)) ./ ...
                       (2*DELTAS(n,1,1))) .* ...
			Udc(lj,hj);

    SA(n,1,2) = ((DELTAS(n,1,2) + DELTAS(n,2,2)) ./ ...
                       (2*DELTAS(n,1,1))) .* ...
			Udc(n,1);

    SD(n,1,2) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(n,1) + SIGMA(lj,hj) ) ).^2;

    
    % horizontal (right) neighbor
    % j:
    lj = n;
    hj = 2;

    SB(n,1,3) = ((DELTAS(n,1,1) + DELTAS(1,1,1)) ./ ...
                       (2*DELTAS(n,2,2))) .* ...
			Udc(lj,hj);

    SA(n,1,3) = ((DELTAS(n,1,1) + DELTAS(1,1,1)) ./ ...
                       (2*DELTAS(n,2,2))) .* ...
			Udc(n,1);

    SD(n,1,3) = 2*( SIGMA(lj,hj) ./ ...
                  ( SIGMA(n,1) + SIGMA(lj,hj) ) ).^2;

            
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
    %
    %
    %
    %
    %
    SB(l,h,1) = ((DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                       (2*DELTAS(l+1,h,1))) .* ...
			Udc(l+1,h);

    SA(l,h,1) = ((DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                       (2*DELTAS(l+1,h,1))) .* ...
			Udc(l,h);

    SD(l,h,1) = 2*( SIGMA(l+1,h) ./ ...
                  ( SIGMA(l,h) + SIGMA(l+1,h) ) ).^2;

                   
    % horizontal (right) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,3) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2*DELTAS(l,h+1,2))) .* ...
			Udc(l,h+1);

    SA(l,h,3) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2*DELTAS(l,h+1,2))) .* ...
			Udc(l,h);

    SD(l,h,3) = 2*( SIGMA(l,h+1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h+1) ) ).^2;
                   
    % horizontal (left) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,4) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h-1);

    SA(l,h,4) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h);

    SD(l,h,4) = 2*( SIGMA(l,h-1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h-1) ) ).^2;

                   
    % vertical (up) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = ( (DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                       (2) ) .* ...
                       ALPHAS(l,h) .* ...
			Udc(l,h); 
                    
    %---------
    % edge d
    %---------
    
    % i:
    l = 2:n-1;
    h = m;
    
    % vertical (up) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,1) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l+1,h,1))) .* ...
			Udc(l+1,h);

    SA(l,h,1) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l+1,h,1))) .* ...
			Udc(l,h);

    SD(l,h,1) = 2*( SIGMA(l+1,h) ./ ...
                  ( SIGMA(l,h) + SIGMA(l+1,h) ) ).^2;
                   
    % horizontal (right) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2)) .* ...
                       ALPHAS(l,h) .* ...
			Udc(l,h);
                   
    % horizontal (left) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,4) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h-1);

    SA(l,h,4) = ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h);

    SD(l,h,4) = 2*( SIGMA(l,h-1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h-1) ) ).^2;
                   
    % vertical (up) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,2) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l-1,h);

    SA(l,h,2) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l,h);

    SD(l,h,2) = 2*( SIGMA(l-1,h) ./ ...
                  ( SIGMA(l,h) + SIGMA(l-1,h) ) ).^2;
                   
    %---------
    % edge c
    %---------
    
    % i:
    l = n;
    h = 2:m-1;
    
    % vertical (down) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2)) .* ...
                       ALPHAS(l,h) .* ...
			Udc(l,h);
                   
    % horizontal (right) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,3) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h+1,2))) .* ...
			Udc(l,h+1);

    SA(l,h,3) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h+1,2))) .* ...
			Udc(l,h);

    SD(l,h,3) = 2*( SIGMA(l,h+1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h+1) ) ).^2;
                   
    % horizontal (left) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,4) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h-1);

    SA(l,h,4) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h);

    SD(l,h,4) = 2*( SIGMA(l,h-1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h-1) ) ).^2;
                   
    % vertical (up) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,2) = ((DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l-1,h);

    SA(l,h,2) = ((DELTAS(l,h,2) + DELTAS(l,h+1,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l,h);

    SD(l,h,2) = 2*( SIGMA(l-1,h) ./ ...
                  ( SIGMA(l,h) + SIGMA(l-1,h) ) ).^2;
    
    %------------               
    % corner 3
    %------------
    
    %i
    l = 1;
    h = m;
    
    % vertical (down) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,1) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l+1,h,1))) .* ...
			Udc(l+1,h);

    SA(l,h,1) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l+1,h,1))) .* ...
			Udc(l,h);

    SD(l,h,1) = 2*( SIGMA(l+1,h) ./ ...
                  ( SIGMA(l,h) + SIGMA(l+1,h) ) ).^2;
    
    % vertical (up) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = ( (DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2) ) .* ...
                       corners(1,1) .* ...
			Udc(l,h);
                   
    % horizontal (right) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = SR(l,h) + ((DELTAS(l,h,1) + DELTAS(l+1,h,1)) ./ ...
                        (2)) .* ...
                        corners(2,1) .* ...
			Udc(l,h);
                   
    % horizontal (left) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,4) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h-1);

    SA(l,h,4) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h);

    SD(l,h,4) = 2*( SIGMA(l,h-1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h-1) ) ).^2;
    
    
    %------------               
    % corner 4
    %------------
    
    %i
    l = n;
    h = m;
    
    % vertical (down) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2)) .* ...
                       corners(1,2) .* ...
			Udc(l,h);
                   
    % vertical (up) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,2) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l-1,h);

    SA(l,h,2) = ((DELTAS(l,h,2) + DELTAS(l,1,2)) ./ ...
                       (2*DELTAS(l,h,1))) .* ...
			Udc(l,h);

    SD(l,h,2) = 2*( SIGMA(l-1,h) ./ ...
                  ( SIGMA(l,h) + SIGMA(l-1,h) ) ).^2;
                   
    % horizontal (right) GHOST neighbor
    %
    %
    %
    %
    %
    %
    SR(l,h) = SR(l,h) + ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       	   (2)) .* ...
                           corners(2,2) .* ...
			   Udc(l,h); 
                   
    % horizontal (left) neighbor
    %
    %
    %
    %
    %
    %
    SB(l,h,4) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h-1);

    SA(l,h,4) = ((DELTAS(l,h,1) + DELTAS(1,h,1)) ./ ...
                       (2*DELTAS(l,h,2))) .* ...
			Udc(l,h);

    SD(l,h,4) = 2*( SIGMA(l,h-1) ./ ...
                  ( SIGMA(l,h) + SIGMA(l,h-1) ) ).^2;               

    %-------------------------------------------------------------------------%
                   
    % put them together
    %
    %
    SIJ = SA - SB;
    SIJ = SIJ .* SD;

    SII = SIJ(:,:,1) + SIJ(:,:,2) + SIJ(:,:,3) + SIJ(:,:,4);
    SII = - SII - SR;

    %----------------------------------------------------------------------
    %             build S
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
            V(k) = SIJ(l,h,1);
            k=k+1;
            % vertical (up) neighbors
            j = i - 1;
            J(k) = j;
            I(k) = i;
            V(k) = SIJ(l,h,2);
            k=k+1;
            % horizontal (right) neighbors
            j = i + n;
            J(k) = j;
            I(k) = i;
            V(k) = SIJ(l,h,3);
            k=k+1;
            % horizontal (left) neighbors
            j = i - n;
            J(k) = j;
            I(k) = i;
            V(k) = SIJ(l,h,4);
            k=k+1;
            % inner nodes
            J(k) = i;
            I(k) = i;
            V(k) = SII(l,h);
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
        V(k) = SIJ(l,h,1);
        k=k+1;
        % vertical (up) neighbors
        j = i - 1;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,2);
        k=k+1;
        % horizontal (right) neighbors
        j = i + n;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,3);
        k=k+1;
        % inner nodes
        J(k) = i;
        I(k) = i;
        V(k) = SII(l,h);
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
    V(k) = SIJ(1,1,1);
    k=k+1;
    % horizontal (right) neighbor
    j = i + n;
    J(k) = j;
    I(k) = i;
    V(k) = SIJ(1,1,3);
    k=k+1;
    % inner node
    J(k) = i;
    I(k) = i;
    V(k) = SII(1,1);
    k=k+1;
    
    %--------------------------------------
    % corner 2
    %--------------------------------------
    
    i = n;
    % vertical (up) neighbor
    j = i - 1;
    J(k) = j;
    I(k) = i;
    V(k) = SIJ(n,1,2);
    k=k+1;
    % horizontal (right) neighbor
    j = i + n;
    J(k) = j;
    I(k) = i;
    V(k) = SIJ(n,1,3);
    k=k+1;
    % inner node
    J(k) = i;
    I(k) = i;
    V(k) = SII(n,1);
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
        V(k) = SIJ(l,h,1);
        k=k+1;
        % horizontal (left) neighbors
        j = i - n;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,4);
        k=k+1;
        % horizontal (right) neighbors
        j = i + n;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,3);
        k=k+1;
        % inner nodes
        J(k) = i;
        I(k) = i;
        V(k) = SII(l,h);
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
        V(k) = SIJ(l,h,1);
        k=k+1;
        % vertical (up) neighbors
        j = i - 1;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,2);
        k=k+1;
        % horizontal (left) neighbors
        j = i - n;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,4);
        k=k+1;
        % inner nodes
        J(k) = i;
        I(k) = i;
        V(k) = SII(l,h);
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
        V(k) = SIJ(l,h,4);
        k=k+1;
        % vertical (up) neighbors
        j = i - 1;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,2);
        k=k+1;
        % horizontal (right) neighbors
        j = i + n;
        J(k) = j;
        I(k) = i;
        V(k) = SIJ(l,h,3);
        k=k+1;
        % inner nodes
        J(k) = i;
        I(k) = i;
        V(k) = SII(l,h);
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
    V(k) = SIJ(1,m,1);
    k=k+1;
    % horizontal (left) neighbor
    j = i - n;
    J(k) = j;
    I(k) = i;
    V(k) = SIJ(1,m,4);
    k=k+1;
    % inner node
    J(k) = i;
    I(k) = i;
    V(k) = SII(1,m);
    k=k+1;
    
    %--------------------------------------
    % corner 4
    %--------------------------------------
    
    i = n*m;
    % vertical (up) neighbor
    j = i - 1;
    J(k) = j;
    I(k) = i;
    V(k) = SIJ(n,m,2);
    k=k+1;
    % horizontal (left) neighbor
    j = i - n;
    J(k) = j;
    I(k) = i;
    V(k) = SIJ(n,m,4);
    k=k+1;
    % inner node
    J(k) = i;
    I(k) = i;
    V(k) = SII(n,m);
    
%-------------------------------------------------------------------------%
    
    Sdc = - sparse(I,J,V);
   
end
