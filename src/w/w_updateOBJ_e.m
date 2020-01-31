function [depsilon,step_w_e,Ee] = w_updateOBJ_e(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain.
% boise state university, 2019.
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
% ---- time derivative ----
% gerjoii_.w.u_2d = dt_u(gerjoii_.w.u_2d,geome_.w.dt);
% this is an inline version of w_dtu.m
nx_ = size(gerjoii_.w.u_2d,2);
n_slices = factor(nx_);
n_slices = n_slices(end);
n_slice = nx_/n_slices;
for i_=1:n_slices
  % compute derivative on u-slice
  % store dtu_.slice... but store it in u!!! fucking smart is what it is.
  gerjoii_.w.u_2d(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:) = ...
    dt_u(gerjoii_.w.u_2d(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:),geome_.w.dt);
end
% ------------------------------------------------------------------------------
% compute gradients & weigh them
% ------------------------------------------------------------------------------
gerjoii_.w.g_e = zeros(size(parame_.w.epsilon));
Ee = 0;
for iw_=1:numel(gerjoii_.w.obj_FNCs)
  % choose objective function 
  obj_fnc = gerjoii_.w.obj_FNCs(iw_);
  % get adjoint source
  [gerjoii_.w.e_2d,d_2d,d_2d_o] = ...
              w_bozdag(parame_.natu.w.d_2d,gerjoii_.w.d_2d,obj_fnc);
  % ............................................................................
  % filter wavefields
  % ............................................................................
  gerjoii_.w.e_2d = filt_gauss(gerjoii_.w.e_2d,geome_.w.dt,...
                                 gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
  % ............................................................................
  % obj
  % ............................................................................
  Nw = sparse_diag(parame_.natu.w.N);
  Ee_ = w_E(d_2d_o,d_2d,Nw,gerjoii_.w.obj_FNC) / ( d_2d_o(:).' * d_2d_o(:) );
  Ee = Ee + gerjoii_.w.g_e_weights(iw_)*Ee_;
  % ............................................................................
  % grad
  % ............................................................................
  % ---- cross-correlation ---- 
  [ge,amax] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_,parame_);
  % ............................................................................
  % manage amplitudes at source locations
  % ............................................................................
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
  ge = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* ge;
  % ............................................................................
  % filter permittivity gradient 
  % ............................................................................
  ax = gerjoii_.w.regu.ax; 
  az = gerjoii_.w.regu.az;
  [ge,~,~] = image_gaussian(full(ge),ax,az,'LOW_PASS');
  ge = normali(ge);
  % ............................................................................
  % sum with weights
  % ............................................................................
  gerjoii_.w.g_e = gerjoii_.w.g_e + gerjoii_.w.g_e_weights(iw_)*ge;
end
[gerjoii_.w.g_e,~,~] = image_gaussian(full(gerjoii_.w.g_e),ax,az,'LOW_PASS');
gerjoii_.w.g_e = normali(gerjoii_.w.g_e);
% ..............................................................................
% with real data I get NaN's for some reason ¬_¬ 
% ..............................................................................
nani=sum(isnan( gerjoii_.w.g_e(:) ));
if nani > 0
  gerjoii_.w.g_e = zeros(size(gerjoii_.w.g_e));
  fprintf('    %i NaNs in w-permittivity gradient for source #%i\n',nani,is)
end
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
% ..............................................................................
% joint push 
% ..............................................................................
if isfield(gerjoii_,'wdc')
  if strcmp(gerjoii_.wdc.eps_too,'YES')
    % ..........................................................................
    % push, low-pass space-frequency, and normalize
    % ..........................................................................
    gerjoii_.w.g_e = gerjoii_.w.g_e - gerjoii_.wdc.depsi;
    gerjoii_.w.g_e = image_gaussian(full(gerjoii_.w.g_e),ax,az,'LOW_PASS');
    gerjoii_.w.g_e = normali(gerjoii_.w.g_e);
  end
end
% ..............................................................................
% apply mask 
% ..............................................................................
if isfield(parame_,'shape')
  gerjoii_.w.g_e = gerjoii_.w.g_e .* parame_.shape;
end
% ..............................................................................
% save gradient
% ..............................................................................
if strcmp(gerjoii_.w.save_ges,'YES')
  ges = gerjoii_.w.g_e;
  name = strcat(gerjoii_.w.data_pathges_,'ges',num2str( is ),'.mat');
  save( name , 'ges' );
  clear ges;
end
% ..............................................................................
% step sizes
% ..............................................................................
if isfield(gerjoii_.w,'pica_me')
  step_w_e = w_pica_e_(geome_,parame_,finite_,gerjoii_);
else
  step_w_e = w_stepparabola_e(geome_,parame_,finite_,gerjoii_,Ee);
end
% ..............................................................................
% update
% ..............................................................................
depsilon = double(-step_w_e*gerjoii_.w.g_e(:));
% % ............................................................................
% % invert for source
% % ............................................................................
% parame_.natu.w.wvlets_(:,is) = new wvlet source
end