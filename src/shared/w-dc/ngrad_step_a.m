function step_a = ngrad_step_a(a,b,ga,Ea,ka)
% 
% Ea is with ka=0.
Ea_=zeros(numel(ka),1);
% ------------------------------------------------------------------------------
for i_=1:numel(ka)
% fwd & obj fnc (sum of squares)
a_ = a - ka(i_)*ga;
Ea__ = ngrad2d(a_,b);
Ea__ = sum(Ea__(:).^2) / numel(Ea__);
Ea_(i_) = Ea__;
end
% ------------------------------------------------------------------------------
% bundle
Ea_ = [Ea;Ea_]; Ea = Ea_;
ka = [0;ka];
% ------------------------------------------------------------------------------
% parabola approx
p = polyfit(ka,Ea,2);
% find zero of parabola (update = -step*gradient)
step_a = -p(2)/(2*p(1));
% ------------------------------------------------------------------------------
% print funny stuff
if or(isnan(step_a),step_a==0)
  % the parabola is actually a line
  fprintf('    step a is zero or nan = %2.2d\n',step_a);
  fprintf('    your inversion is pretty screwed, lol\n');
  fprintf('    try changing percentages of step-sizes. parabola is flat :(\n');
  step_a = 0;
end
if step_a<0
  % the parabola is skewed to the negative side
  fprintf('    step a is negative = %2.2d\n',step_a);
  fprintf('    try changing percentages of step-sizes and look at parabola\n');
  step_a = 0;
else
  fprintf('    step a %2.2d\n', step_a );
end
end