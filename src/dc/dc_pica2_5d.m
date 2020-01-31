function step_ = dc_pica2_5d(geome_,parame_,finite_,gerjoii_)
  % robin
  robin = parame_.dc.robin;
  nx = finite_.dc.nx;
  nz = finite_.dc.nz;
  k_s = gerjoii_.dc.k_s;
  % error and data
  e_ = gerjoii_.dc.e_;
  d = gerjoii_.dc.d;
  % small perturbation
  dsigma = - gerjoii_.dc.g;
  sigma = parame_.dc.sigma_robin(1+robin:nx-robin,1:nz-robin);
  % find optimal k_s
  k_s = dc_boundstep2(sigma,dsigma,...
                      gerjoii_.dc.regu.sig_max_,gerjoii_.dc.regu.sig_min_,k_s);
  parame_.dc.sigma = sigma .* exp(k_s*sigma .* dsigma);
  % expand to robin & fwd
  [parame_,~] = dc_robin(geome_,parame_,finite_);
  [gerjoii_,~] = dc_fwd2_5d(parame_,finite_,gerjoii_);
  % step like Pica
  d_ = gerjoii_.dc.d - d;
  step_ = k_s * (d_'*e_)/(d_'*d_);
end