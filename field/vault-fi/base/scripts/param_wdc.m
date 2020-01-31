% diego domenzain
% summer 2019 @ BSU
% ------------------------------------------------------------------------------
% builds relevant parameters to be used in the GPR and ER forward models.
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
% domain limits
% ------------------------------------------------------------------------------
parame_.aa = parame_.x(1);
parame_.bb = parame_.x(end);
parame_.cc = parame_.z(end);
% ------------------------------------------------------------------------------
% number of air pixels
parame_.w.air = 60;
% ------------------------------------------------------------------------------
% pml padding
% ------------------------------------------------------------------------------
parame_.w.pml_w = 60;
parame_.w.pml_d = 60;
% ------------------------------------------------------------------------------
%
%                                   geome_
%
% ------------------------------------------------------------------------------
geome_ = struct;
geome_.aa   = parame_.aa;
geome_.bb   = parame_.bb;
geome_.cc   = parame_.cc;
geome_.dx   = parame_.dx;
geome_.dy   = parame_.dz;
geome_.w.dt = parame_.w.dt;
geome_.w.T  = parame_.w.t;
geome_.X    = parame_.x;
geome_.Y    = parame_.z;
geome_.n = length(geome_.X);
geome_.m = length(geome_.Y);
geome_.w.air = parame_.w.air;
geome_.w.nt = parame_.w.nt;
% ------------------------------------------------------------------------------
%
%                                   finite_
%
% ------------------------------------------------------------------------------
finite_ = struct;
finite_.w.pml_d  = parame_.w.pml_d;
finite_.w.pml_w  = parame_.w.pml_w;
finite_.dc.robin = parame_.dc.robin;
finite_.dc.n_ky  = parame_.dc.n_ky;
finite_.dx = parame_.dx;
finite_.dz = parame_.dz;
% ------------------------------------------------------------------------------
%
%                                     gpr
%
% ------------------------------------------------------------------------------
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
finite_.w.pml_d    = uint32(finite_.w.pml_d);
finite_.w.pml_w    = uint32(finite_.w.pml_w);
finite_.w.ny       = uint32(finite_.w.ny);
finite_.w.nx       = uint32(finite_.w.nx);
finite_.w.pis      = uint32(finite_.w.pis);
finite_.w.pie      = uint32(finite_.w.pie);
finite_.w.pjs      = uint32(finite_.w.pjs);
finite_.w.pje      = uint32(finite_.w.pje);
finite_.w.ants_i   = uint32(finite_.w.ants_i);
finite_.w.ants_j   = uint32(finite_.w.ants_j);
finite_.w.domain_i = uint32(finite_.w.domain_i);
finite_.w.domain_j = uint32(finite_.w.domain_j);
%finite_.dc.n_ky   = uint32(finite_.dc.n_ky);
%finite_.dc.robin  = uint32(finite_.dc.robin);
%finite_.dc.nx     = uint32(finite_.dc.nz);
%finite_.dc.nz     = uint32(finite_.dc.nz);
%geome_.n          = uint32(geome_.n);
%geome_.m          = uint32(geome_.m);
%geome_.w.nt       = uint32(geome_.w.nt);
% ------------------------------------------------------------------------------
%
%                                     dc
%
% ------------------------------------------------------------------------------


% ------------------------------------------------------------------------------
%
%                            print parameters to console
%
% ------------------------------------------------------------------------------
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