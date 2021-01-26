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
%
%                                   parame_
%
% ------------------------------------------------------------------------------
% number of air pixels
parame_.w.air = 60;
% pml padding
parame_.w.pml_w = 60;
parame_.w.pml_d = 60;
% ------------------------------------------------------------------------------
%
%                                   geome_
%
% ------------------------------------------------------------------------------
if exist('geome_')==0
  geome_ = struct;
end
geome_.aa   = parame_.aa;
geome_.bb   = parame_.bb;
geome_.cc   = parame_.cc;
geome_.dx   = parame_.dx;
geome_.dy   = parame_.dz;
geome_.X    = parame_.x;
geome_.Y    = parame_.z;
geome_.n = length(geome_.X);
geome_.m = length(geome_.Y);
geome_.w.dt  = parame_.w.dt;
geome_.w.T   = parame_.w.t*1e+9; % [ns]
geome_.w.air = parame_.w.air;
geome_.w.nt  = parame_.w.nt;
% ------------------------------------------------------------------------------
%
%                                   finite_
%
% ------------------------------------------------------------------------------
if exist('finite_')==0
  finite_ = struct;
end
finite_.w.pml_d  = parame_.w.pml_d;
finite_.w.pml_w  = parame_.w.pml_w;
finite_.dx = parame_.dx;
finite_.dz = parame_.dz;
% ------------------------------------------------------------------------------
%
%                                     gpr
%
% ------------------------------------------------------------------------------
finite_.dx = parame_.dx;
finite_.dz = parame_.dz;
%--------------
% discretization parameters: nx and ny (with pml)
%--------------
finite_.w.ny = geome_.n + 2 * finite_.w.pml_d;
finite_.w.nx = geome_.m + 2 * finite_.w.pml_w + geome_.w.air;
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
% ------------------------------------------------------------------------------
%
%                                 parame_ again
%
% ------------------------------------------------------------------------------
parame_.w.ny  = finite_.w.ny;
parame_.w.nx  = finite_.w.nx;
parame_.w.pis = finite_.w.pis;
parame_.w.pie = finite_.w.pie;
parame_.w.pjs = finite_.w.pjs;
parame_.w.pje = finite_.w.pje;
%--------------
% material properties construction
%--------------
parame_ = w_magmat(finite_,parame_);
% ------------------------------------------------------------------------------
%
%                            print parameters to console
%
% ------------------------------------------------------------------------------
fprintf('\nabout to shoot\n some electrmagnetic waves... \n\n');

fprintf('x [m]  = %2.1f \n',geome_.bb - geome_.aa);
fprintf('z [m]  = %2.1f \n',geome_.cc - geome_.aa);
fprintf('t [ns] = %f \n\n',geome_.w.dt*geome_.w.nt/1e-9);

fprintf('fo [Hz] = %2.1e \n',parame_.w.fo);
fprintf('\n');

fprintf('dx [m]  = %f \n',geome_.dx);
fprintf('dz [m]  = %f \n',geome_.dy);
fprintf('dt [ns] = %f \n\n',geome_.w.dt/1e-9);

fprintf('n (no PML)         = %i \n',geome_.n);
fprintf('m (no PML, no air) = %i \n',geome_.m);
fprintf('air = %i \n',geome_.w.air);
fprintf('nt  = %i \n',geome_.w.nt);

fprintf('\n\nwave cube will be of size %1d [Gb]\n',...
          geome_.n*geome_.m*geome_.w.nt*8*1e-9);