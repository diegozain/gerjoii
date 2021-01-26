function migra = w_migra_(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain.
% colorado school of mines, 2020.
% ..............................................................................
% given one source indexed by 'is', 
% compute migration 
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
% ..............................................................................
% load source, receivers, measuring operator, observed data & std
% ..............................................................................
[parame_,gerjoii_] = w_load(parame_,gerjoii_,is);
% ..............................................................................
% fwd model
% ..............................................................................
[finite_,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_);
% ..............................................................................
% filter wavefields & assign the negative of obs data as residual
%                     this is so the grad sign cancels out.
% ..............................................................................
gerjoii_.w.e_2d = filt_gauss(-parame_.natu.w.d_2d,geome_.w.dt,...
                               gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
% ..............................................................................
% migration of data
% ..............................................................................
% ---- cross-correlation ----
[migra,~] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_,parame_);
% ..............................................................................
% manage amplitudes at source locations
% ..............................................................................
% ----------
% Gaussian
% ----------
% access source in full E field matrix (air+pml+1)
s = gerjoii_.w.s; 
% trim down to parameter matrix
s(2) = s(2)-parame_.w.pjs;                 % ix
s(1) = s(1)-parame_.w.pis-parame_.w.air+1; % iz
% lo is wavelength of wavefield at source location
lo = parame_.w.c/sqrt(parame_.w.epsilon( s(1),s(2) ))/gerjoii_.w.regu.fo;  % [m]
migra = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* migra;
% ..............................................................................
% filter conductivity migration 
% ..............................................................................
% ax = gerjoii_.w.regu.ax; 
% az = gerjoii_.w.regu.az;
% [migra,~,~] = image_gaussian(full(migra),ax,az,'LOW_PASS'); 
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
% ..............................................................................
% apply mask 
% ..............................................................................
if isfield(parame_,'shape')
  migra = migra .* parame_.shape;
end
% ..............................................................................
% with real data I get NaN's for some reason ¬_¬ 
% ..............................................................................
nani=sum(isnan( migra(:) ));
if nani > 0
  fprintf('    %i NaNs in migration for source #%i\n',nani,is)
  migra = zeros(size(migra));
end
fprintf('    done migration for source #%i\n',is)
% migra = normali(migra);
migra = migra(:);
end