function gerjoii_ = w_updateOBJ_s_disk_(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% colorado school of mines, summer 2020.
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
steps_w_s = zeros( 1 , ns );
parfor is=1:ns
  [step_w_s,Es] = w_updateOBJ_s_disk(geome_,parame_,finite_,gerjoii_,is);
  steps_w_s(is) = step_w_s;
  Es_(is) = Es;
end
dsigma = w_stack_disk(gerjoii_.domain_path,'dsigm_domain.mat',geome_.n,geome_.m,ns);
% % --
% % !!!!   weird step size sum thing
% step_ = sum( steps_w_s )/ns;
% % fprintf('        step size for whole ws update is %2.2d\n',step_);
% dsigma = dsigma/max(abs(dsigma(:)));
% dsigma = step_*dsigma;
% % --
gerjoii_.w.Es_ = sum(Es_)/ns;
fprintf('  norm of dsigma = %2.2d\n',norm(dsigma)*geome_.dx*geome_.dy)
gerjoii_.w.dsigma = dsigma;
% % give it some momentum
% gerjoii_.w.dsigma = gerjoii_.w.dsigma + 0.25*gerjoii_.w.dsigma_;
% gerjoii_.w.dsigma_ = gerjoii_.w.dsigma;
end
