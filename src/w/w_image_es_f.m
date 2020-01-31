function [parame_,gerjoii_] = w_image_es_f(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
tol_iter = gerjoii_.w.tol_iter;
tol_error = gerjoii_.w.tol_error;
% ..............................................................................
% linker from a suspended inversion 
if isfield(gerjoii_,'linker')
  E = gerjoii_.w.E;
  if numel(E)==0
    E_ = Inf;
  else
    E_ = E(end);
  end
  iter = gerjoii_.w.iter;
  dE__ = gerjoii_.w.regu.dE__;
else
  E    = [];
  E_   = Inf;
  iter = 0;
end
% ..............................................................................
while (E_>tol_error & iter<tol_iter)
  E_=0;
  % ............................................................................
  % frequency stepping scheme
  % ............................................................................
  if numel(E)>1
    dE_ = E(end)-E(end-1);
  else
    dE_=0;
  end
  if numel(E)==2
    dE__=dE_;
    gerjoii_.w.regu.dE__=dE__;
  end
  gerjoii_ = w_freqchoose(gerjoii_,parame_,iter,dE_);
  % ............................................................................
  % joint depsi-weight & xgrad
  % ............................................................................
  if strcmp(gerjoii_.wdc.eps_too,'YES')
    % make sure values are not flat
    cme = curva_mean(parame_.w.epsilon);
    cms = curva_mean(parame_.w.sigma);
    cme = mean(cme(:));
    cms = mean(cms(:));
    gerjoii_.wdc.depsi = zeros(size(parame_.w.epsilon));
    if and(and(cme~=0,cms~=0),iter>1)
      % b=1e-5;
      p = gerjoii_.w.regu.p_eps;
      b = 0*w_xgrad(dE_,dE__,p);
      fprintf('\n b eps is %2.2d\n',b)
      [epsix,depsix] = wdc_xgrad(parame_.w.epsilon,parame_.w.sigma,gerjoii_);
      % --
      gerjoii_.wdc.depsi = b*depsix;
      % clean
      clear epsix depsix
    end
  end 
  % ............................................................................
  % permittivity first
  % ............................................................................
  gerjoii_ = w_update_e_(geome_,parame_,finite_,gerjoii_);
  % ............................................................................
  % update it
  % ............................................................................
  parame_.w.epsilon = parame_.w.epsilon .* ...
                      exp(parame_.w.epsilon .* gerjoii_.w.depsilon);
  % ............................................................................
  % xgrad sigm gives dsigmx to work with
  % ............................................................................
  if strcmp(gerjoii_.wdc.sig_too,'YES')
    % make sure values are not flat
    cme = curva_mean(parame_.w.epsilon);
    cms = curva_mean(parame_.w.sigma);
    cme = mean(cme(:));
    cms = mean(cms(:));
    gerjoii_.wdc.dsigmx = zeros(size(parame_.w.sigma));
    if and(and(cme~=0,cms~=0),iter>1)
      % b=1e-5;
      p = gerjoii_.w.regu.p_sig;
      b = -w_xgrad(dE_,dE__,p);
      fprintf('\n b sig is %2.2d\n',b)
      [sigmx,dsigmx] = wdc_xgrad_(parame_.w.epsilon,parame_.w.sigma,gerjoii_);
      % --
      gerjoii_.wdc.dsigmx = b*dsigmx;
      % clean
      clear sigmx dsigmx
    end
  end
  % ............................................................................
  % conductivity second
  % ............................................................................
  gerjoii_ = w_update_s_(geome_,parame_,finite_,gerjoii_);
  % ............................................................................
  % update it
  % ............................................................................
  parame_.w.sigma = parame_.w.sigma .* ...
                      exp(parame_.w.sigma .* gerjoii_.w.dsigma);
  % ............................................................................
  % store objective function
  % ............................................................................
  E_ = 0.5*(gerjoii_.w.Ee_ + gerjoii_.w.Es_);
  % ............................................................................
  % print funny stuff
  % ............................................................................
  fprintf('\n  min of relative permittivity %2.2d',min(parame_.w.epsilon(:)));
  fprintf('\n  max of relative permittivity %2.2d\n',max(parame_.w.epsilon(:)));
  fprintf('\n .....................................\n')
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  fprintf('     current error Ee %2.4d \n',gerjoii_.w.Ee_);
  fprintf('     current error Es %2.4d ',gerjoii_.w.Es_);
  fprintf('\n .....................................\n')
  % ............................................................................
  E = [E E_];
  iter = iter+1;  
end % while
gerjoii_.w.E = E;
gerjoii_.w.iter = iter;
end