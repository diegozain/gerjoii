function gerjoii_ = dc_gradient_2d(parame_,finite_,gerjoii_)
  % robin
  robin = parame_.dc.robin;
  nx = finite_.dc.nx;
  nz = finite_.dc.nz;
  % compute gradient
  S = dc_S(parame_,finite_, gerjoii_.dc.u_2d );
  a = dc_adjoint( finite_.dc.L , gerjoii_.dc.M , gerjoii_.dc.e_2d );
  g = S * a;
  % reshape gradient
  g = reshape(g,[nx,nz]);
  g = g(1+robin:nx-robin,1:nz-robin);
  % store
  gerjoii_.dc.g_2d = g;
end