function step_w_s = w_stepparabola_s(geome_,parame_,finite_,gerjoii_,Es)
% diego domenzain.
% boise state university, 2018.
% ----------------------------------------------------------------------------
% find bounds for perturbations
% left side of parabola
bwd_fwd = -1; % -1: positive ks. 1: negative ks.
ks_ = -bwd_fwd * w_boundstep2(parame_.w.sigma,bwd_fwd*gerjoii_.w.g_s,...
                  gerjoii_.w.regu.sig_max_ , gerjoii_.w.regu.sig_min_,...
                  gerjoii_.w.k_s);
ks_ = ks_*gerjoii_.w.ksprct_;
% right side of parabola
ks__ = w_boundstep2(parame_.w.sigma,-gerjoii_.w.g_s,...
                  gerjoii_.w.regu.sig_max_ , gerjoii_.w.regu.sig_min_,...
                  gerjoii_.w.k_s);
ks__ = ks__*gerjoii_.w.ksprct__;
% ------------------------------------------------------------------------------
% get obj values
% Es is with ks=0.
ks = linspace(ks_,ks__,gerjoii_.w.nparabo+2).';
Es_=zeros(numel(ks),1);
for i_=1:numel(ks)
  % fwd & obj fnc
  Es_(i_)   = w_objs_s(geome_,parame_,finite_,gerjoii_,ks(i_));
end
% ------------------------------------------------------------------------------
% bundle together
Es = [Es ; Es_];
ks = [0  ; ks];
ks = double(ks); Es = double(Es);
% ------------------------------------------------------------------------------
% parabola approx
p_s = polyfit(ks,Es,2);
% find zero of parabola (update = -step*gradient)
step_w_s = -p_s(2)/(2*p_s(1));
% ------------------------------------------------------------------------------
if or(isnan(step_w_s),step_w_s==0)
  % the parabola is actually a line
  step_w_s = 0;
  fprintf('    step sig ks=[%2.2d, %2.2d, %2.2d]\n', ks(1),ks(2),ks(3) );
  fprintf('    step sig Es=[%2.2d, %2.2d, %2.2d]\n', Es(1),Es(2),Es(3) );
  fprintf('    step sig ps=[%2.2d, %2.2d, %2.2d]\n', p_s(1),p_s(2),p_s(3));
end
if step_w_s<0
  fprintf('    step sig ks=[%2.2d, %2.2d, %2.2d]\n', ks(1),ks(2),ks(3) );
  fprintf('    step sig Es=[%2.2d, %2.2d, %2.2d]\n', Es(1),Es(2),Es(3) );
end
fprintf('    step sig %2.2d\n', step_w_s );
end