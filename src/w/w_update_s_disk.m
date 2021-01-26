function [step_w_s,Es] = w_update_s_disk(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain.
% colorado school of mines, summer 2020.
% ..............................................................................
% given one source indexed by is, 
% compute depsilon and objective function value Ee
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
% 7. filter g_s
%   . filter g_s from 3
% 9. step sigma
%   . g_s from 7
%   . d & e from 1
%   . coeff, inner & pml
%   . fields, (Ez,Hx,Hy)
%   . save step_s
% 10. updates
%   . g_s from 7 & step_s from 9
%   . output dsigma
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
Es = w_E(parame_.natu.w.d_2d,gerjoii_.w.d_2d,Nw,gerjoii_.w.obj_FNC);
Es = Es / ( parame_.natu.w.d_2d(:).' * parame_.natu.w.d_2d(:) );
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
lo = parame_.w.c/sqrt(parame_.w.epsilon( s(1),s(2) ))/gerjoii_.w.regu.fo;  % [m]
gerjoii_.w.g_s = gaussi(geome_.X,geome_.Y,s,2*lo,2) .* gerjoii_.w.g_s;
% ..............................................................................
% clean up wavefield
% ..............................................................................
gerjoii_.w = rmfield(gerjoii_.w,'u_2d');
% ..............................................................................
% filter conductivity gradient 
% ..............................................................................
ax = gerjoii_.w.regu.ax*2; 
az = gerjoii_.w.regu.az*2;
[gerjoii_.w.g_s,~,~] = image_gaussian(full(gerjoii_.w.g_s),ax,az,'LOW_PASS'); 
gerjoii_.w.g_s = normali(gerjoii_.w.g_s);
% ..............................................................................
% xgrad push  
% ..............................................................................
if isfield(gerjoii_,'wdc')
  if strcmp(gerjoii_.wdc.sig_too,'YES')
    % ..........................................................................
    % push, low-pass space-frequency, and normalize
    % ..........................................................................
    gerjoii_.w.g_s = gerjoii_.w.g_s - parame_.dsigmx;
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
dsigma = double(-step_w_s*gerjoii_.w.g_s);
% save
domain_mini = struct;
domain_mini.ix = gerjoii_.domain(is).ix;
domain_mini.domain__ = dsigma;
save(strcat(gerjoii_.domain_path,num2str(is),'/','dsigm_domain.mat'),'domain_mini');
% % ............................................................................
% % invert for source
% % ............................................................................
% parame_.natu.w.wvlets_(:,is) = new wvlet source
end
