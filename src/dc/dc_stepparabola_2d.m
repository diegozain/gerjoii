function step_ = dc_stepparabola_2d(geome_,parame_,finite_,gerjoii_,Edc)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% find bounds for perturbations
% left side of parabola
bwd_fwd = 1; % -1: positive k. 1: negative k.
k_ = -bwd_fwd * dc_boundstep2(parame_.dc.sigma,bwd_fwd*gerjoii_.dc.g_2d,...
                  gerjoii_.dc.regu.sig_max_ ,gerjoii_.dc.regu.sig_min_,...
                  gerjoii_.dc.k_s);
k_ = gerjoii_.dc.kprct_*k_;
% right side of parabola
k__ = dc_boundstep2(parame_.dc.sigma,-gerjoii_.dc.g_2d,...
                  gerjoii_.dc.regu.sig_max_ ,gerjoii_.dc.regu.sig_min_,...
                  gerjoii_.dc.k_s);
k__ = gerjoii_.dc.kprct__*k__;
% ------------------------------------------------------------------------------
% get obj values
% Edc is with k=0
k_  = linspace(k_,k__,3).';
Edc_=zeros(numel(k_),1);
for i_=1:numel(k_)
  % fwd & obj fnc
  Edc_(i_) = dc_objs_2d(geome_,parame_,finite_,gerjoii_,k_(i_));
end
% ------------------------------------------------------------------------------
% bundle together
Edc = [Edc ; Edc_];
k = [0 ; k_];
k = double(k); Edc = double(Edc);
% ------------------------------------------------------------------------------
% parabola approx
warning off;
p_dc = polyfit(k,Edc,2);
warning on;
% find zero of parabola (update = -step*gradient)
step_ = -p_dc(2)/(2*p_dc(1));
% ------------------------------------------------------------------------------
if or(isnan(step_),step_==0)
  k   = full(k); 
  Edc = full(Edc);
  p_dc= full(p_dc);
  % the parabola is actually a line
  fprintf('\n    step sigdc is zero or nan = %2.2d\n',step_);
  fprintf('    your inversion is pretty screwed, lol\n');
  fprintf('    try changing percentages of step-sizes. parabola is flat :(\n');
  fprintf('         k  =[%2.2d, %2.2d, %2.2d];\n', k(1),k(2),k(end) );
  fprintf('         Edc=[%2.2d, %2.2d, %2.2d];\n', Edc(1),Edc(2),Edc(end) );
  fprintf('         pdc=[%2.2d, %2.2d, %2.2d];\n\n', p_dc(1),p_dc(2),p_dc(end));
  step_ = 0;
end
if step_<0
  k   = full(k); 
  Edc = full(Edc);
  p_dc= full(p_dc);
  % the parabola is skewed to the negative side
  fprintf('\n    step sigdc is negative = %2.2d\n',step_);
  fprintf('    try changing percentages of step-sizes and look at parabola\n');
  fprintf('         k  =[%2.2d, %2.2d, %2.2d];\n', k(1),k(2),k(end) );
  fprintf('         Edc=[%2.2d, %2.2d, %2.2d];\n', Edc(1),Edc(2),Edc(end) );
  fprintf('         pdc=[%2.2d, %2.2d, %2.2d];\n', p_dc(1),p_dc(2),p_dc(3));
  fprintf('         hold on;\n');
  fprintf('         plot(k,Edc,''.'',''markersize'',30);\n');
  fprintf('         plot(linspace(min(k),max(k),1e+3),...\n');
  fprintf('         polyval(p_dc,linspace(min(k),max(k),1e+3)))\n\n');
  step_ = 0;
end
end