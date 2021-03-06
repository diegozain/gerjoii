function [step_w_e,Ee] = w_update_e_disk(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain.
% colorado school of mines, summer 2020.
% ..............................................................................
% given one source indexed by 'is', 
% compute depsilon and objective function value Ee
% ..............................................................................
%
% full process:
% 1. fwd
%   . coeff, inner & pml
%   . fields, (Ez,Hx,Hy)
%   . save u, d, e.
% 2. obj
%   . E
% 4. dtu
%   . u from 1
%   . save dtu as u
% 5. grad epsilon
%   . coeff from 1
%   . u from 4
%   . e from 1
%   . fields, (Ez,Hx,Hy)
%   . save g_e
% 6. filter g_e
%   . filter g_e from 5
% 8. step epsilon
%   . g_e from 6
%   . d & e from 1
%   . coeff, inner & pml
%   . fields, (Ez,Hx,Hy)
%   . save step_e
% 10. updates
%   . g_e from 6 & step_e from 8
%   . output depsilon
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
[geome_,finite_,parame_] = w_param_disk(geome_,finite_,parame_,gerjoii_,is);
[parame_,gerjoii_] = w_load_disk(parame_,gerjoii_,is);
% --------
%   update
% --------
% ..............................................................................
% fwd model
% ..............................................................................
[finite_,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_);
% ..............................................................................
% filter wavefields
% ..............................................................................
if strcmp(gerjoii_.w.regu.f_yesno,'YES')
  parame_.natu.w.d_2d = filt_gauss(parame_.natu.w.d_2d,geome_.w.dt,...
                                 gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8);%[Hz]
  gerjoii_.w.d_2d = filt_gauss(gerjoii_.w.d_2d,geome_.w.dt,...
                                 gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8);%[Hz]
  gerjoii_.w.u_2d = filt_gauss3d_(gerjoii_.w.u_2d,geome_.w.dt,...
                                 gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8);%[Hz]
end
gerjoii_.w.e_2d = filt_gauss(gerjoii_.w.e_2d,geome_.w.dt,...
                               gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
% ..............................................................................
% obj
% ..............................................................................
Nw = sparse_diag(parame_.natu.w.N);
Ee = w_E(parame_.natu.w.d_2d,gerjoii_.w.d_2d,Nw,gerjoii_.w.obj_FNC);
Ee = Ee / ( parame_.natu.w.d_2d(:).' * parame_.natu.w.d_2d(:) );
% ..............................................................................
% gradient of data with respect to permittivity
% ..............................................................................
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
  %
  % % -- this method is ok.
  % gerjoii_.w.u_2d(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:) = ...
  %   dt_u(gerjoii_.w.u_2d(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:),geome_.w.dt);
  % -- this method is way faster.
  gerjoii_.w.u_2d(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:) = differentiate_cube(gerjoii_.w.u_2d(:, ((i_-1)*n_slice+1):(i_*n_slice) ,:),geome_.w.dt);
end
% ---- cross-correlation ---- 
[gerjoii_.w.g_e,amax] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_,parame_);
% ..............................................................................
% manage amplitudes at source locations
% ..............................................................................
% % ----------
% % Kurzmann
% % ----------
% c_stab=1e-1;
% gerjoii_.w.g_e = w_kurzmann(gerjoii_.w.u_2d,amax,c_stab) .* gerjoii_.w.g_e;
% clear amax c_stab;
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
gerjoii_.w.g_e = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* gerjoii_.w.g_e;
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
% ..............................................................................
% filter permittivity gradient 
% ..............................................................................
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
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
% joint push 
% ..............................................................................
if isfield(gerjoii_,'wdc')
  if strcmp(gerjoii_.wdc.eps_too,'YES')
    % ..........................................................................
    % push, low-pass space-frequency, and normalize
    % ..........................................................................
    gerjoii_.w.g_e = gerjoii_.w.g_e - parame_.depsi;
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
depsilon = double(-step_w_e*gerjoii_.w.g_e);
% save
domain_mini = struct;
domain_mini.ix = gerjoii_.domain(is).ix;
domain_mini.domain__ = depsilon;
save(strcat(gerjoii_.domain_path,num2str(is),'/','depsi_domain.mat'),'domain_mini');
% % ............................................................................
% % invert for source
% % ............................................................................
% parame_.natu.w.wvlets_(:,is) = new wvlet source
end
