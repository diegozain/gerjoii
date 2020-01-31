function [Ba, cg_a, t_corr] = ifm_xcorr(Bs,a,dt)
% ---------------
% Bs: shot gather with sources s and receivers b, size (time,recs,sources).
% a: index of receiver a to act as virtual source.
% dt: obvious.
% ---------------
% Ba: shot gather with source a and receivers b
% cg_a: correlation gather with source a and receivers b
% t_corr: correlation time of size 2t-1.
% ---------------
[nt_,nr,ns] = size(Bs);
% virtual shot gather
Ba = zeros(2*nt_-1,nr);
% correlation gather
cg_a = zeros(2*nt_-1,ns);
% loop through sources (or time slices) and stack
for is=1:ns
	Bs_ = squeeze(Bs(:,:,is));
	% virtual receivers: source a & receivers b ( b <- a )
	Bs_as = xcorr2( Bs_ , Bs_(:,a) );
	Ba = Ba + Bs_as;
	% correlation gather
	cg_a(:,is) = Bs_as(:,a);
end
% xcorr time interval
t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];
end