function gerjoii_ = dc_gradient2_5d(parame_,finite_,gerjoii_)

% robin
robin = parame_.dc.robin;
nx = finite_.dc.nx;
nz = finite_.dc.nz;
sigma_robin  = parame_.dc.sigma_robin;

% u = gerjoii_.dc.u;
u_k = gerjoii_.dc.u_k;
% e_ = gerjoii_.dc.e_;
% d = gerjoii_.dc.d;

n_ky = finite_.dc.n_ky;
ky_w_ = finite_.dc.ky_w_;

% compute each g_k_ independently (parfor-able)
g_k = zeros( nx*nz,n_ky );
for i_=1:n_ky
  % ----------------
  % compute gradient
  % ----------------
  % choose ky
  ky = ky_w_(i_,1);
  % build Lk = Lk_ + k^2 * sig
  finite_.dc.ky = ky;
  finite_ = dc_Lk(parame_,finite_,gerjoii_);
  Lk  = finite_.dc.Lk;
  % compute adjoint
  ak = dc_adjoint( Lk , gerjoii_.dc.M , gerjoii_.dc.e_ );
  % build Sk = Sk_ - k^2 * u_i
  Sk = dc_Sk( parame_,finite_, reshape(u_k(:,i_) , [nx,nz] ), ky );
  % compute ky gradient
  g_k(:,i_) = Sk * ak;
end
% weighted stack
g = (2/pi) * g_k * ky_w_(:,2);

% reshape gradient
g = reshape(g,[nx,nz]);
g = g(1+robin:nx-robin,1:nz-robin);

gerjoii_.dc.g = g;

% figure(10);
% fancy_imagesc(g.')
% pause;
end