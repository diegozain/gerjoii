function step_b = cross_step_b(a,b,gb,Eb,kb,no_print)
% 
% Eb is with kb=0.
Eb_=zeros(numel(kb),1);
% ------------------------------------------------------------------------------
for i_=1:numel(kb)
  % fwd & obj fnc (sum of squares)
  b_ = b - kb(i_)*gb;
  % b_ = b.*exp(-b.*kb(i_).*gb);
  Eb__ = cross2d(a,b_);
  Eb__ = sum(Eb__(:).^2) / numel(Eb__);
  Eb_(i_) = Eb__;
end
% ------------------------------------------------------------------------------
% bundle
Eb_ = [Eb;Eb_]; Eb = Eb_;
kb = [0;kb];
% ------------------------------------------------------------------------------
% parabola approx
p = polyfit(kb,Eb,2);
% find zero of parabola (updbte = -step*gradient)
step_b = -p(2)/(2*p(1));
% ------------------------------------------------------------------------------
% print funny stuff
if nargin<6
if or(isnan(step_b),step_b==0)
  % the parabola is actually b line
  fprintf('    step b is zero or nan = %2.2d\n',step_b);
  fprintf('    your inversion is pretty screwed, lol\n');
  fprintf('    try changing percentages of step-sizes. parabola is flat :(\n');
  step_b = 0;
end
if step_b<0
  % the parabola is skewed to the negbtive side
  fprintf('    step b is negbtive = %2.2d\n',step_b);
  fprintf('    try changing percentages of step-sizes and look at parabola\n');
  step_b = 0;
else
  fprintf('    step b %2.2d\n', step_b );
end
end
end