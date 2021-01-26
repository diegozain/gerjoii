function y = geom_median(r,guess)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% calculate geometric median from set of points r.
% r has as many points as rows.
%
% uses Weiszfeld's algorithm, 
% which is just a potential energy minimizer.
nr = size(r,1);
% y = guess;
y = sum(r,1)/nr;
if nr==1
  y = r;
  return;
end
iter = 0;
c_ = 0;
c__ = Inf;
while (c__ > 1e-12 & iter < 1e+4)
  c = 0;
  numerator = 0;
  denominator = 0;
  for i = 1:nr
    norma = norm(r(i,:)-y);
    numerator = numerator + (r(i,:)/norma);
    denominator = denominator + (1/norma);
    c = c + norma;
  end
  y = numerator / denominator;
  c__ = abs(c-c_);
  c_ = c;
  iter = iter + 1;
end
end