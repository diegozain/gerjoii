function [parame_,gerjoii_] = wdc_imageOBJe_2d(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% invert (i call it 'to image') for permittivity and conductivity.
% ------------------------------------------------------------------------------
tol_iter  = gerjoii_.wdc.tol_iter;
tol_error = gerjoii_.wdc.tol_error;
% path to store updates for conductivity (if wanted)
data_pathsigs_ = 'dsigs/';
data_patheps_  = 'depsis/';
% linker from a suspended inversion 
if isfield(gerjoii_,'linker')
  E = gerjoii_.wdc.E;
  if numel(E)==0
    E_ = Inf;
  else
    E_ = E(end);
  end
  as   = gerjoii_.wdc.as;
  % .......................
  % as = 
  %       [  aw   ,  adc  ]
  %       [  Ews  ,  Edc  ]
  % .......................
  h_w_ = gerjoii_.wdc.h_w_;
  Ee   = gerjoii_.wdc.Ee;
  b_   = gerjoii_.wdc.deps.b;
  bsigx_ = gerjoii_.wdc.dsigx.b;
  iter = gerjoii_.wdc.iter;
else
  E  = [];
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
  % xgrad: make sigma_dc look like sigma_w
  % ............................................................................
  if strcmp(gerjoii_.wdc.xss_dcw_,'YES')
    % make sure values are not flat
    cmdc= curva_mean(parame_.dc.sigma.');
    cmw = curva_mean(parame_.w.sigma);
    cmdc= mean(cmdc(:));
    cmw = mean(cmw(:));
    gerjoii_.wdc.dsigmx_ = zeros(size(parame_.w.sigma));
    if and(and(cmdc~=0,cmw~=0),iter>0)
      bsigx = wdc_b(gerjoii_.wdc.xss_dcw.h,gerjoii_.wdc.xss_dcw.d,as(1,2,2),...
                as(1,2,iter+1),as(1,1,iter+1));
      % b=0.5;
      bsigx_ = [bsigx_ bsigx];
      fprintf(' bs=%2.2d\n\n',bsigx);
      % dsigmx makes sigma_dc look like sigma_w 
      [sigmx,dsigmx] = wdc_xgrad_(parame_.w.sigma,parame_.dc.sigma.',gerjoii_);
      gerjoii_.wdc.dsigmx_ = bsigx*dsigmx;
      % clean
      clear sigmx dsigmx
    end
  end
  % ............................................................................
  % xgrad: make sigm_dc look like epsi (wdc)
  % ............................................................................
  if strcmp(gerjoii_.wdc.xse_dcw_,'YES')
    % make sure values are not flat
    cme = curva_mean(parame_.w.epsilon);
    cms = curva_mean(parame_.dc.sigma.');
    cme = mean(cme(:));
    cms = mean(cms(:));
    gerjoii_.wdc.dsigmx = zeros(size(parame_.w.epsilon));
    if and(and(cme~=0,cms~=0),iter>0)
      b = wdc_b(gerjoii_.wdc.xse_dcw.h,gerjoii_.wdc.xse_dcw.d,as(1,2,2),...
                as(1,2,iter+1),as(1,1,iter+1));
      % b=0.5;
      b_ = [b_ b];
      fprintf(' be=%2.2d\n\n',b);
      % depsix makes sigma_dc look like epsilon
      [epsix,depsix] = wdc_xgrad(parame_.dc.sigma.',parame_.w.epsilon,gerjoii_);
      gerjoii_.wdc.dsigmx = b*depsix;
      % clean
      clear epsix depsix
    end
  end
  % ............................................................................
  %
  % ............................................................................
  if and(strcmp(gerjoii_.wdc.xss_dcw_,'YES'),strcmp(gerjoii_.wdc.xse_dcw_,'YES'))
    gerjoii_.wdc.dsigmx = (gerjoii_.wdc.dsigmx+gerjoii_.wdc.dsigmx_)*0.5;
    gerjoii_.wdc.sig_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xss_dcw_,'NO'),strcmp(gerjoii_.wdc.xse_dcw_,'YES'))
    gerjoii_.wdc.dsigmx = gerjoii_.wdc.dsigmx;
    gerjoii_.wdc.sig_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xss_dcw_,'YES'),strcmp(gerjoii_.wdc.xse_dcw_,'NO'))
    gerjoii_.wdc.dsigmx = gerjoii_.wdc.dsigmx_;
    gerjoii_.wdc.sig_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xss_dcw_,'NO'),strcmp(gerjoii_.wdc.xse_dcw_,'NO'))
    gerjoii_.wdc.dsigmx = zeros(size(parame_.w.sigma));
    gerjoii_.wdc.sig_too = 'NO';
  end
  % ............................................................................
  % conductivity (dc)
  % ............................................................................
  gerjoii_ = dc_update_2d__(geome_,parame_,finite_,gerjoii_);
  fprintf('\n just computed dsigma_dc');
  % ............................................................................
  % conductivity (dc) updating
  % ............................................................................
  parame_.dc.sigma = parame_.dc.sigma .* ...
                      exp(parame_.dc.sigma .* gerjoii_.dc.dsigma);
  fprintf('\n         max sig_dc = %d',    max(parame_.dc.sigma(:)) );
  fprintf('\n         min sig_dc = %d\n\n',min(parame_.dc.sigma(:)));
  % ............................................................................
  % xgrad: make sigma_w look like epsi (w)
  % ............................................................................
  if strcmp(gerjoii_.wdc.xse_ww_,'YES')
    % make sure values are not flat
    cms= curva_mean(parame_.w.sigma);
    cme= curva_mean(parame_.w.epsilon);
    cms= mean(cms(:));
    cme= mean(cme(:));
    gerjoii_.wdc.dsigmx_ = zeros(size(parame_.w.sigma));
    if and(and(cms~=0,cme~=0),iter>0)
      bsigx = wdc_b(gerjoii_.wdc.xse_ww.h,gerjoii_.wdc.xse_ww.d,as(1,2,2),...
                as(1,2,iter+1),as(1,1,iter+1));
      % b=0.5;
      bsigx_ = [bsigx_ bsigx];
      fprintf(' bs=%2.2d\n\n',bsigx);
      % dsigmx makes sigma_w look like epsilon 
      [sigmx,dsigmx] = wdc_xgrad_(parame_.w.epsilon,parame_.w.sigma,gerjoii_);
      gerjoii_.wdc.dsigmx_ = bsigx*dsigmx;
      % clean
      clear sigmx dsigmx
    end
  end
  % ............................................................................
  % xgrad: make sigma_w look like sigma_dc
  % ............................................................................
  if strcmp(gerjoii_.wdc.xss_wdc_,'YES')
    % make sure values are not flat
    cmdc= curva_mean(parame_.dc.sigma.');
    cmw = curva_mean(parame_.w.sigma);
    cmdc= mean(cmdc(:));
    cmw = mean(cmw(:));
    gerjoii_.wdc.dsigmx = zeros(size(parame_.w.sigma));
    if and(and(cmdc~=0,cmw~=0),iter>0)
      bsigx = wdc_b(gerjoii_.wdc.xss_wdc.h,gerjoii_.wdc.xss_wdc.d,as(1,2,2),...
                as(1,2,iter+1),as(1,1,iter+1));
      % b=0.5;
      bsigx_ = [bsigx_ bsigx];
      fprintf(' bs=%2.2d\n\n',bsigx);
      % dsigmx makes sigma_w look like sigma_dc 
      [sigmx,dsigmx] = wdc_xgrad_(parame_.dc.sigma.',parame_.w.sigma,gerjoii_);
      gerjoii_.wdc.dsigmx = bsigx*dsigmx;
      % clean
      clear sigmx dsigmx
    end
  end
  % ............................................................................
  % join gerjoii_.wdc.dsigmx_ and gerjoii_.wdc.dsigmx
  % ............................................................................
  if and(strcmp(gerjoii_.wdc.xse_ww_,'YES'),strcmp(gerjoii_.wdc.xss_wdc_,'YES'))
    gerjoii_.wdc.dsigmx = (gerjoii_.wdc.dsigmx+gerjoii_.wdc.dsigmx_)*0.5;
    gerjoii_.wdc.sig_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xse_ww_,'NO'),strcmp(gerjoii_.wdc.xss_wdc_,'YES'))
    gerjoii_.wdc.dsigmx = gerjoii_.wdc.dsigmx;
    gerjoii_.wdc.sig_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xse_ww_,'YES'),strcmp(gerjoii_.wdc.xss_wdc_,'NO'))
    gerjoii_.wdc.dsigmx = gerjoii_.wdc.dsigmx_;
    gerjoii_.wdc.sig_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xse_ww_,'NO'),strcmp(gerjoii_.wdc.xss_wdc_,'NO'))
    gerjoii_.wdc.dsigmx = zeros(size(parame_.w.sigma));
    gerjoii_.wdc.sig_too = 'NO';
  end
  % ............................................................................
  % conductivity (w)
  % ............................................................................
  if gerjoii_.w.g_s_weights(2) == 0
    gerjoii_ = w_update_s_(geome_,parame_,finite_,gerjoii_);
  else
    gerjoii_ = w_updateOBJ_s_(geome_,parame_,finite_,gerjoii_);
  end
  fprintf('\n just computed dsigma_w');
  % ............................................................................
  % joint update conductivity (average sum of gradients)
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
  if isfield(gerjoii_.wdc,'step_')
    step_ = gerjoii_.wdc.step_;
  else
    step_ = 1;
  end
  [gerjoii_.wdc.dsigma,a_] = wdce_dsigma(gerjoii_.w.dsigma,...
                                        gerjoii_.dc.dsigma,...
                                        gerjoii_.wdc.h_w*gerjoii_.w.Es_,...
                                        gerjoii_.dc.E_,step_);
  % ............................................................................
  % filter update
  ax = gerjoii_.w.regu.ax; az = gerjoii_.w.regu.az;
  gerjoii_.wdc.dsigma = image_gaussian(full(gerjoii_.wdc.dsigma),...
                                        ax,az,'LOW_PASS');
  % ............................................................................
  % save a's & Es's
  % first row a, second row Es's
  fprintf(' aw=%2.2d , adc=%2.2d\n',a_(1),a_(2)); 
  b = a_(2)/a_(1);
  a_ = [a_ ; gerjoii_.w.Es_,gerjoii_.dc.E_];
  as = cat(3,as,a_);
  % .......................
  % as = 
  %       [  aw   ,  adc  ]
  %       [  Ews  ,  Edc  ]
  % ............................................................................
  % conductivity (w) updating
  % ............................................................................
  parame_.w.sigma = parame_.w.sigma .* ...
                      exp(parame_.w.sigma .* gerjoii_.wdc.dsigma);
  fprintf('\n         max sig_w = %d',    max(parame_.w.sigma(:)) );
  fprintf('\n         min sig_w = %d\n\n',min(parame_.w.sigma(:)));
  % ............................................................................
  % xgrad: make epsi look like sigm_w (w)
  % ............................................................................
  if strcmp(gerjoii_.wdc.xes_ww_,'YES')
    % make sure values are not flat
    cme = curva_mean(parame_.w.epsilon);
    cms = curva_mean(parame_.w.sigma);
    cme = mean(cme(:));
    cms = mean(cms(:));
    gerjoii_.wdc.depsi_ = zeros(size(parame_.w.epsilon));
    if and(cme~=0,cms~=0)
      b = wdc_b(gerjoii_.wdc.xes_ww.h,gerjoii_.wdc.xes_ww.d,as(1,2,2),...
                as(1,2,iter+1),as(1,1,iter+1));
      % b=0.5;
      b_ = [b_ b];
      fprintf(' be=%2.2d\n\n',b);
      % depsix makes epsilon look like sigma_w
      [epsix,depsix] = wdc_xgrad(parame_.w.epsilon,parame_.w.sigma,gerjoii_);
      gerjoii_.wdc.depsi_ = b*depsix;
      % clean
      clear epsix depsix
    end
  end
  % ............................................................................
  % xgrad: make epsi look like sigm_dc (wdc)
  % ............................................................................
  if strcmp(gerjoii_.wdc.xes_wdc_,'YES')
    % make sure values are not flat
    cme = curva_mean(parame_.w.epsilon);
    cms = curva_mean(parame_.dc.sigma.');
    cme = mean(cme(:));
    cms = mean(cms(:));
    gerjoii_.wdc.depsi = zeros(size(parame_.w.epsilon));
    if and(cme~=0,cms~=0)
      b = wdc_b(gerjoii_.wdc.xes_wdc.h,gerjoii_.wdc.xes_wdc.d,as(1,2,2),...
                as(1,2,iter+1),as(1,1,iter+1));
      % b=0.5;
      b_ = [b_ b];
      fprintf(' be=%2.2d\n\n',b);
      % depsix makes epsilon look like sigma_dc
      [epsix,depsix] = wdc_xgrad(parame_.w.epsilon,parame_.dc.sigma.',gerjoii_);
      gerjoii_.wdc.depsi = b*depsix;
      % clean
      clear epsix depsix
    end
  end
  % ............................................................................
  %
  % ............................................................................
  if and(strcmp(gerjoii_.wdc.xes_ww_,'YES'),strcmp(gerjoii_.wdc.xes_wdc_,'YES'))
    gerjoii_.wdc.depsi = (gerjoii_.wdc.depsi+gerjoii_.wdc.depsi_)*0.5;
    gerjoii_.wdc.eps_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xes_ww_,'NO'),strcmp(gerjoii_.wdc.xes_wdc_,'YES'))
    gerjoii_.wdc.depsi = gerjoii_.wdc.depsi;
    gerjoii_.wdc.eps_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xes_ww_,'YES'),strcmp(gerjoii_.wdc.xes_wdc_,'NO'))
    gerjoii_.wdc.depsi = gerjoii_.wdc.depsi_;
    gerjoii_.wdc.eps_too = 'YES';
  elseif and(strcmp(gerjoii_.wdc.xes_ww_,'NO'),strcmp(gerjoii_.wdc.xes_wdc_,'NO'))
    gerjoii_.wdc.depsi = zeros(size(parame_.w.epsilon));
    gerjoii_.wdc.eps_too = 'NO';
  end
  % ............................................................................
  % permittivity
  % ............................................................................
  if gerjoii_.w.g_e_weights(2) == 0
    gerjoii_ = w_update_e_(geome_,parame_,finite_,gerjoii_);
  else
    gerjoii_ = w_updateOBJ_e_(geome_,parame_,finite_,gerjoii_);
  end
  fprintf('\n just computed depsilon');
  fprintf('\n --------------------------')
  fprintf('\n      Ew,e = %2.2d',gerjoii_.w.Ee_)
  fprintf('\n --------------------------\n')
  % ............................................................................
  % permittivity (w) updating
  % ............................................................................
  parame_.w.epsilon = parame_.w.epsilon .* ...
                      exp(parame_.w.epsilon.*gerjoii_.w.depsilon);
  fprintf('\n         max epsi= %d',    max(parame_.w.epsilon(:)) );
  fprintf('\n         min epsi= %d\n\n',min(parame_.w.epsilon(:)));
  % ............................................................................
  % get obj fnc
  % ............................................................................
  Ee = [Ee gerjoii_.w.Ee_];
  % ............................................................................
  % save updates (conductivity)
  % ............................................................................
  if strcmp(gerjoii_.wdc.save_dsigs,'YES')
    wdcsig = gerjoii_.wdc.dsigma;
    wdsig  = gerjoii_.w.dsigma;
    dcdsig = gerjoii_.dc.dsigma;
    sigm_w = parame_.w.sigma;
    sigm_dc= parame_.dc.sigma;
    name = strcat(data_pathsigs_,'dcdsig',num2str( iter ),'.mat');
    save( name , 'dcdsig' );
    name = strcat(data_pathsigs_,'wdsig',num2str( iter ),'.mat');
    save( name , 'wdsig' );
    name = strcat(data_pathsigs_,'wdcsig',num2str( iter ),'.mat');
    save( name , 'wdcsig' );
    name = strcat(data_pathsigs_,'sigm_w',num2str( iter ),'.mat');
    save( name , 'sigm_w' );
    name = strcat(data_pathsigs_,'sigm_dc',num2str( iter ),'.mat');
    save( name , 'sigm_dc' );
    clear wdcsig wdsig dcdsig sigm_w sigm_dc;
  end
  % ............................................................................
  % save updates (permittivity)
  % ............................................................................
  if strcmp(gerjoii_.wdc.save_deps,'YES')
    depsi = gerjoii_.w.depsilon;
    name  = strcat(data_patheps_,'depsi',num2str( iter ),'.mat');
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
