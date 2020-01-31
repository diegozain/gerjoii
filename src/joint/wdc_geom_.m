function [parame_,finite_,geome_] = wdc_geom(parame_,dx)
% diego domenzain
% fall 2018 @ BSU
% ------------------------------------------------------------------------------
% wdc_geom.m finishes to build the necessary geometry parameters to be used by 
% both the GPR and ER solvers.
% Has to be run after param_wdc.m
% ------------------------------------------------------------------------------
geome_ = struct;
geome_.aa = parame_.aa;
geome_.bb = parame_.bb;  
geome_.cc = parame_.cc;
geome_.w.air = parame_.w.air;
geome_.w.nt = parame_.w.nt;
% ------------------------------------------------------------------------------
finite_ = struct;
finite_.w.pml_d = parame_.w.pml_d;
finite_.w.pml_w = parame_.w.pml_w;
finite_.dc.robin = parame_.dc.robin;
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
parame_.w.c = 1/sqrt(parame_.w.mu_0 * parame_.w.eps_0);
%--------------
% space spacings
%--------------
epsi_all = [parame_.natu.epsilon_z parame_.natu.eps_fig 1];
vel_min = parame_.w.c/sqrt(max(epsi_all)); % [m/s]
vel_max = parame_.w.c/sqrt(min(epsi_all)); % [m/s]
parame_.w.epsi_max_ = max(epsi_all); % [ ]
parame_.w.ampli = 1e+3;            % [V/m]
parame_.w.tau = 1/parame_.w.fo; % [s]
fmax = 2.2 * parame_.w.fo;      % [Hz]
l_min = vel_min / fmax;         % [m]
no_p_wa = 10;
geome_.dx = l_min/no_p_wa;
% ------------------------------------------------------------------------------
fprintf('\nwith these velocities dx should be %f \n',geome_.dx);
geome_.dx = dx;
geome_.dx = geome_.dx/1;	% for analytic comparison: /1 /2 /3 /4 /8 % [m]
geome_.dy = geome_.dx;
fprintf('\nhowever it will be changed to %f \n',geome_.dx);
%--------------
% time intervals
%--------------
courant_factor = 0.9;
geome_.w.dt = 1/(vel_max * sqrt((1/geome_.dx^2)+(1/geome_.dy^2)));  % [s]
geome_.w.dt = courant_factor * geome_.w.dt; % [s]
time_ = geome_.w.dt * (geome_.w.nt-1); % [s]
geome_.w.T = (0 : geome_.w.dt : time_).' * 1e+9; % [ns]
%--------------
% discretization parameters: n and m
%--------------
geome_.X = geome_.aa:geome_.dx:geome_.bb; % discretization on x axis
geome_.Y = geome_.aa:geome_.dy:geome_.cc; % discretization on y axis
geome_.n = length(geome_.X);
geome_.m = length(geome_.Y);
%--------------
% discretization parameters: nx and ny (with pml)
%--------------
finite_.w.ny = geome_.n + 2 * finite_.w.pml_d;
finite_.w.nx = geome_.m + 2 * finite_.w.pml_w + geome_.w.air;
parame_.w.ny = finite_.w.ny;
parame_.w.nx = finite_.w.nx;
%--------------
% discretization parameters: nx and nz (with robin)
%--------------
finite_.dc.nz = geome_.m + finite_.dc.robin;
finite_.dc.nx = geome_.n + 2 * finite_.dc.robin;
%--------------
% material properties construction
%--------------
sig_fig_pos = parame_.natu.sig_fig_pos;
parame_.natu.sig_fig_pos(:,2) = binning(geome_.X,sig_fig_pos(:,1));
parame_.natu.sig_fig_pos(:,1) = binning(geome_.Y,sig_fig_pos(:,2));
eps_fig_pos = parame_.natu.eps_fig_pos;
parame_.natu.eps_fig_pos(:,2) = binning(geome_.X,eps_fig_pos(:,1));
parame_.natu.eps_fig_pos(:,1) = binning(geome_.Y,eps_fig_pos(:,2));
% on (n,m) grid (no pml)
%
parame_ = w_epsilon(parame_,geome_);
parame_ = w_sigma(parame_,geome_);
parame_ = dc_sigma(parame_,geome_);
% on (nx,ny) grid (with pml)
%
parame_ = w_magmat(finite_,parame_);
%--------------
% pml relevant stuff
%--------------
finite_.w.pml_order = 2; 
finite_.w.R_0 = 1e-8;
finite_.w.pis = finite_.w.pml_w + 1;
finite_.w.pie = finite_.w.nx - finite_.w.pml_w + 1;
finite_.w.pjs = finite_.w.pml_d + 1;
finite_.w.pje = finite_.w.ny - finite_.w.pml_d + 1;
%--------------
% pml relevant stuff
%--------------
finite_.w.ants_i = finite_.w.pis + geome_.w.air:finite_.w.pie-1; % x axis
finite_.w.ants_j = finite_.w.pjs:finite_.w.pje-1;                % y axis
finite_.w.domain_i = finite_.w.ants_i;
finite_.w.domain_j = finite_.w.ants_j;
% --------------
% turn doubles into integers
% --------------
finite_.w.pml_d = uint32(finite_.w.pml_d);
finite_.w.pml_w = uint32(finite_.w.pml_w);
finite_.w.ny = uint32(finite_.w.ny);
finite_.w.nx = uint32(finite_.w.nx);
finite_.w.pis = uint32(finite_.w.pis);
finite_.w.pie = uint32(finite_.w.pie);
finite_.w.pjs = uint32(finite_.w.pjs);
finite_.w.pje = uint32(finite_.w.pje);
finite_.w.ants_i = uint32(finite_.w.ants_i);
finite_.w.ants_j = uint32(finite_.w.ants_j);
finite_.w.domain_i = uint32(finite_.w.domain_i);
finite_.w.domain_j = uint32(finite_.w.domain_j);
%finite_.dc.n_ky = uint32(finite_.dc.n_ky);
%finite_.dc.robin = uint32(finite_.dc.robin);
%finite_.dc.nx = uint32(finite_.dc.nz);
%finite_.dc.nz = uint32(finite_.dc.nz);
%geome_.n = uint32(geome_.n);
%geome_.m = uint32(geome_.m);
%geome_.w.nt = uint32(geome_.w.nt);
%----------------------
% print parameters to console
%----------------------
fprintf('\nabout to shoot\n some electrmagnetic waves... \n');
fprintf(' ...and inject\n some electricity... \n\n');

fprintf('x [m] = %2.1f \n',geome_.bb - geome_.aa);
fprintf('z [m] = %2.1f \n',geome_.cc - geome_.aa);
fprintf('t [ns] = %f \n\n',geome_.w.dt*geome_.w.nt/1e-9);

fprintf('fo [Hz] = %2.1e \n',parame_.w.fo);
fprintf('\n');

fprintf('dx [m] = %f \n',geome_.dx);
fprintf('dz [m] = %f \n',geome_.dy);
fprintf('dt [ns] = %f \n\n',geome_.w.dt/1e-9);

fprintf('n (no PML) = %i \n',geome_.n);
fprintf('m (no PML, no air) = %i \n',geome_.m);
fprintf('air = %i \n',geome_.w.air);
fprintf('nt = %i \n',geome_.w.nt);

fprintf('\n\nwave cube will be of size %1d [Gb]\n',...
          geome_.n*geome_.m*geome_.w.nt*8*1e-9);
end