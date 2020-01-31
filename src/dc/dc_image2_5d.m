function [parame_,gerjoii_] = dc_image2_5d(geome_,parame_,finite_,gerjoii_)

% while loop (iteration)
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
%   stack updates
%   update
% end while
%
% inside of while (except updating) is dc_update_2d.m

tol_iter = gerjoii_.dc.tol_iter;
tol_error = gerjoii_.dc.tol_error;

E = [];
E_ = Inf;
iter = 0;
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  % compute update
  gerjoii_.dc.iter=iter;
  gerjoii_ = dc_update2_5d(geome_,parame_,finite_,gerjoii_);
  % pause;
  % update
  parame_.dc.sigma = parame_.dc.sigma .* ...
                      exp(parame_.dc.sigma .* gerjoii_.dc.dsigma);
  % obj
  E_ = gerjoii_.dc.E_;
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  E = [E E_];
  iter = iter+1;  
end % while
gerjoii_.dc.E = E;
end