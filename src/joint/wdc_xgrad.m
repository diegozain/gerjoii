function [a,da] = wdc_xgrad(a,b,gerjoii_)
[nz,nx] = size(a);
[Dz,Dx] = Dx_Dz(nz,nx);
% ------------------------------------------------------------------------------
ni  = gerjoii_.wdc.deps.ni;
tol = gerjoii_.wdc.deps.tol;
ka  = gerjoii_.wdc.deps.ka;
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
% ------------------------------------------------------------------------------
[a,da] = cross_a(a,b,ni,tol,ka,Dx,Dz,ax,az);
% ------------------------------------------------------------------------------
da = -normali(da);
end