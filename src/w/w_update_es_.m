function gerjoii_ = w_update_es_(geome_,parame_,finite_,gerjoii_)

% parfor loop (sources)
%   choose source, data and receivers
%   fwd
%   obj
%   store obj
%   gradient
%   step size
%   compute update 
%   store update
% end parfor
% stack obj
% stack updates

% clean w
if isfield(gerjoii_.w,'sources_real')
  gerjoii_.w = rmfield(gerjoii_.w,'sources_real');
end
if isfield(gerjoii_.w,'receivers_real')
  gerjoii_.w = rmfield(gerjoii_.w,'receivers_real');
end
% ------------------------------------------------------------------------------
% get updates 
% ------------------------------------------------------------------------------
ns = gerjoii_.w.ns;
Ew_ = zeros(ns,1);
depsilons = zeros(geome_.n*geome_.m,ns);
dsigmas = zeros(geome_.n*geome_.m,ns);
parfor is=1:ns
  [depsilon,dsigma,Ew] = w_update_es(geome_,parame_,finite_,gerjoii_,is);
  depsilons(:,is) = depsilon;
  dsigmas(:,is) = dsigma;
  Ew_(is) = Ew;
end
depsilons = sum(depsilons,2)/ns;
dsigmas = sum(dsigmas,2)/ns;
gerjoii_.w.depsilon = reshape(depsilons,[geome_.m,geome_.n]);
gerjoii_.w.dsigma = reshape(dsigmas,[geome_.m,geome_.n]);
gerjoii_.w.Ew = sum(Ew_)/ns;
end
