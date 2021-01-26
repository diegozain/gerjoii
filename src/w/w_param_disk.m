function [geome_,finite_,parame_] = w_param_disk(geome_,finite_,parame_,gerjoii_,is)
% diego domenzain
% @ Colorado School of Mines. summer 2020. 
% ..............................................................................
% parame_.aa= gerjoii_.domain(is).aa;
% parame_.bb= gerjoii_.domain(is).bb;
% parame_.cc= gerjoii_.domain(is).cc;

parame_.x = gerjoii_.domain(is).x;
parame_.z = gerjoii_.domain(is).z;
% ..............................................................................

ix = gerjoii_.domain(is).ix;
ix_= gerjoii_.domain(is).ix_;

% parameters
parame_.w.epsilon= parame_.w.epsilon(:,ix:ix_);
parame_.w.sigma  = parame_.w.sigma(:,ix:ix_);

if isfield(gerjoii_,'wdc')
  % xgrad sigm
  if isfield(gerjoii_.wdc,'dsigmx')
    parame_.dsigmx = gerjoii_.wdc.dsigmx(:,ix:ix_);
  end
  % xgrad epsi
  if isfield(gerjoii_.wdc,'depsi')
    parame_.depsi = gerjoii_.wdc.depsi(:,ix:ix_);
  end
end
% ..............................................................................
% geome_.aa   = parame_.aa;
% geome_.bb   = parame_.bb;
% geome_.cc   = parame_.cc;

geome_.X    = parame_.x;
geome_.Y    = parame_.z;

geome_.n = length(geome_.X);
geome_.m = length(geome_.Y);
finite_.w.ny = geome_.n + 2 * finite_.w.pml_d;
finite_.w.nx = geome_.m + 2 * finite_.w.pml_w + geome_.w.air;

finite_.w.pis = finite_.w.pml_w + 1;
finite_.w.pie = finite_.w.nx - finite_.w.pml_w + 1;
finite_.w.pjs = finite_.w.pml_d + 1;
finite_.w.pje = finite_.w.ny - finite_.w.pml_d + 1;

finite_.w.ants_i = finite_.w.pis + geome_.w.air:finite_.w.pie-1; % x axis
finite_.w.ants_j = finite_.w.pjs:finite_.w.pje-1;                % y axis
finite_.w.domain_i = finite_.w.ants_i;
finite_.w.domain_j = finite_.w.ants_j;

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

parame_.w.ny  = finite_.w.ny;
parame_.w.nx  = finite_.w.nx;
parame_.w.pis = finite_.w.pis;
parame_.w.pie = finite_.w.pie;
parame_.w.pjs = finite_.w.pjs;
parame_.w.pje = finite_.w.pje;

parame_ = w_magmat(finite_,parame_);
end