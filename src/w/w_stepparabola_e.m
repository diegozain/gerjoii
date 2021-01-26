function step_w_e = w_stepparabola_e(geome_,parame_,finite_,gerjoii_,Ee)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% find bounds for perturbations
% left side of parabola
bwd_fwd = 1; % -1: positive ke. 1: negative ke.
ke_ = -bwd_fwd * w_boundstep2(parame_.w.epsilon,bwd_fwd*gerjoii_.w.g_e,...
                  gerjoii_.w.regu.eps_max_ ,gerjoii_.w.regu.eps_min_,...
                  gerjoii_.w.k_e);
ke_ = ke_*gerjoii_.w.keprct_;
% right side of parabola
ke__ = w_boundstep2(parame_.w.epsilon,-gerjoii_.w.g_e,...
                  gerjoii_.w.regu.eps_max_ ,gerjoii_.w.regu.eps_min_,...
                  gerjoii_.w.k_e);
ke__ = ke__*gerjoii_.w.keprct__;
% ------------------------------------------------------------------------------
% get obj values
% Ee is with ke=0.
ke = linspace(ke_,ke__,gerjoii_.w.nparabo).';
Ee_=zeros(numel(ke),1);
for i_=1:numel(ke)
  % fwd & obj fnc
  if isfield(gerjoii_.w,'AWI')==1
    Ee_(i_)   = w_objsAWI_e(geome_,parame_,finite_,gerjoii_,ke(i_));
  else
    Ee_(i_)   = w_objs_e(geome_,parame_,finite_,gerjoii_,ke(i_));
  end
end
% ------------------------------------------------------------------------------
% bundle together
Ee = [Ee ; Ee_];
ke = [0  ; ke];
ke = double(ke); Ee = double(Ee);
% ------------------------------------------------------------------------------
% parabola approx
warning off;
p_e = polyfit(ke,Ee,2);
warning on;
% find zero of parabola (update = -step*gradient)
step_w_e = -p_e(2)/(2*p_e(1));
% ------------------------------------------------------------------------------
if or(isnan(step_w_e),step_w_e==0)
  % the parabola is actually a line
  fprintf('    step eps is zero or nan = %2.2d\n',step_w_e);
  fprintf('    your inversion is pretty screwed, lol\n');
  fprintf('    try changing percentages of step-sizes. parabola is flat :(\n');
  fprintf('         ke=[%2.2d, %2.2d, %2.2d];\n', ke(1),ke(2),ke(end) );
  fprintf('         Ee=[%2.2d, %2.2d, %2.2d];\n', Ee(1),Ee(2),Ee(end) );
  fprintf('         pe=[%2.2d, %2.2d, %2.2d];\n', p_e(1),p_e(2),p_e(3));
  step_w_e = 0;
end
if step_w_e<0
  % the parabola is skewed to the negative side
  fprintf('    step eps is negative = %2.2d\n',step_w_e);
  fprintf('    try changing percentages of step-sizes and look at parabola\n');
  fprintf('         ke=[%2.2d, %2.2d, %2.2d];\n', ke(1),ke(2),ke(end) );
  fprintf('         Ee=[%2.2d, %2.2d, %2.2d];\n', Ee(1),Ee(2),Ee(end) );
  fprintf('         pe=[%2.2d, %2.2d, %2.2d];\n', p_e(1),p_e(2),p_e(3));
  fprintf('         hold on;\n');
  fprintf('         plot(ke,Ee,''.'',''markersize'',30);\n');
  fprintf('         plot(linspace(min(ke),max(ke),1e+3),...\n');
  fprintf('         polyval(pe,linspace(min(ke),max(ke),1e+3)))\n');
  step_w_e = 0;
else
  fprintf('    step eps %2.2d\n', step_w_e );
end
end