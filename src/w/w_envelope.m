function g = w_envelope(g)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% get envelope of g (i think this is not used anywhere, lol)
% ..............................................................................
% this works better IF
% g has as many negative 
% as positive amplitudes.
g_ = envelope_(g); 
g__ = envelope_(-g);
g = 0.5*(g_+g__);
end