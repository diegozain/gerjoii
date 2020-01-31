function [parame_,gerjoii_] = w_image_es_(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
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
% inside of while (except the actual update) is w_update_[e,s].m
tol_iter = gerjoii_.w.tol_iter;
tol_error = gerjoii_.w.tol_error;

E = [];
E_ = Inf;
iter = 0;
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  % ............................................................................
  % permittivity & conductivity in one go! woo!
  % ............................................................................
  gerjoii_ = w_update_es_(geome_,parame_,finite_,gerjoii_);
  % ............................................................................
  % update them
  % ............................................................................
  parame_.w.epsilon = parame_.w.epsilon .* ...
                      exp(parame_.w.epsilon .* gerjoii_.w.depsilon);
  parame_.w.sigma = parame_.w.sigma .* ...
                      exp(parame_.w.sigma .* gerjoii_.w.dsigma);
  % ............................................................................
  % store objective function
  % ............................................................................
  E_ = gerjoii_.w.Ew;
  % ............................................................................
  % print funny stuff
  % ............................................................................
  fprintf('\n  min of relative permittivity %2.2d',min(parame_.w.epsilon(:)));
  fprintf('\n  max of relative permittivity %2.2d\n',max(parame_.w.epsilon(:)));
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  E = [E E_];
  iter = iter+1;  
end % while
gerjoii_.w.E = E;
end