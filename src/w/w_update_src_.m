function wvlets_ = w_update_src_(geome_,parame_,finite_,gerjoii_)
% invert for source wavelet for all shot-gathers.
% ------------------------------------------------------------------------------
% clean dc first
if isfield(gerjoii_,'dc')
  gerjoii_=rmfield(gerjoii_,'dc');
end
if isfield(parame_,'dc')
  parame_=rmfield(parame_,'dc');
end
if isfield(finite_,'dc')
  finite_=rmfield(finite_,'dc');
end
% ------------------------------------------------------------------------------
ns = gerjoii_.w.ns;
wvlets_ = zeros(size(parame_.w.wvlets_));
parfor is=1:ns
  wvlets_(:,is) = w_update_src(geome_,parame_,finite_,gerjoii_,is);
end
fprintf('\n')
end