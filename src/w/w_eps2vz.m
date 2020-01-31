function vz = w_eps2vz(epsilon_z)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% go from relative 2d permittivity to average velociy in depth
% ..............................................................................
[nz,nx] = size(epsilon_z);
c = 0.299792; % [m/ns]
v = c ./ sqrt(epsilon_z);
vz = (1/nx) * sum( v,2 );
end