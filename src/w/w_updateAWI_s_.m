function gerjoii_ = w_updateAWI_s_(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% colorado school of mines, 2020.
% ------------------------------------------------------------------------------
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
% ------------------------------------------------------------------------------
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
Es_ = zeros(ns,1);
dsigmas = zeros(geome_.n*geome_.m,ns);
steps_w_s = zeros( 1 , ns );
parfor is=1:ns
  [dsigma,step_w_s,Es] = w_updateAWI_s(geome_,parame_,finite_,gerjoii_,is);
  dsigmas(:,is) = dsigma;
  steps_w_s(is) = step_w_s;
  Es_(is) = Es;
end
dsigma = sum(dsigmas,2)/ns;
% % --
% % !!!!   weird step size sum thing
% step_ = sum( steps_w_s )/ns;
% % fprintf('        step size for whole ws update is %2.2d\n',step_);
% dsigma = dsigma/max(abs(dsigma(:)));
% dsigma = step_*dsigma;
% % --
gerjoii_.w.dsigma = reshape(dsigma,[geome_.m,geome_.n]);
gerjoii_.w.Es_ = sum(Es_)/ns;
fprintf('  norm of dsigma = %2.2d\n',norm(dsigma)*geome_.dx*geome_.dy)
% % give it some momentum
% gerjoii_.w.dsigma = gerjoii_.w.dsigma + 0.25*gerjoii_.w.dsigma_;
% gerjoii_.w.dsigma_ = gerjoii_.w.dsigma;
end
