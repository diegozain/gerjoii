function [dsigma,step_w_s,Es] = w_updateAWI_s(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain.
% Colorado School of Mines, 2020.
% ..............................................................................
% given one source indexed by 'is', 
% compute gradient with various objective functions
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
% ------------------------------------------------------------------------------
% compute gradient
% ------------------------------------------------------------------------------
% adjoint source and obj fnc term
% (adjoint source comes out already filtered)
[gerjoii_.w.e_2d,Es] = w_awi_(gerjoii_.w.Tawi,gerjoii_.w.d_2d,parame_.natu.w.d_2d,parame_.w.dt,gerjoii_.w.regu.f__);
% ..............................................................................
% gradient of data with respect to conductivity
% ..............................................................................
% ---- cross-correlation ---- 
[gerjoii_.w.g_s,amax] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_,parame_);
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
gerjoii_.w.g_s = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* gerjoii_.w.g_s;
% ..............................................................................
% filter conductivity gradient 
% ..............................................................................
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
[gerjoii_.w.g_s,~,~] = image_gaussian(full(gerjoii_.w.g_s),ax,az,'LOW_PASS');
gerjoii_.w.g_s = normali(gerjoii_.w.g_s);
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
% ..............................................................................
% xgrad push 
% ..............................................................................
if isfield(gerjoii_,'wdc')
  if strcmp(gerjoii_.wdc.sig_too,'YES')
    % ..........................................................................
    % push, low-pass space-frequency, and normalize
    % ..........................................................................
    gerjoii_.w.g_s = gerjoii_.w.g_s - gerjoii_.wdc.dsigmx;
    gerjoii_.w.g_s = image_gaussian(full(gerjoii_.w.g_s),ax,az,'LOW_PASS');
    gerjoii_.w.g_s = normali(gerjoii_.w.g_s);
  end
end
% ..............................................................................
% apply mask 
% ..............................................................................
if isfield(parame_,'shape')
  gerjoii_.w.g_s = gerjoii_.w.g_s .* parame_.shape;
end
% ..............................................................................
% with real data I get NaN's for some reason ¬_¬ 
% ..............................................................................
nani=sum(isnan( gerjoii_.w.g_s(:) ));
if nani > 0
  fprintf('    %i NaNs in w-conductivity gradient for source #%i\n',nani,is)
  gerjoii_.w.g_s = zeros(size(gerjoii_.w.g_s));
  % step_w_s = 0;
  % dsigma = double(-step_w_s*gerjoii_.w.g_s(:));
  % return
end
% ..............................................................................
% step sizes
% ..............................................................................
% step_w_s = w_pica_s_(geome_,parame_,finite_,gerjoii_);
step_w_s = w_boundstep2(parame_.w.sigma,gerjoii_.w.g_s,...
                  gerjoii_.w.regu.sig_max_ , -gerjoii_.w.regu.sig_min_,...
                  gerjoii_.w.k_s)*gerjoii_.w.ksprct_;
fprintf('    step sig %2.2d\n', step_w_s );
% step_w_s = w_stepparabola_s(geome_,parame_,finite_,gerjoii_,Es);
% ..............................................................................
% update
% ..............................................................................
dsigma = double(-step_w_s*gerjoii_.w.g_s(:));
% % ............................................................................
% % invert for source
% % ............................................................................
% parame_.natu.w.wvlets_(:,is) = new wvlet source
end