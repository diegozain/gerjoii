% ---------------------------
% compute jacobian of xgrad
% ---------------------------
a=epsi;
b=sigm;
dep=depsi;
a=normali(a);
b=normali(b);
dep=normali(dep);
% ------------------------------------------------------------------------------
figure;
subplot(2,1,1)
fancy_imagesc(a,x,z)
set(gca,'YTick',[])
set(gca,'XTick',[])
title('a')
simple_figure()
subplot(2,1,2)
fancy_imagesc(b,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('b')
simple_figure()
% ------------------------------------------------------------------------------
% compute xgradient
[nz,nx] = size(a);
[Dz,Dx] = Dx_Dz(nz,nx);
ab = ngrad2d(a,b);
% ------------------------------------------------------------------------------
Ja = ngradJa(a,Dx,Dz);
Jb = ngradJa(b,Dx,Dz);
J=Ja+Jb;
% ------------------------------------------------------------------------------
figure;
fancy_imagesc(ab,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('\tau');
simple_figure();
% ------------------------------------------------------------------------------
ga=Ja*ab(:);
ga = normali(ga);
ga=reshape(ga,size(a));
% ------------------------------------------------------------------------------
gb=Jb*ab(:);
gb = normali(gb);
gb=reshape(gb,size(a));
% ------------------------------------------------------------------------------
figure;
subplot(2,1,1)
fancy_imagesc(ga,x,z)
set(gca,'YTick',[])
set(gca,'XTick',[])
title('gradient \tau_a')
simple_figure()
subplot(2,1,2)
fancy_imagesc(gb,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('gradient \tau_b')
simple_figure()
% ------------------------------------------------------------------------------
% ka_ = -1*1e+3;
% ka__=  1*1e+3;
% ka = linspace(ka_,ka__,100).';
ka = [-1; 0; 1];
kb=ka;
Ea = zeros(numel(ka),1); Eb=Ea;
for i_=1:numel(ka)
  % fwd & obj fnc
  a_ = a - ka(i_)*ga;
  Ea_ = ngrad2d(a_,b,Dx,Dz);
  Ea_ = sum(Ea_(:).^2) / numel(Ea_);
  Ea(i_) = Ea_;
  % ---
  % fwd & obj fnc
  b_ = b - kb(i_)*gb;
  Eb_ = ngrad2d(a,b_,Dx,Dz);
  Eb_ = sum(Eb_(:).^2) / numel(Eb_);
  Eb(i_) = Eb_;
end
% parabola approx
p = polyfit(ka,Ea,2);
% find zero of parabola (update = -step*gradient)
step_a = -p(2)/(2*p(1));
% parabola approx
p = polyfit(kb,Eb,2);
% find zero of parabola (update = -step*gradient)
step_b = -p(2)/(2*p(1));
fprintf('  step size for a = %2.2d\n',step_a);
fprintf('  step size for b = %2.2d\n',step_b);
% ------------------------------------------------------------------------------
figure;
hold on
plot(ka,Ea,'k.-','markersize',30)
plot(kb,Eb,'r.-','markersize',30)
hold off
legend({'a','b'})
xlabel('Gradient perturbation value')
ylabel('Norm of xgradient')
title('Line search')
simple_figure()
%%{
% ------------------------------------------------------------------------------
da_ = zeros(size(a));
db_ = zeros(size(b));
ka = [-1; 1]*1e+3;
kb = [-1; 1]*1e+3;
ni = 5; % 100000;
tol_=1e-20;
tic;
[a_,b_,da_,db_] = ngrad_ab(a,b,ni,tol_,ka,kb,Dx,Dz);
% [a_,da_] = ngrad_a(a,b,ni,tol_,ka,Dx,Dz);
% [b_,db_] = ngrad_b(a,b,ni,tol_,kb,Dx,Dz);
toc;
% ------------------------------------------------------------------------------
figure;
subplot(2,1,1)
fancy_imagesc(a_,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('new a');
simple_figure();
subplot(2,1,2)
fancy_imagesc(b_,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
simple_figure();
title('new b');
% ------------------------------------------------------------------------------
figure;
subplot(2,1,1)
fancy_imagesc(a-a_,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('old a minus new a');
simple_figure();
subplot(2,1,2)
fancy_imagesc(b-b_,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
simple_figure();
title('old b minus new b');
% ------------------------------------------------------------------------------
figure;
subplot(2,1,1)
fancy_imagesc(da_,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('stack of a-updates');
simple_figure();
subplot(2,1,2)
fancy_imagesc(db_,x,z)
colormap(rainbow())
set(gca,'YTick',[])
set(gca,'XTick',[])
title('stack of b-updates');
simple_figure();
%%}

