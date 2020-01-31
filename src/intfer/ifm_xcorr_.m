function [Ba, cg_a, t_corr] = ifm_xcorr_(Bs,a,dt)
% ---------------
% Bs: shot gather with sources s and receivers b
% a: index of receiver a
% dt: obvious.
% ---------------
% Ba: shot gather with source a and receivers b
% cg_a: correlation gather with source a and receivers b
% t_corr: correlation time of size 2t-1.
% ---------------
[nt_,nr,ns] = size(Bs);
% virtual shot gather
Ba = zeros((2*nt_-1)*nr,ns);
% correlation gather
cg_a = zeros(2*nt_-1,ns);
% loop through sources (or time slices) and stack...
% but in parallel because we can, and we're cool.
parfor is=1:ns
	Bs_ = squeeze(Bs(:,:,is));
	% virtual receiver: source a & receiver b ( b<-a )
	Bs_as = xcorr2( Bs_ , Bs_(:,a) );
	Ba(:,is) = Bs_as(:);
	% correlation gather
	cg_a(:,is) = Bs_as(:,a);
end
% stack
Ba = sum(Ba,2);
Ba = reshape(Ba,[2*nt_-1,nr]);
% xcorr time interval
t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];
end