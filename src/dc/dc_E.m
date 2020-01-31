function Edc = dc_E(d_o,d,Ndc,obj_fnc)
d=d(:); d_o=d_o(:);
if strcmp(obj_fnc,'env_L22')
  d   = d.^2; 
  d_o = d_o.^2;
elseif strcmp(obj_fnc,'env_LOG')
  d   = log(d); 
  d_o = log(d_o);
end
e_=double(d-d_o);
Edc = 0.5 * e_.' * Ndc * e_;
end