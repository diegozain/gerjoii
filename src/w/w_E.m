function Ew = w_E(d_o,d,Nw,obj_fnc)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% compute objective function value
% ..............................................................................
d=d(:); d_o=d_o(:);
if strcmp(obj_fnc,'env_L22')
  d   = d.^2; 
  d_o = d_o.^2;
elseif strcmp(obj_fnc,'env_LOG')
  d   = log(d); 
  d_o = log(d_o);
end
e_=double(d-d_o);
Ew = 0.5 * e_.' * Nw * e_;
end