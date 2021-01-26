function gerjoii_ = w_update_e_disk_(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% colorado school of mines, summer 2020.
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
steps_w_e = zeros( 1 , ns );
parfor is=1:ns
  [step_w_e,Ee] = w_update_e_disk(geome_,parame_,finite_,gerjoii_,is);
  steps_w_e(is) = step_w_e;
  Ee_(is) = Ee;
end
gerjoii_.w.depsilon = w_stack_disk(gerjoii_.domain_path,'depsi_domain.mat',geome_.n,geome_.m,ns);
steps_w_e = sum(steps_w_e);
if steps_w_e < 0; 
  gerjoii_.w.depsilon = zeros(geome_.m,geome_.n);
end
gerjoii_.w.Ee_ = sum(Ee_)/ns;
fprintf('  norm of depsilon = %2.2d\n',norm(gerjoii_.w.depsilon)*geome_.dx*geome_.dy)
% % give it some momentum
% gerjoii_.w.depsilon = gerjoii_.w.depsilon + 0.25*gerjoii_.w.depsilon_;
% gerjoii_.w.depsilon_= gerjoii_.w.depsilon;
end