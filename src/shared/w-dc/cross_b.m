function [b,db] = cross_b(a,b,ni,tol_,kb,Dx,Dz,ax,az)
no_print = 0;
step_b = 1;
db_ = zeros(size(b));
Jb = crossJb(a,Dx,Dz);
Eb = Inf;
i_=0;
while (Eb>tol_ & i_<ni)
  % fwd & error
  xab_ = cross2d(a,b,Dx,Dz);
  % gradient b
  gb = Jb*xab_(:);
  % ----------------------------
  % hessian
  % ----------------------------
  % wanna filter?
  if nargin>7
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
  if nargin>7
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
  % iter
  i_=i_+1;
  % --------------------------
  if mod(i_,fix(ni*0.1))==1
    fprintf('       xgrad error %2.2d at iteration %i\n',Eb,i_);
  end
end
db=db_;
end