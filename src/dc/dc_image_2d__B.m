function [parame_,gerjoii_] = dc_image_2d__(geome_,parame_,finite_,gerjoii_)
% diego domenzain
% fall 2019 @ BSU
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
% inside of while (except updating) is dc_update_2d.m
% ..............................................................................
tol_iter  = gerjoii_.dc.tol_iter;
tol_error = gerjoii_.dc.tol_error;
% ..............................................................................
% linker from a suspended inversion 
if isfield(gerjoii_,'linker')
  if strcmp(gerjoii_.linker.yn,'y')
    E = gerjoii_.dc.E;
    if numel(E)==0
      E_ = Inf;
    else
      E_ = E(end);
    end
    iter = gerjoii_.dc.iter;
  else 
    E    = [];
    E_   = Inf;
    iter = 0;
  end
else
  E    = [];
  E_   = Inf;
  iter = 0;
end
% ..............................................................................
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  if iter==0
    % ..........................................................................
    % compute update
    gerjoii_ = dc_update_2d__(geome_,parame_,finite_,gerjoii_);
    gerjoii_.dc.B = eye(numel( parame_.dc.sigma(:) ),'single');
    gerjoii_.dc.g = typecast(-gerjoii_.dc.dsigma(:),'single');
    gerjoii_.dc.p = typecast(parame_.dc.sigma(:),'single');
  end
  % ............................................................................
  % apply sherman-morrison
  dsigma = - gerjoii_.dc.B*gerjoii_.dc.g;
  dsigma = reshape(dsigma,size(parame_.dc.sigma));
  % ............................................................................
  % smooth
  ax = gerjoii_.dc.regu.ax; az = gerjoii_.dc.regu.az;
  dsigma = image_gaussian(full(dsigma),az,ax,'LOW_PASS');
  fprintf('\n norm of dsigmadc = %2.2d\n',norm(dsigma(:)));
  % ............................................................................
  % update
  parame_.dc.sigma = parame_.dc.sigma .* ...
                      exp(parame_.dc.sigma .* dsigma);
  fprintf('\n         max sig = %d',max(parame_.dc.sigma(:)) );
  fprintf('\n         min sig = %d\n\n',min(parame_.dc.sigma(:)));
  % ............................................................................
  % compute update
  gerjoii_ = dc_update_2d__(geome_,parame_,finite_,gerjoii_);
  % ............................................................................
  % setup sherman-morrison
  g_= - gerjoii_.dc.dsigma(:);
  y = g_ - gerjoii_.dc.g;
  p_= parame_.dc.sigma(:);
  q = p_ - gerjoii_.dc.p;
  gerjoii_.dc.B = sher_morr(gerjoii_.dc.B,q,y);
  fprintf('is q*y>0 ?\n');
  fprintf('%d \n',q'*y);
  % ............................................................................
  % record g and sigma
  gerjoii_.dc.g = g_;
  gerjoii_.dc.p = p_;
  % ............................................................................
  % obj
  E_ = gerjoii_.dc.E_;
  % ............................................................................
  % book-keeping
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  E = [E E_];
  iter = iter+1;  
end % while
gerjoii_.dc.E = E;
gerjoii_.dc.iter = iter;
end