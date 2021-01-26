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
% ------------------------------------------------------------------------------
%
%                                   finite_
%
% ------------------------------------------------------------------------------
if exist('finite_')==0
  finite_ = struct;
end
finite_.dc.robin = parame_.dc.robin;
finite_.dc.n_ky  = parame_.dc.n_ky;
% ------------------------------------------------------------------------------
%
%                                     er
%
% ------------------------------------------------------------------------------
finite_.dx = parame_.dx;
finite_.dz = parame_.dz;
%--------------
% discretization parameters: nx and nz (with robin)
%--------------
finite_.dc.nz = geome_.m + finite_.dc.robin;
finite_.dc.nx = geome_.n + 2 * finite_.dc.robin;
% ------------------------------------------------------------------------------
%
%                            print parameters to console
%
% ------------------------------------------------------------------------------
fprintf('\nabout to inject\n some electricity... \n\n');

fprintf('x [m] = %2.1f \n',geome_.bb - geome_.aa);
fprintf('z [m] = %2.1f \n\n',geome_.cc - geome_.aa);

fprintf('dx [m] = %f \n',geome_.dx);
fprintf('dz [m] = %f \n\n',geome_.dy);

fprintf('n (no PML) = %i \n',geome_.n);
fprintf('m (no PML, no air) = %i \n',geome_.m);