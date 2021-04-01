function [depsilon,Ee] = w_update_e_f(geome_,parame_,finite_,gerjoii_,is)
% function [depsilon,depsilon_,Ee,Ee_] = w_update_e_f(geome_,parame_,finite_,gerjoii_,is)
% ..............................................................................
% given one source indexed by is, 
% compute depsilon and objective function value Ee
% ..............................................................................
% ------------------------------------------------------------------------------
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
[parame_,gerjoii_] = w_load(parame_,gerjoii_,is);
% --------
%   update
% --------
% ..............................................................................
% fwd model
% ..............................................................................
[finite_,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_);
% ..............................................................................
% filter error
% ..............................................................................
gerjoii_.w.e_2d = filt_gauss(gerjoii_.w.e_2d,geome_.w.dt,...
                      - gerjoii_.w.regu.f_self,gerjoii_.w.regu.f_self,8); % [Hz]
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
[g_e,a_max] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_);
% ..............................................................................
% manage amplitudes at source locations
% ..............................................................................
% % ----------
% % Kurzmann
% % ----------
% c_stab=1e-1;
% gerjoii_.w.g_e = w_kurzmann(gerjoii_.w.u_2d,a_max,c_stab) .* gerjoii_.w.g_e;
% clear a_max c_stab;
% ----------
% Gaussian
% ----------
% access source in full E field matrix (air+pml+1)
s = gerjoii_.w.s; 
% trim down to parameter matrix
s(2) = s(2)-parame_.w.pjs;                 % ix
s(1) = s(1)-parame_.w.pis-parame_.w.air+1; % iz
% lo is wavelength of wavefield at source location
lo = parame_.w.c/sqrt(parame_.w.epsilon( s(1),s(2) )) / (parame_.w.fo);  % [m]
g_e = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* g_e;
% ..............................................................................
%
%         'imaginary' friend
%
% ..............................................................................
% ..............................................................................
% save full frequency parameters. save 'self'.
% ..............................................................................
d_o = parame_.natu.w.d_2d;
d   = gerjoii_.w.d_2d;
e_  = gerjoii_.w.e_2d;
% ..............................................................................
% filter wavefields
% ..............................................................................
parame_.natu.w.d_2d = filt_gauss(parame_.natu.w.d_2d,geome_.w.dt,...
                  - gerjoii_.w.regu.f_friend,gerjoii_.w.regu.f_friend,8); % [Hz]
gerjoii_.w.d_2d = filt_gauss(gerjoii_.w.d_2d,geome_.w.dt,...
                  - gerjoii_.w.regu.f_friend,gerjoii_.w.regu.f_friend,8); % [Hz]
gerjoii_.w.u_2d = filt_gauss3d_(gerjoii_.w.u_2d,geome_.w.dt,...
                  - gerjoii_.w.regu.f_friend,gerjoii_.w.regu.f_friend,8); % [Hz]
gerjoii_.w.e_2d = filt_gauss(gerjoii_.w.e_2d,geome_.w.dt,...
                  - gerjoii_.w.regu.f_friend,gerjoii_.w.regu.f_friend,8); % [Hz]
% ..............................................................................
% obj
% ..............................................................................
Nw = sparse_diag(parame_.natu.w.N);
Ee_ = w_E(parame_.natu.w.d_2d,gerjoii_.w.d_2d,Nw,gerjoii_.w.obj_FNC);
Ee_ = Ee_ / ( parame_.natu.w.d_2d(:).' * parame_.natu.w.d_2d(:) );
% ..............................................................................
% gradient of data with respect to permittivity
% ..............................................................................
% ---- cross-correlation ---- 
[g_e_,a_max] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_);
% ..............................................................................
% manage amplitudes at source locations
% ..............................................................................
% % ----------
% % Kurzmann
% % ----------
% c_stab=1e-1;
% gerjoii_.w.g_e = w_kurzmann(gerjoii_.w.u_2d,a_max,c_stab) .* gerjoii_.w.g_e;
% clear a_max c_stab;
% ----------
% Gaussian
% ----------
% access source in full E field matrix (air+pml+1)
s = gerjoii_.w.s; 
% trim down to parameter matrix
s(2) = s(2)-parame_.w.pjs;                 % ix
s(1) = s(1)-parame_.w.pis-parame_.w.air+1; % iz
% lo is wavelength of wavefield at source location
lo = parame_.w.c/sqrt(parame_.w.epsilon( s(1),s(2) )) / ...
                (0.5*gerjoii_.w.regu.f_friend);  % [m]
g_e_ = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* g_e_;
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
finite_.w = rmfield(finite_.w,'cpml');
finite_.w = rmfield(finite_.w,'coeff');
% ..............................................................................
% filter permittivity gradients
% ..............................................................................
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
[g_e,~,~]  = image_gaussian(full(g_e),ax,az,'LOW_PASS');
[g_e_,~,~] = image_gaussian(full(g_e_),ax,az,'LOW_PASS');
% gerjoii_.w.g_e = gerjoii_.w.g_e/max(abs(gerjoii_.w.g_e(:)));
% ..............................................................................
% joint here?
% ..............................................................................
[gerjoii_.w.g_e,~] = w_depsilons(g_e,g_e_,Ee,Ee_);
parame_.natu.w.d_2d = d_o; gerjoii_.w.d_2d = d; gerjoii_.w.e_2d = e_;
step_w_e = w_pica_e_(geome_,parame_,finite_,gerjoii_);
depsilon  = double(-step_w_e*gerjoii_.w.g_e(:));
Ee = 0.5*(Ee+Ee_);
% % ..............................................................................
% % step sizes
% % ..............................................................................
% gerjoii_.w.g_e = g_e_;
% step_w_e_ = w_pica_e_(geome_,parame_,finite_,gerjoii_);
% gerjoii_.w.g_e = g_e;
% parame_.natu.w.d_2d = d_o; gerjoii_.w.d_2d = d; gerjoii_.w.e_2d = e_;
% step_w_e = w_pica_e_(geome_,parame_,finite_,gerjoii_);
% % ..............................................................................
% % update
% % ..............................................................................
% depsilon  = double(-step_w_e*g_e(:));
% depsilon_ = double(-step_w_e_*g_e_(:));
% % ............................................................................
% % invert for source
% % ............................................................................
% parame_.natu.w.wvlets_(:,is) = new wvlet source
end
