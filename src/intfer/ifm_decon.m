function [BAf_,t_decon,Ba] = ifm_decon(Bs,As,c,f,dt,a)
% ---------------
% Bs: shot gather with sources s and receivers b
% As: shot gather with sources s and receivers a (could be == Bs)
% c: indicies of receivers (could be == 1:nr)
% f: range of frequencies to do
% dt: obvious.
% ---------------
% BAf_: cube of size (nf x nb x na).
%       virtual gather Ba (in the frequency domain) is BAf_(:,:,a).
% t_decon: deconvolution time of size 2t+1.
% ---------------
[nt,nb,~] = size(Bs);
na = size(As,2);
nt_xc = 2*nt-1;
nt_0 = nt;
nf = numel(f);
nc = numel(c);
BA_ = zeros(nf,nb,na);
for fi=1:nf
  BC_ = zeros(nb,nc);
  AC_ = zeros(na,nc);
  for ic=1:nc
    % ------ Bc ----------
    % interferate by xcorr
    Bc = ifm_xcorr(Bs,c(ic),dt);
    % fold Bc on time
    Bc = 0.5*(Bc(nt:nt_xc,:) + flip(Bc(1:(nt_0-1)),1));
    % transform Bc to the frequency domain column-wise -> Bc_
    [Bc,f_Bc,df] = fourier_rt(Bc,dt);
    % pick row corresponding to picked frequency ( f(fi) ) and,
    % put this row as column of BC_(:,ic)
    BC_(:,ic) = Bc(binning(f_Bc,f(fi)),:).';
    % ------ Ac ----------
    % interferate by xcorr
    Ac = ifm_xcorr(As,c(ic),dt);
    % fold Ac on time
    Ac = 0.5*(Ac(nt:nt_xc,:) + flip(Ac(1:(nt_0-1)),1));
    % transform Bc to the frequency domain column-wise -> Bc_
    [Ac,f_Ac,df] = fourier_rt(Ac,dt);
    % pick row corresponding to picked frequency ( f(fi) ) and,
    % put this row as column of AC_(:,ic)
    AC_(:,ic) = Ac(binning(f_Ac,f(fi)),:).';
  end
  % % regularize AC_
  % AC_ = AC_ + regu*eye(na,nc);
  % solve for one frequency & sore
  BA_ = AC_\BC_;
  BAf_(fi,:,:) = BA_;
end
% decon time interval
t_decon = dt*[(-nt_:-1) (0:nt_)];
% ---------------
% give shot gather for specific a
if nargin > 5
  % pick plane a on Ba_ = BAf_(:,:,a)
  Ba = squeeze(BAf_(:,:,a));
  % ifft on Ba_ (= Ba)
  Ba = ifft(Ba,[],1);
else
  Ba='i am empty';
end
end