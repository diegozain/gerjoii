function B = beamformer_thetav(fo,r,d_,f,v,theta)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
nfo = numel(fo);
nv = numel(v);
ntheta = numel(theta);
B = zeros( ntheta, nv , nfo);
for i=1:nfo
B(:,:,i) = beamformer_(fo(i),r,d_,f,v,theta);
end
B = sum(B,3);
end