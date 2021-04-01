function [parame_,finite_,geome_] = eldc_geom(parame_)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% wdc_geom.m finishes to build the necessary geometry parameters to be used by 
% both the elastic and DC solvers.
% Has to be run after param_eldc.m
% ------------------------------------------------------------------------------
geome_ = struct;
geome_.aa = parame_.aa;
geome_.bb = parame_.bb;  
geome_.cc = parame_.cc;
geome_.el.nt = parame_.el.nt;
% ------------------------------------------------------------------------------
finite_ = struct;
% elastic
finite_.el.n_points_pml =parame_.el.n_points_pml;
finite_.el.n_power_pml  =parame_.el.n_power_pml ;
finite_.el.k_max_pml    =parame_.el.k_max_pml ;
finite_.el.alpha_max_pml=parame_.el.alpha_max_pml;
finite_.el.Rcoef        =parame_.el.Rcoef;
finite_.el.n_ghost      =parame_.el.n_ghost;
% DC
finite_.dc.robin= parame_.dc.robin;
finite_.dc.n_ky = parame_.dc.n_ky;
% ------------------------------------------------------------------------------
% domain diagram:
%
%           x
%   aa .--------------. bb
%      |              |
%      |              |
%      |              |  z
%      |              |
%      |              |
%      |              |
%   cc .--------------.
%
% ------------------------------------------------------------------------------
%----------------
% space spacings
%----------------
vel_min = parame_.el.vel_min; % [m/s]
vel_max = parame_.el.vel_max; % [m/s]
parame_.el.ampli = 1e+3;
parame_.el.tau = 1/parame_.el.fo; % [s]
fmax = 2.2 * parame_.el.fo;      % [Hz]
l_min = vel_min / fmax;         % [m]
no_p_wa = 10;
geome_.dx = l_min/no_p_wa;
geome_.dx = min([0.05; geome_.dx]);
geome_.dy = geome_.dx;
%----------------
% time intervals
%----------------
courant_factor = 0.3;
geome_.el.dt = 1/(vel_max * sqrt((1/geome_.dx^2)+(1/geome_.dy^2)));  % [s]
geome_.el.dt = courant_factor * geome_.el.dt; % [s]
time_ = geome_.el.dt * (geome_.el.nt-1); % [s]
geome_.el.T = (0 : geome_.el.dt : time_).'; % [s]
%----------------
% discretization parameters: n and m
%----------------
geome_.X = geome_.aa:geome_.dx:geome_.bb; % discretization on x axis
geome_.Y = geome_.aa:geome_.dy:geome_.cc; % discretization on y axis
geome_.n = length(geome_.X);
geome_.m = length(geome_.Y);

finite_.x = geome_.X;
finite_.z = geome_.Y;
finite_.dx = geome_.dx;
finite_.dz = geome_.dy;
%----------------
% discretization parameters: nx and nz (with robin)
%----------------
finite_.dc.nz = geome_.m + finite_.dc.robin;
finite_.dc.nx = geome_.n + 2 * finite_.dc.robin;
%----------------------
% print parameters to console
%----------------------
fprintf('\nabout to shoot\n some elastic waves... \n');
fprintf(' ...and inject\n some electricity... \n\n');

fprintf('x [m] = %2.1f \n',geome_.bb - geome_.aa);
fprintf('z [m] = %2.1f \n',geome_.cc - geome_.aa);
fprintf('t [s] = %f \n\n',geome_.el.dt*geome_.el.nt);

fprintf('fo [Hz] = %2.1e \n',parame_.el.fo);
fprintf('\n');

fprintf('dx [m] = %f \n',geome_.dx);
fprintf('dz [m] = %f \n',geome_.dy);
fprintf('dt [s] = %f \n\n',geome_.el.dt);

fprintf('nx (no PML) = %i \n',geome_.n);
fprintf('nz (no PML) = %i \n',geome_.m);
fprintf('nt = %i \n',geome_.el.nt);

fprintf('\n\nwave cube will be of size (single precision)          %1d [Gb]',...
          geome_.n*geome_.m*geome_.el.nt*4*1e-9);
%
fprintf('\nelectric potential will be of size (double precision) %1d [Gb]\n\n',...
          geome_.n*geome_.m*8*1e-9);
end
