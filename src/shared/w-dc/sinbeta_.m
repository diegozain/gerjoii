function sinbeta = sinbeta_(x,z,s)
% diego domenzain
% fall 2017 @ TUDelft
% ------------------------------------------------------------------------------
% computes sin(beta) where beta is angle between 
% source location and point (x,z).
%
% s are binned coordinates of source.
% x and z are discretized versions of axis.

sx=s(1);
sz=s(2);

if size(x,1)==1
  x=x.';
end
if size(z,1)==1
  z=z.';
end

CO = z-z(sz);
CA = x-x(sx);

CO = repmat(CO, [1,numel(x)] );
CA = repmat(CA.', [numel(z),1] );

sinbeta = sin(CO./CA);

end

% TEST:
% close all
% clear all
% dx=0.1;dz=0.1;x=0:dx:10;z=0:dz:5;                         
% % s_real=[3,2.5];
% s_real=[3,0];
% sx=binning(x,s_real(1));sz=binning(z,s_real(2));s=[sx,sz];
% sinbeta = sinbeta_(x,z,s);
% figure;imagesc(x,z,sinbeta);axis image;colormap(jet);title('sine(beta)')
% 
% nx=numel(x);nz=numel(z);
% vz=4e-1*ones(nz,1);
% p = w_rayparam(x,z,s,sinbeta,vz);
% figure;imagesc(x,z,abs(p));axis image;colormap(jet); colorbar;title('abs(p)')


