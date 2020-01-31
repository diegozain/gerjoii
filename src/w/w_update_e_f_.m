function gerjoii_ = w_update_e_f_(geome_,parame_,finite_,gerjoii_)

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

ns = gerjoii_.w.ns;
Ees = zeros(ns,1);
Ees_ = zeros(ns,1);
depsilons  = zeros(geome_.n*geome_.m,ns);
% depsilons_ = zeros(geome_.n*geome_.m,ns);
parfor is=1:ns
  % [depsilon,depsilon_,Ee,Ee_] = w_update_e_f(geome_,parame_,finite_,gerjoii_,is);
  % depsilons(:,is)  = depsilon;
  % depsilons_(:,is) = depsilon_;
  % Ees(is) = Ee;
  % Ees_(is) = Ee_;
  [depsilon,Ee] = w_update_e_f(geome_,parame_,finite_,gerjoii_,is);
  depsilons(:,is)  = depsilon;
  Ees(is) = Ee;
end
% depsilons  = sum(depsilons,2)/ns;
% depsilons_ = sum(depsilons_,2)/ns;
% gerjoii_.w.depsilon_self   = reshape(depsilons,[geome_.m,geome_.n]);
% gerjoii_.w.depsilon_friend = reshape(depsilons_,[geome_.m,geome_.n]);
% gerjoii_.w.Ee = sum(Ees)/ns;
% gerjoii_.w.Ee_ = sum(Ees_)/ns;
depsilons  = sum(depsilons,2)/ns;
gerjoii_.w.depsilon = reshape(depsilons,[geome_.m,geome_.n]);
gerjoii_.w.Ee = sum(Ees)/ns;
end