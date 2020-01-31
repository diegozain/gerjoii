function step_ = dc_linesearch(geome_,parame_,finite_,gerjoii_)
  
  % robin
  robin = parame_.dc.robin;
  nx = finite_.dc.nx;
  nz = finite_.dc.nz;
  
  dsigma = parame_.dc.dsigma;% (1+robin:nx-robin,1:nz-robin);
  % dsigma = image_gaussian(full(dsigma),2,2,'LOW_PASS');
  Ndc = sparse_diag(parame_.natu.dc.N);

  l_low = -2; l_high = 1; n_ls = 10;
  l = logspace(l_low,l_high,n_ls);
  E = zeros(n_ls,1);
  warning off;
  for i=1:n_ls
    % ------------
    % fake update
    % ------------
    sigma = parame_.dc.sigma_robin(1+robin:nx-robin,1:nz-robin);
    sigma_ = sigma .* exp(l(i)*sigma.*dsigma);
    parame_.dc.sigma = sigma_;
    [parame_,~,~] = dc_exp2robin(geome_,parame_,finite_,gerjoii_);
    % ------------------------------------
    % forward run and objective fnc
    % ------------------------------------
    [gerjoii_,finite_] = dc_fwd2d(parame_,finite_,gerjoii_);
    e_2d = gerjoii_.dc.e_2d;
    E(i) = dc_E(e_2d,Ndc);
  end
  warning on;
  [E,i] = min(E);
  step_ = l(i);
end