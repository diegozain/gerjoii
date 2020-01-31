function [a,da] = cross_a(a,b,ni,tol_,ka,Dx,Dz,ax,az)
no_print = 0;
step_a = 1;
da_ = zeros(size(a));
Ja = crossJa(b,Dx,Dz);
Ea = Inf;
i_=0;
while (Ea>tol_ & i_<ni)
  % fwd & error
  xab_ = cross2d(a,b,Dx,Dz);
  % gradient a
  ga = Ja*xab_(:);
  % ----------------------------
  % hessian
  % ----------------------------
  % wanna filter?
  if nargin>7
    ga = reshape(ga,size(a));
    ga = image_gaussian(ga,ax,az,'LOW_PASS');
    ga = ga(:);
  end
  ga = normali(ga);
  % sum update
  ga = (Ja*Ja.' + step_a*speye(numel(a)))\ga;
  % % exponential update
  % ga = (Ja*Ja.' + (9) * speye(numel(a)))\ga;
  % ----------------------------
  ga = reshape(ga,size(a));
  % wanna filter?
  if nargin>7
    ga = image_gaussian(ga,ax,az,'LOW_PASS');
    ga = normali(ga);
  end
  % obj fnc
  Ea = sum(xab_(:).^2) / numel(xab_);
  % step size ga
  step_a = cross_step_a(a,b,ga,Ea,ka,no_print);
  da = -step_a*ga;
  % ----------------------------
  % update by ga
  % ----------------------------
  % sum update
  a = a+da;
  % % exponential update
  % a = a.*exp(a.*da);
  da_ = da_ + da;
  % iter
  i_=i_+1;
  % --------------------------
  if mod(i_,fix(ni*0.1))==1
    fprintf('       xgrad error %2.2d at iteration %i\n',Ea,i_);
  end
end
da=da_;
end