function [parame_,gerjoii_] = wdc_image_2d(geome_,parame_,finite_,gerjoii_)

% while loop (iteration)
%   // wave
%   parfor loop (sources)
%     choose source, data and receivers
%     fwd
%     obj
%     store obj
%     gradient
%     step size
%     compute update 
%     store update
%   end parfor
%   stack obj
%   dsigma_w = stack updates_w
%   // dc
%   parfor loop (sources)
%     choose source, data and receivers
%     fwd
%     obj
%     store obj
%     gradient
%     step size
%     compute update 
%     store update
%   end parfor
%   stack obj
%   dsigma_dc = stack updates_dc
%
%   !!!!!! joint update !!!!!
%   dsigma = 0.5* ( dsigma_w + dsigma_dc )
%
%   update 
%
% end while
%
% for's and stacks inside of while (except updating) are [w,dc]_update_2d.m

tol_iter = gerjoii_.wdc.tol_iter;
tol_error = gerjoii_.wdc.tol_error;

E = [];
E_ = Inf;
iter = 0;
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  gerjoii_ = w_update_s_(geome_,parame_,finite_,gerjoii_);
  gerjoii_ = dc_update_2d_(geome_,parame_,finite_,gerjoii_);
  % joint update
  a = wdc_steps(gerjoii_.w.Es_ , gerjoii_.dc.E_);
  fprintf('\nw error %2.2d',gerjoii_.w.Es_)
  fprintf('\ndc error %2.2d\n',gerjoii_.dc.E_)
  % fprintf('\na_w = %2.2d',a(1))
  % fprintf('\na_dc = %2.2d\n',a(2))
  wdsig = gerjoii_.w.dsigma;
  dcdsig = gerjoii_.dc.dsigma;
  wdsig_ = max(abs(wdsig(:)));
  dcdsig_ = max(abs(dcdsig(:)));
  wdsig = wdsig/wdsig_;
  dcdsig = dcdsig/dcdsig_;
  wdcsig =  a(1)*wdsig + a(2)*dcdsig.';
  wdcsig = wdcsig/max(wdcsig(:));
  wdcsig = min(wdsig_,dcdsig_)*wdcsig;
  gerjoii_.wdc.dsigma = wdcsig;
  % filter update
  % ax = 3; az = 3;
  % ax = ax*geome_.dx; az = az*geome_.dy;
  ax = gerjoii_.w.regu.ax; az = gerjoii_.w.regu.az;
  gerjoii_.wdc.dsigma = image_gaussian(full(gerjoii_.wdc.dsigma),...
                                        ax,az,'LOW_PASS');
  % update
  parame_.wdc.sigma = parame_.wdc.sigma .* ...
                      exp(parame_.wdc.sigma .* gerjoii_.wdc.dsigma);
  parame_.w.sigma = parame_.wdc.sigma;
  parame_.dc.sigma = parame_.wdc.sigma';
  % obj
  E_ = 0.5*(gerjoii_.w.Es_ + gerjoii_.dc.E_);
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  E = [E E_];
  iter = iter+1;  
end % while
gerjoii_.wdc.E = E;
end