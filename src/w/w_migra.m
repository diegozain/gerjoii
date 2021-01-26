function gerjoii_ = w_migra(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% colorado school of mines, 2020.
% ------------------------------------------------------------------------------
% parfor loop (sources)
%   choose source, data and receivers
%   fwd
%   migration 
%   store migration
% end parfor
% stack migration
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
migras = zeros(geome_.n*geome_.m,ns);
parfor is=1:ns
  migra = w_migra_(geome_,parame_,finite_,gerjoii_,is);
  migras(:,is) = migra;
end
migra = sum(migras,2)/ns;
% % --
gerjoii_.w.migra = reshape(migra,[geome_.m,geome_.n]);
end
