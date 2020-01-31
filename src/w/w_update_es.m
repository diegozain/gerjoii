function [depsilon,dsigma,Ew] = w_update_es(geome_,parame_,finite_,gerjoii_,is)
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
% 3. grad sigma
%   . coeff from 1
%   . u & e from 1
%   . fields, (Ez,Hx,Hy)
%   . save g_s 
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
% 7. filter g_s
%   . filter g_s from 3
% 8. step epsilon
%   . g_e from 6
%   . d & e from 1
%   . coeff, inner & pml
%   . fields, (Ez,Hx,Hy)
%   . save step_e
% 9. step sigma
%   . g_s from 7
%   . d & e from 1
%   . coeff, inner & pml
%   . fields, (Ez,Hx,Hy)
%   . save step_s
% 10. updates
%   . g_e from 6 & step_e from 8
%   . g_s from 7 & step_s from 9
%   . output dsigma & depsilon
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
% filter wavefields
% ..............................................................................
if strcmp(gerjoii_.w.regu.f_yesno,'YES')
parame_.natu.w.d_2d = filt_gauss(parame_.natu.w.d_2d,geome_.w.dt,...
                               gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
gerjoii_.w.d_2d = filt_gauss(gerjoii_.w.d_2d,geome_.w.dt,...
                               gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
gerjoii_.w.u_2d = filt_gauss3d_(gerjoii_.w.u_2d,geome_.w.dt,...
                               gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
end
gerjoii_.w.e_2d = filt_gauss(gerjoii_.w.e_2d,geome_.w.dt,...
                               gerjoii_.w.regu.f_,gerjoii_.w.regu.f__,8); % [Hz]
% ..............................................................................
% obj
% ..............................................................................
Nw = sparse_diag(parame_.natu.w.N);
Ew = w_E(parame_.natu.w.d_2d,gerjoii_.w.d_2d,Nw,gerjoii_.w.obj_FNC);
Ew = Ew / ( parame_.natu.w.d_2d(:).' * parame_.natu.w.d_2d(:) );
% ..............................................................................
% gradient of data with respect to conductivity
% ..............................................................................
% ---- cross-correlation ----
[gerjoii_.w.g_s,~] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_,parame_);
% ..............................................................................
% manage amplitudes at source locations
% ..............................................................................
% % ----------
% % Kurzmann
% % ----------
% c_stab=1e-1;
% gerjoii_.w.g_s = w_kurzmann(gerjoii_.w.u_2d,a_max,c_stab) .* gerjoii_.w.g_s;
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
lo = parame_.w.c/sqrt(parame_.w.epsilon( s(1),s(2) ))/(parame_.w.fo);% [m]
gerjoii_.w.g_s = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* gerjoii_.w.g_s;
% ..............................................................................
% gradient of data with respect to permittivity
% ..............................................................................
% ---- time derivative ----
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
% ---- cross-correlation ----
[gerjoii_.w.g_e,~] = w_grad(gerjoii_.w.u_2d,geome_,finite_,gerjoii_,parame_);
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
lo = parame_.w.c/sqrt(parame_.w.epsilon( s(1),s(2) ))/(parame_.w.fo);% [m]
gerjoii_.w.g_e = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* gerjoii_.w.g_e;
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
% ..............................................................................
% filter conductivity gradient 
% ..............................................................................
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
[gerjoii_.w.g_s,~,~] = image_gaussian(full(gerjoii_.w.g_s),ax,az,'LOW_PASS');
gerjoii_.w.g_s = gerjoii_.w.g_s/max(abs(gerjoii_.w.g_s(:)));
% ..............................................................................
% filter permittivity gradient 
% ..............................................................................
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
[gerjoii_.w.g_e,~,~] = image_gaussian(full(gerjoii_.w.g_e),ax,az,'LOW_PASS');
gerjoii_.w.g_e = gerjoii_.w.g_e/max(abs(gerjoii_.w.g_e(:)));
% ..............................................................................
% step sizes
% ..............................................................................
% step_w_e = w_pica_e_(geome_,parame_,finite_,gerjoii_);
step_w_e = w_stepparabola_e(geome_,parame_,finite_,gerjoii_,Ee);
step_w_s = w_pica_s_(geome_,parame_,finite_,gerjoii_);
% step_w_s = w_stepparabola_s(geome_,parame_,finite_,gerjoii_,Es);
% step_w_e=1; step_w_s=1;
% ..............................................................................
% update
% ..............................................................................
depsilon = double(-step_w_e*gerjoii_.w.g_e(:));
dsigma = double(-step_w_s*gerjoii_.w.g_s(:));
% % ............................................................................
% % invert for source
% % ............................................................................
% parame_.natu.w.wvlets_(:,is) = new wvlet source
end
