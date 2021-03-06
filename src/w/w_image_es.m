function [parame_,gerjoii_] = w_image_es(geome_,parame_,finite_,gerjoii_)
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
else
  E    = [];
  E_   = Inf;
  iter = 0;
end
% ..............................................................................
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
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
  % save updates
  % ............................................................................
  if strcmp(gerjoii_.w.save_depsi,'YES')
    depsi= gerjoii_.w.depsilon;
    name = strcat(gerjoii_.w.data_patheps_,'depsi',num2str( iter ),'.mat');
    save( name , 'depsi' );
    epsi = parame_.w.epsilon;
    name = strcat(gerjoii_.w.data_patheps_,'epsi',num2str( iter ),'.mat');
    save( name , 'epsi' );
    clear depsi epsi;
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
  % save updates
  % ............................................................................
  if strcmp(gerjoii_.w.save_dsigm,'YES')
    wdsig = gerjoii_.w.dsigma;
    name = strcat(gerjoii_.w.data_pathsig_,'wdsig',num2str( iter ),'.mat');
    save( name , 'wdsig' );
    sigm = parame_.w.sigma;
    name = strcat(gerjoii_.w.data_pathsig_,'sigm',num2str( iter ),'.mat');
    save( name , 'sigm' );
    clear wdsig sigm;
  end
  % ............................................................................
  % store objective function
  % ............................................................................
  E_ = 0.5*(gerjoii_.w.Ee_ + gerjoii_.w.Es_);
  % ............................................................................
  % print funny stuff
  % ............................................................................
  fprintf('\n  min of relative permittivity %2.2d',min(parame_.w.epsilon(:)));
  fprintf('\n  max of relative permittivity %2.2d\n',max(parame_.w.epsilon(:)));
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  fprintf('     current error Ee %2.4d \n',gerjoii_.w.Ee_);
  fprintf('     current error Es %2.4d \n\n',gerjoii_.w.Es_);
  E = [E E_];
  iter = iter+1;  
end % while
gerjoii_.w.E = E;
gerjoii_.w.iter = iter;
end