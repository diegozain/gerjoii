function gerjoii_ = w_update_e__(geome_,parame_,finite_,gerjoii_)

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
Ee_ = zeros(ns,1);
depsilons = zeros(geome_.n*geome_.m,ns);
parfor is=1:ns
  [depsilon,Ee] = w_update_e(geome_,parame_,finite_,gerjoii_,is);
  depsilons(:,is) = depsilon;
  Ee_(is) = Ee;
end
depsilon = sum(depsilons,2)/ns;
gerjoii_.w.depsilon = reshape(depsilon,[geome_.m,geome_.n]);
gerjoii_.w.Ee_ = sum(Ee_)/ns;
end
