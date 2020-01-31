function [parame_,gerjoii_] = w_image_e(geome_,parame_,finite_,gerjoii_)
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
% inside of while (except updating) is w_update_[e,s].m
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
  % compute update
  % ............................................................................
  gerjoii_ = w_update_e_(geome_,parame_,finite_,gerjoii_);
  % ............................................................................
  % update
  % ............................................................................
  parame_.w.epsilon = parame_.w.epsilon .* ...
                      exp(parame_.w.epsilon.*gerjoii_.w.depsilon);
  % ............................................................................
  % store obj
  % ............................................................................
  E_ = gerjoii_.w.Ee_;
  E = [E E_];
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
  % print funny stuff
  % ............................................................................
  fprintf('\n  min of relative permittivity %2.2d',min(parame_.w.epsilon(:)));
  fprintf('\n  max of relative permittivity %2.2d\n',max(parame_.w.epsilon(:)));
  fprintf('  current error %2.2d at iteration %i \n\n',E_,iter+1);
  iter = iter+1;  
end % while
gerjoii_.w.Ee = E;
gerjoii_.w.E  = E;
gerjoii_.w.iter = iter;
end