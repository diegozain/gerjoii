function v = w_eps2v(epsi)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% go from relative 2d permittivity to velociy
% ..............................................................................
c = 0.299792; % [m/ns]
v = c ./ sqrt(epsi); % m/ns
end