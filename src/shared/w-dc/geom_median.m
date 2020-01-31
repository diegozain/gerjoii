function y = geom_median(r,guess)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% calculate geometric median from set of points r.
% r has as many points as rows.
%
% uses Weiszfeld's algorithm, 
% which is just a potential energy minimizer.
y = guess;
nr = length(r(:,1));
if nr==2
  y = 0.5*[abs(r(1,1)-r(2,1)) abs(r(1,2)-r(2,2))];
  return; 
elseif nr==1
  y = r;
  return;
end
numerator = 0;
denominator = 0;
iter = 0;
c_ = 0;
c__ = Inf;
while (c__ > 1e-12 & iter < 1e+4)
  c = 0;
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