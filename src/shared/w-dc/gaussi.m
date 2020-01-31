function g = gaussi(x,z,s,lo,pow_)
% ------------------------------------------------------------------------------
% do a 2d gaussian on (x,z) centered at s=(iz,ix) of 
% width lo and steepness pow_.
% ------------------------------------------------------------------------------
% NOTE: maybe s should be in real coordinates rather than in indicies.
% s(2) = s(2)-parame_.w.pjs; % ix
% s(1) = s(1)-parame_.w.pis-parame_.w.air+1; % iz
% ------------------------------------------------------------------------------
nx = numel(x); nz = numel(z);
X = repmat(x,nz,1); Z = repmat(z.',1,nx);
lo = 2*lo;
g = ((X-x(s(2)))/lo).^2 + ((Z-z(s(1)))/lo).^2;
g = 1-exp(-g);
% ------------------------------------------------------------------------------
g=normali(g);
end