function sR = w_dsr(s,r)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% computes distance from source to receivers
%
% s are binned-real coordinates of source.
% x and z are discretized versions of axis.
sx=s(1);
sz=s(2);
% -
rx=r(:,1);
rz=r(:,2);
% -
srX = rx - sx;
srZ = rz - sz;
% -
sR = sqrt( srX.^2 + srZ.^2 );
end