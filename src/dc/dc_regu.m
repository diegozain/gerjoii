function gerjoii_ = dc_regu(geome_,finite_,gerjoii_)
  
  n = finite_.dc.nx;
  m = finite_.dc.nz;
  dx = geome_.dx;
  dz = geome_.dy;

  bo = gerjoii_.dc.bo;
  bx = gerjoii_.dc.bx;
  bz = gerjoii_.dc.bz;
  
  % [DDx,DDz] = DDx_DDz(n,m);
  % DDx = dx*DDx; DDz = dz*DDz;
  [Dx,Dz] = Dx_Dz(n,m);
  Dx=dx*Dx; Dz=dz*Dz;
  Id = speye(n*m);
  
  gerjoii_.dc.W = bo*Id + bx*Dx + bz*Dz;
  
end