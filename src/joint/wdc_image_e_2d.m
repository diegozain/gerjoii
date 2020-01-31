function [parame_,gerjoii_] = wdc_image_e_2d(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% invert (i call it 'to image') for permittivity and conductivity.
% ------------------------------------------------------------------------------
tol_iter = gerjoii_.wdc.tol_iter;
tol_error = gerjoii_.wdc.tol_error;
% path to store updates for conductivity (if wanted)
data_pathsigs_ = 'dsigs/';
data_patheps_ = 'depsis/';
% linker from a suspended inversion 
if isfield(gerjoii_,'linker')
  E = gerjoii_.wdc.E;
  if numel(E)==0
    E_ = Inf;
  else
    E_ = E(end);
  end
  as = gerjoii_.wdc.as;
  h_w_ = gerjoii_.wdc.h_w_;
  Ee = gerjoii_.wdc.Ee;
  b_ = gerjoii_.wdc.deps.b;
  bsigx_ = gerjoii_.wdc.dsigx.b;
  iter = gerjoii_.wdc.iter;
else
  E = [];
  E_ = Inf;
  as = zeros(2,2);
  h_w_ = [];
  Ee = [];
  b_ = [];
  bsigx_ = [];
  iter = 0;
end
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  % ............................................................................
  %                 compute updates as stacked gradients
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
    if and(and(cme~=0,cms~=0),iter>0)
      bsigx = wdc_b(gerjoii_.wdc.dsigx.h,gerjoii_.wdc.dsigx.d,as(1,2,2),...
                a_(1,2),a_(1,1));
      % b=0.5;
      bsigx_ = [bsigx_ bsigx];
      fprintf(' b=%2.2d\n\n',bsigx);
      [sigmx,dsigmx] = wdc_xgrad_(parame_.w.epsilon,parame_.w.sigma,gerjoii_);
      gerjoii_.wdc.dsigmx = bsigx*dsigmx;
      % clean
      clear sigmx dsigmx
    end
  end
  % ............................................................................
  % conductivity first
  % ............................................................................
  gerjoii_ = w_update_s_(geome_,parame_,finite_,gerjoii_);
  gerjoii_ = dc_update_2d__(geome_,parame_,finite_,gerjoii_);
  fprintf('\n just computed dsigma_w & dsigma_dc');
  % ............................................................................
  % joint update (average sum of gradients)
  % ............................................................................
  fprintf('\n -----------------------')
  fprintf('\n      Ew,s = %2.2d',gerjoii_.w.Es_)
  fprintf('\n      Edc  = %2.2d',gerjoii_.dc.E_)
  fprintf('\n -----------------------\n')
  % weight regulator
  if iter==0
    gerjoii_.wdc.h_w = wdc_hw(gerjoii_.w.Es_,gerjoii_.dc.E_,gerjoii_.wdc.adc_);
  end
  h_w_=[h_w_ , gerjoii_.wdc.h_w];
  if iter>3
    % das_w   = das(1,1)
    % das_dc  = das(1,2)
    % dEw     = das(2,1)
    % dEdc    = das(2,2)
    das = as(:,:,iter)-as(:,:,iter-1);
    das = squeeze(das);
    % ------
    % dc
    % ------
    % if dc needs help being heard: increase h_w.
    if das(1,2)<0
      gerjoii_.wdc.h_w = gerjoii_.wdc.h_w*gerjoii_.wdc.da_dc;
    end
    % if dc has obj fnc value increasing, it needs to be heard more. (cry for help)
    if das(2,2)>0
      gerjoii_.wdc.h_w = gerjoii_.wdc.h_w*gerjoii_.wdc.dEdc;
    end
    % ------
    % w
    % ------
    % if w needs help being heard: decrease h_w
    if das(1,1)<0
      gerjoii_.wdc.h_w = gerjoii_.wdc.h_w*gerjoii_.wdc.da_w;
    end
    % if w has obj fnc value increasing, it needs to be heard more (a little more).
    if das(2,1)>0
      gerjoii_.wdc.h_w = gerjoii_.wdc.h_w*gerjoii_.wdc.dEw;
    end
  end
  % ............................................................................
  if isfield('gerjoii_.wdc','step_')
    step_ = gerjoii_.wdc.step_;
  else
    step_ = 1;
  end
  [gerjoii_.wdc.dsigma,a_] = wdc_dsigma(gerjoii_.w.dsigma,...
                                        gerjoii_.dc.dsigma,...
                                        gerjoii_.wdc.h_w*gerjoii_.w.Es_,...
                                        gerjoii_.dc.E_,step_);
  % ............................................................................
  % filter update
  ax = gerjoii_.w.regu.ax*2; 
  az = gerjoii_.w.regu.az*2;
  gerjoii_.wdc.dsigma = image_gaussian(full(gerjoii_.wdc.dsigma),...
                                        ax,az,'LOW_PASS');
  % save a's & Es's
  % first row a, second row Es's
  fprintf(' aw=%2.2d , adc=%2.2d\n',a_(1),a_(2)); 
  b = a_(2)/a_(1);
  a_ = [a_ ; gerjoii_.w.Es_,gerjoii_.dc.E_];
  as = cat(3,as,a_);
  % ............................................................................
  % conductivity updating
  % ............................................................................
  parame_.wdc.sigma = parame_.wdc.sigma .* ...
                      exp(parame_.wdc.sigma .* gerjoii_.wdc.dsigma);
  parame_.w.sigma = parame_.wdc.sigma;
  parame_.dc.sigma = parame_.wdc.sigma.';
  fprintf('\n         max sig = %d',max(parame_.wdc.sigma(:)) );
  fprintf('\n         min sig = %d\n\n',min(parame_.wdc.sigma(:)));
  % ............................................................................
  % save updates
  % ............................................................................
  if strcmp(gerjoii_.wdc.save_dsigs,'YES')
    wdcsig = gerjoii_.wdc.dsigma;
    wdsig = gerjoii_.w.dsigma;
    dcdsig = gerjoii_.dc.dsigma;
    sigm = parame_.wdc.sigma;
    name = strcat(data_pathsigs_,'dcdsig',num2str( iter ),'.mat');
    save( name , 'dcdsig' );
    name = strcat(data_pathsigs_,'wdsig',num2str( iter ),'.mat');
    save( name , 'wdsig' );
    name = strcat(data_pathsigs_,'wdcsig',num2str( iter ),'.mat');
    save( name , 'wdcsig' );
    name = strcat(data_pathsigs_,'sigm',num2str( iter ),'.mat');
    save( name , 'sigm' );
    clear wdcsig wdsig dcdsig sigm;
  end
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
    if and(cme~=0,cms~=0)
      b = wdc_b(gerjoii_.wdc.deps.h,gerjoii_.wdc.deps.d,as(1,2,2),...
                a_(1,2),a_(1,1));
      % b=0.5;
      b_ = [b_ b];
      fprintf(' b=%2.2d\n\n',b);
      [epsix,depsix] = wdc_xgrad(parame_.w.epsilon,parame_.w.sigma,gerjoii_);
      % parame_.w.epsilon  = epsix;
      % gerjoii_.wdc.depsi = b*depsix;
      % parame_.w.epsilon = epsix .* exp(epsix.*depsix*b);
      % -
      % parame_.w.epsilon = parame_.w.epsilon + b*depsix;
      % -
      gerjoii_.wdc.depsi = b*depsix;
      % clean
      clear epsix depsix
    end
  end
  % ............................................................................
  % permittivity second
  % ............................................................................
  gerjoii_ = w_update_e_(geome_,parame_,finite_,gerjoii_);
  fprintf('\n just computed depsilon');
  fprintf('\n --------------------------')
  fprintf('\n      Ew,e = %2.2d',gerjoii_.w.Ee_)
  fprintf('\n --------------------------\n')
  % ............................................................................
  % get obj fnc
  % ............................................................................
  Ee = [Ee gerjoii_.w.Ee_];
  gerjoii_.wdc.depsilon = gerjoii_.w.depsilon; 
  % ............................................................................
  % permittivity updating
  % ............................................................................
  parame_.w.epsilon = parame_.w.epsilon .* ...
                      exp(parame_.w.epsilon.*gerjoii_.wdc.depsilon);
  % ............................................................................
  % save updates
  % ............................................................................
  if strcmp(gerjoii_.wdc.save_deps,'YES')
    depsi = gerjoii_.w.depsilon;
    name = strcat(data_patheps_,'depsi',num2str( iter ),'.mat');
    save( name , 'depsi' );
    epsi = parame_.w.epsilon;
    name = strcat(data_patheps_,'epsi',num2str( iter ),'.mat');
    save( name , 'epsi' );
    clear depsi epsi;
  end
  % ............................................................................
  % obj
  % ............................................................................
  E_ = 0.5*(gerjoii_.w.Ee_ + 0.5*(gerjoii_.w.Es_+gerjoii_.dc.E_));
  E = [E E_];
  % ............................................................................
  % print funny stuff
  % ............................................................................
  fprintf('\n  min of relative permittivity %2.2d',min(parame_.w.epsilon(:)));
  fprintf('\n  max of relative permittivity %2.2d\n',max(parame_.w.epsilon(:)));
  fprintf('\n ..............................')
  fprintf('\n  E = %2.2d at iteration %i ',E_,iter+1);
  fprintf('\n ..............................\n')
  iter = iter+1;  
end % while ends here
gerjoii_.wdc.E = E;
gerjoii_.wdc.as = as;
gerjoii_.wdc.h_w_ = h_w_;
gerjoii_.wdc.Ee = Ee;
gerjoii_.wdc.deps.b = b_;
gerjoii_.wdc.dsigx.b = bsigx_;
gerjoii_.wdc.iter = iter;
end
