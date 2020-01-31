function a = roughen2d(a,ax,az)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% to smooth within a wavelength lo,
% ax=1/lo; az=1/lo;
% ax=ax*dx;
% az=az*dz;
[nz,nx] = size(a);
% add 25% to sides so smoother doesn't artifact
nx_=fix(nx*0.25);
nz_=fix(nz*0.25);
% left/right
a=[repmat(a(:,1),[1,nx_]) , a , repmat(a(:,nx),[1,nx_])];
% top/bottom
a=[repmat(a(1,:),[nz_,1]) ; a ; repmat(a(nz,:),[nz_,1])];
% filter
a = image_gaussian(a,ax,az,'HI_PASS');
% crop down
a = a( (nz_+1):(nz_+nz),(nx_+1):(nx_+nx) );
end