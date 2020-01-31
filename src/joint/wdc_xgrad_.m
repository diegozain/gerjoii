function [b,db] = wdc_xgrad_(a,b,gerjoii_)
[nz,nx] = size(b);
[Dz,Dx] = Dx_Dz(nz,nx);
% ------------------------------------------------------------------------------
ni  = gerjoii_.wdc.deps.ni;
tol = gerjoii_.wdc.deps.tol;
kb  = gerjoii_.wdc.deps.kb;
ax = gerjoii_.w.regu.ax; 
az = gerjoii_.w.regu.az;
% ------------------------------------------------------------------------------
[b,db] = cross_b(a,b,ni,tol,kb,Dx,Dz,ax,az);
% ------------------------------------------------------------------------------
db = -normali(db);
end