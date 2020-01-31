function gerjoii_ = dc_update2_5d_(geome_,parame_,finite_,gerjoii_)

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

n_exp = gerjoii_.dc.n_exp;
% n_exp=76;
E_ = zeros( 1 , n_exp );
dsigma = zeros( geome_.n*geome_.m , n_exp );
steps = zeros( 1 , n_exp );

% loop over all experiments
for i_e=1:n_exp;
  % choose source, receivers, measuring operator, observed data & std
  [gerjoii_,parame_] = dc_electrodes(geome_,parame_,finite_,gerjoii_,i_e);
  % % compute ky and w weights
  % finite_ = dc_kfourier(finite_,gerjoii_);
  % unbox ky and w weights
  finite_.dc.ky_w_ = finite_.dc.ky_w(:,:,i_e);
  % build M for that source
  gerjoii_ = dc_M(finite_,gerjoii_);
  % --------
  %   update
  % --------
  % expand to robin
  [parame_,~] = dc_robin( geome_,parame_,finite_ );
  % fwd model
  [gerjoii_,finite_] = dc_fwd2_5d( parame_,finite_,gerjoii_ );
  % attenuate noise
  signal = 1./(parame_.natu.dc.std_ + 1);
  gerjoii_.dc.e_ = signal .* gerjoii_.dc.e_;
  % i_amps = gerjoii_.dc.s_i_r_d_std{ i_e }{ 1 }(3);
  % gerjoii_.dc.e_2d = i_amps * gerjoii_.dc.e_2d;
  % obj
  E_(i_e) = 0.5*( gerjoii_.dc.e_.' * gerjoii_.dc.e_ );
  % gradient of data
  gerjoii_ = dc_gradient2_5d( parame_,finite_,gerjoii_ );
  % %
  % see_filtering(geome_,gerjoii_); 
  % %
  % reference conductivity
  sigma_error = parame_.dc.sigma-parame_.dc.sigma_o;
  gerjoii_.dc.sigma_error = sigma_error;
  % filter gradient
  gerjoii_ = dc_regularize2_5d( gerjoii_ );
  % fprintf('ax = %2.2d\n',gerjoii_.dc.regu.ax)
  % % see src-receivers and filtering
  % gerjoii_.dc.s_i_r_d_std{i_e}{1}(1:2)
  % gerjoii_.dc.s_i_r_d_std{i_e}{2}(:,1:2)
  % see_filtering(geome_,gerjoii_); 
  % step size
  step_ = dc_pica2_5d( geome_,parame_,finite_,gerjoii_ );
  steps(i_e) = step_;
  % update
  dsigma(:,i_e) = -step_*gerjoii_.dc.g(:);
  % print # of shots for the anxious
  if mod(i_e,10)==0
    fprintf('     just finished updates before shot #%i\n',i_e+1);
  end
end % end for experiments
% 
% !!!!   weird step size sum thing
%
step_ = sum( steps )/n_exp;
dsigma = sum(dsigma,2);
dsigma = dsigma/max(abs(dsigma(:)));
dsigma = step_*dsigma;
gerjoii_.dc.dsigma = reshape( dsigma,[geome_.n,geome_.m] );
gerjoii_.dc.E_ = sum(E_)/n_exp;
% % see
% step_
% figure(9);semilogy(1:n_exp,steps,'k.-','Markersize',20); axis tight
% figure(10); fancy_imagesc(gerjoii_.dc.dsigma'); pause;
end

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

function see_filtering(geome_,gerjoii_)
  ax = gerjoii_.dc.regu.ax; % *geome_.dx; 
  az = gerjoii_.dc.regu.az; % *geome_.dy;
  g = gerjoii_.dc.g;
  [~,g_,filt_] = image_gaussian(full(g),az,ax,'LOW_PASS'); 
  g = g/max(abs(g(:)));
  g_ = abs(g_)/max(abs(g_(:)));
  
  % total_g_ = sum(g_(:));
  % signal_g_ = sum( g_(:) .* filt_(:) );
  % beta_ = signal_g_/total_g_;
  
  fprintf('beta_ = %2.2d\n',gerjoii_.dc.regu.beta_);
  fprintf('ax,az = %2.2d\n',ax/geome_.dx);
  
  [n_,m_] = size(g_);
  dkx = 1/geome_.dx/n_; 
  dkz = 1/geome_.dy/m_;
  kx = (-n_/2:n_/2-1)*dkx;
  kz = (-m_/2:m_/2-1)*dkz;
  
  figure(2); 
  fancy_imagesc(g',geome_.X,geome_.Y);
  xlabel('$x\;[m]$'); ylabel('$z\;[m]$'); title('filtered gradient');
  fancy_figure();
  
  figure(3); 
  fancy_imagesc(g_',kx,kz); colormap(jet);
  xlabel('$k_x\;[1/m]$'); ylabel('$k_z\;[1/m]$'); 
  title('power spectra of gradient');
  fancy_figure();
  
  figure(4); 
  fancy_imagesc(filt_',kx,kz); colormap(jet);
  xlabel('$k_x\;[1/m]$'); ylabel('$k_z\;[1/m]$'); title('filter');
  fancy_figure();
  
  pause;
end
