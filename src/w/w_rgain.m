function g = w_rgain(g,x,z,s,lo,pow_)
% s(2) = s(2)-parame_.w.pjs; % ix
% s(1) = s(1)-parame_.w.pis-parame_.w.air+1; % iz
nx = numel(x);
nz = numel(z);
X = repmat(x,nz,1);
Z = repmat(z.',1,nx);
pow_ = pow_-1;
% lo = 2*lo;
% f = ((X-x(s(2)))/lo).^2 + ((Z-z(s(1)))/lo).^2;
% f = 1-exp(-f);
r = sqrt( (X-x(s(2))).^2 + (Z-z(s(1))).^2 ).^pow_;
% g = (1 + f.*r) .* g;
g = (1+r) .* g;
end
% x=(0:0.0213:20);z=(0:0.0213:4);s=[1,400];g=rand(numel(z),numel(x));
% lo=0.6;pow_=3;
% figure;imagesc(x,z,w_rgain(g,x,z,s,lo,pow_));axis image;colorbar;colormap(jet)
%figure;surf(x,z,w_rgain(g,x,z,s,lo,pow_));colorbar;colormap(jet);shading interp