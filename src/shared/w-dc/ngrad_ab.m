function [a,b,da,db] = ngrad_ab(a,b,ni,tol_,ka,kb,Dx,Dz)

da_ = zeros(size(a));
db_ = zeros(size(b));
E_ = Inf;
i_=0;
while (E_>tol_ & i_<ni)
  % fwd & error
  ab = ngrad2d(a,b,Dx,Dz);
  % gradient a
  Ja = ngradJa(a,Dx,Dz);
  ga = Ja*ab(:);
  ga = normali(ga);
  ga = reshape(ga,size(a));
  % obj fnc
  Ea = sum(ab(:).^2) / numel(ab);
  % step size ga
  step_a = ngrad_step_a(a,b,ga,Ea,ka);
  % update by ga
  da = -step_a*ga;
  a = a+da;
  da_ = da_ + da;
  % --------------------------
  % fwd & error
  ab = ngrad2d(a,b,Dx,Dz);
  % gradient b
  Jb = ngradJa(b,Dx,Dz);
  gb = Jb*ab(:);
  gb = normali(gb);
  gb = reshape(gb,size(a));
  % obj fnc
  Eb = sum(ab(:).^2) / numel(ab);
  % step size ga
  step_b = ngrad_step_b(a,b,gb,Eb,kb);
  % update by gb
  db = -step_b*gb;
  b = b+db;
  db_ = db_ + db;
  % --------------------------
  i_=i_+1;
  E_=0.5*(Ea+Eb);
  % --------------------------
  fprintf('\n   ngrad error %2.2d at iteration %i\n',E_,i_);
end
da=da_;
db=db_;
end