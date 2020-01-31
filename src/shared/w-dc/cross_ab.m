function [a,b,da,db] = cross_ab(a,b,ni,tol_,ka,kb,Dx,Dz,ax,az)
no_print = 0;
step_a = 1;
step_b = 1;
da_ = zeros(size(a));
db_ = zeros(size(b));
E_ = Inf;
i_=0;
while (E_>tol_ & i_<ni)
  % ----------------------------------------------------------------------------
  %                     a
  % ----------------------------------------------------------------------------
  % fwd & error
  xab_ = cross2d(a,b,Dx,Dz);
  % gradient a
  Ja = crossJa(b,Dx,Dz);
  ga = Ja*xab_(:);
  % ----------------------------
  % hessian
  % ----------------------------
  % wanna filter?
  if nargin>8
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
  if nargin>8
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
  % ----------------------------------------------------------------------------
  %                     b
  % ----------------------------------------------------------------------------
  % fwd & error
  xab_ = cross2d(a,b,Dx,Dz);
  % gradient b
  Jb = crossJb(a,Dx,Dz);
  gb = Jb*xab_(:);
  % ----------------------------
  % hessian
  % ----------------------------
  % wanna filter?
  if nargin>8
    gb = reshape(gb,size(b));
    gb = image_gaussian(gb,ax,az,'LOW_PASS');
    gb = gb(:);
  end
  gb = normali(gb);
  % sum update
  gb = (Jb*Jb.' + step_b*speye(numel(b)))\gb;
  % % exponential update
  % gb = (Jb*Jb.' + (9) * speye(numel(b)))\gb;
  % ----------------------------
  gb = reshape(gb,size(b));
  % wanna filter?
  if nargin>8
    gb = image_gaussian(gb,ax,az,'LOW_PASS');
    gb = normali(gb);
  end
  % obj fnc
  Eb = sum(xab_(:).^2) / numel(xab_);
  % step size ga
  step_b = cross_step_b(a,b,gb,Eb,kb,no_print);
  db = -step_b*gb;
  % ----------------------------
  % update by gb
  % ----------------------------
  % sum update
  b = b+db;
  % % exponential update
  % b = b.*exp(b.*db);
  db_ = db_ + db;
  % --------------------------
  i_=i_+1;
  E_=0.5*(Ea+Eb);
  % --------------------------
  if mod(i_,fix(ni*0.1))==1
    fprintf('   xgrad error %2.2d at iteration %i\n',E_,i_);
  end
end
da=da_;
db=db_;
end