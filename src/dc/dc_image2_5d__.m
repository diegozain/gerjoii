function [parame_,gerjoii_] = dc_image2_5d__(geome_,parame_,finite_,gerjoii_)
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
    v_currs = gerjoii_.dc.v_currs;
  end
else
  E    = [];
  E_   = Inf;
  iter = 0;
  v_currs = zeros(geome_.n,geome_.m);
end
% ..............................................................................
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  % ............................................................................
  % compute update
  gerjoii_ = dc_update2_5d__(geome_,parame_,finite_,gerjoii_);
  % ............................................................................
  % update
  parame_.dc.sigma = parame_.dc.sigma .* ...
                      exp(parame_.dc.sigma .* gerjoii_.dc.dsigma);
  % ............................................................................
  % stack current potential
  v_currs = gerjoii_.dc.v_currs + gerjoii_.dc.v_curr;
  % ............................................................................
  % save updates
  % ............................................................................
  if isfield(gerjoii_.dc,'save_dsigm')
    dsigm_dc= gerjoii_.dc.dsigma.';
    name = strcat(gerjoii_.dc.data_pathsigs_,'dsigm_dc',num2str( iter ),'.mat');
    save( name , 'dsigm_dc' );
    sigm = parame_.dc.sigma.';
    name = strcat(gerjoii_.dc.data_pathsigs_,'sigm',num2str( iter ),'.mat');
    save( name , 'sigm' );
    clear dsigm_dc sigm;
  end
  % ............................................................................
  % obj
  E_ = gerjoii_.dc.E_;
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  E = [E E_];
  iter = iter+1;  
end
gerjoii_.dc.E = E;
% store iterations
gerjoii_.dc.iter = iter;
% store current potentials stack
gerjoii_.dc.v_currs = v_currs;
end