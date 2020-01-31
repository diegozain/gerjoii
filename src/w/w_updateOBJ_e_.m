function gerjoii_ = w_updateOBJ_e_(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% boise state university, 2019.
% ..............................................................................
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
% ..............................................................................
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
steps_w_e = zeros( 1 , ns );
parfor is=1:ns
  [depsilon,step_w_e,Ee] = w_updateOBJ_e(geome_,parame_,finite_,gerjoii_,is);
  depsilons(:,is) = depsilon;
  steps_w_e(is) = step_w_e;
  Ee_(is) = Ee;
end
depsilons = sum(depsilons,2)/ns;
gerjoii_.w.depsilon = reshape(depsilons,[geome_.m,geome_.n]);
steps_w_e = sum(steps_w_e);
if steps_w_e < 0; gerjoii_.w.depsilon = zeros(geome_.m,geome_.n);end
gerjoii_.w.Ee_ = sum(Ee_)/ns;
fprintf('  norm of depsilon = %2.2d\n',norm(depsilons)*geome_.dx*geome_.dy)
% give it some momentum
gerjoii_.w.depsilon = gerjoii_.w.depsilon;% + gerjoii_.w.depsilon_*0.25;
gerjoii_.w.depsilon_ = gerjoii_.w.depsilon;
end