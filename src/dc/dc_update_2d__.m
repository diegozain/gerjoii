function gerjoii_ = dc_update_2d__(geome_,parame_,finite_,gerjoii_)
% ------------------------------------------------------------------------------
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
% ------------------------------------------------------------------------------
n_exp = gerjoii_.dc.n_exp;
E_ = zeros( 1 , n_exp );
dsigmas = zeros( geome_.n*geome_.m , n_exp );
steps = zeros( 1 , n_exp );
% loop over all experiments
parfor i_e=1:n_exp;
  [dsigma,step_,Edc] = dc_update_2d(geome_,parame_,finite_,gerjoii_,i_e);
  % obj
  E_(i_e) = Edc;
  % step size
  steps(i_e) = step_;
  % update
  dsigmas(:,i_e) = dsigma;
end % end for experiments
dsigma = sum(dsigmas,2)/n_exp;
% --
if or(isfield(gerjoii_.dc,'pica_me'),isfield(gerjoii_.dc,'weird_me'))
  % !!!!   weird step size sum thing
  step_ = sum( steps )/n_exp;
  % fprintf('        step size for whole dc update is %2.2d\n',step_);
  dsigma = normali(dsigma);
  dsigma = step_*dsigma;
end
% --
gerjoii_.dc.dsigma = reshape( dsigma,[geome_.n,geome_.m] );
gerjoii_.dc.E_ = sum(E_)/n_exp;
% give it some momentum
gerjoii_.dc.dsigma = gerjoii_.dc.dsigma + ...
                     gerjoii_.dc.momentum*gerjoii_.dc.dsigma_; % 0.5,0.05
gerjoii_.dc.dsigma_ = gerjoii_.dc.dsigma;
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function see_filtering(geome_,gerjoii_)
  ax = gerjoii_.dc.regu.ax*geome_.dx; 
  az = gerjoii_.dc.regu.az*geome_.dy;
  g = gerjoii_.dc.g;
  [~,g_,filt_] = image_gaussian(full(g),az,ax,'LOW_PASS'); 
  g = g/max(abs(g(:)));
  g_ = abs(g_)/max(abs(g_(:)));
  
  % total_g_ = sum(g_(:));
  % signal_g_ = sum( g_(:) .* filt_(:) );
  % beta_ = signal_g_/total_g_;
  fprintf('beta_ = %2.2d\n',gerjoii_.dc.regu.beta__);
  fprintf('ax,az = %2.2d\n',ax/geome_.dx);
  
  [n_,m_] = size(g_);
  dkx = 1/geome_.dx/n_; 
  dkz = 1/geome_.dy/m_;
  kx = (-n_/2:n_/2-1)*dkx;
  kz = (-m_/2:m_/2-1)*dkz;
  
  figure(2); 
  fancy_imagesc(g',geome_.X,geome_.Y);
  xlabel('x (m)'); ylabel('z (m)'); title('filtered gradient');
  simple_figure();
  figure(3); 
  fancy_imagesc(g_',kx,kz); colormap(jet);
  xlabel('kx (1/m)'); ylabel('kz (1/m)'); 
  title('power spectra of gradient');
  simple_figure();
  figure(4); 
  fancy_imagesc(filt_',kx,kz); colormap(jet);
  xlabel('kx (1/m)'); ylabel('kz (1/m)'); title('filter');
  simple_figure();
  pause;
end
