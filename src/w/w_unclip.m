function do_ = w_unclip(do_,dt,f_,f__,nf,it_ini,it_end)
% diego domenzain
% 2021 @ Mines
% 
% unclip a trace by using its own frequency content.
% does not use common interpolation techniques.
% 
% inspired by,
% A Simple Algorithm for the Restoration of Clipped GPR amplitudes
% Akshay Gulati and Robert J. Ferguson
%
% that paper is pretty bad because it doesn't really explain what is what, 
% (see equation 1).
%
% this is my interpretation of it.
% ------------------------------------------------------------------------------
% do_ is the trace to unclip. Dimensions of time by receiver (nt x 1)
%
% example,
%
% dt=1;     % ns
% f_ = 0.01;% GHz
% f__= 0.1; % GHz
% nf = 10;  % number of frequency samples
% % clipping is done between it_ini and it_end
% it_ini = 60; % index number before where unclipping is wanted
% it_end = 300; % index number after where unclipping is wanted
% ------------------------------------------------------------------------------
f = linspace(f_,f__,nf);
f = f.';
% ------------------------------------------------------------------------------
% builds mask that chooses where new values are to be put.
mask_ = diff(do_);
mask_=[mask_;1];

mask_(mask_< 0)=2; 
mask_(mask_> 0)=2;
mask_(mask_==0)=1;
mask_(mask_==2)=0;

mask_(1:it_ini)  = 0;
mask_(it_end:end)= 0;

a = find(mask_);
mask_(a+1)=1;

mask_=find(mask_);
% ------------------------------------------------------------------------------
for i_f=1:nf 
 d_ = filt_gauss(do_,dt,-f(i_f),f(i_f),10);
 do_(mask_) = d_(mask_);
end
end

