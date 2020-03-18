function Lfo = Lfo_radon(x,sx,fo)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% discretizes
%
% d(x,fo) = sum( exp(...) * p(slow,fo) )_{slow_min,slow_max}
% 
% as 
%
% d = Lfo * p, Lfo = Lfo(x,slow,fo)
% to w space
%
if size(x,2)==1
	x=x.';
end
% ..............................................................................
wo = 2*pi*fo;
% ..............................................................................
% build k space using outer product
%
t_shift = 1i*wo * (x.' * sx);
% ..............................................................................
% build Lfo
%
Lfo = exp(t_shift);
end