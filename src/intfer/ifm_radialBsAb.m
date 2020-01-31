function [Bs,Ab] = ifm_radialBsAb(d,a,recs,locs)
% Bs is 3d matrix (time by components by receivers), ie (nt,ncomp,nr).
%   it holds as columns the radially transformed traces of the receivers 
%   to be used for reconstruction of Green's function from source 'a' to recs.
% Ab is 3d matrix (time by components by receivers), ie (nt,ncomp,nr).
%   it holds as columns the radially transformed trace of the source 'a'
%   to be used for reconstruction of Green's function from source 'a' to recs.
% NOTE: # of components is 3, (E,N,Z).
%       if you want to change # of components change ifm_radial.m
% ----
% d is data (nt by components by stations) WITH source a.
% a is index of source.
% recs is vector of indicies of receivers,
% WARNING: 'recs' does NOT contain 'a'.
% locs are (E,N) coordinates of stations (nstat by 2).
% ----
% for use before ifm_xcorr_radial.m,
% [Bs,Ab] = ifm_radialBsAb(d,a,recs,locs);
% [Bs,Ab,it_window] = window_denz(Bs,Ab,time2window);
% [Ba_comp,cg_a_comp,t_corr] = ifm_xcorr_radial(Bs,Ab,dt);
% ----
[nt,ncmp,~] = size(d);
nr = numel(recs);
Bs = zeros(nt,ncmp,nr);
Ab = zeros(nt,ncmp,nr);
% virt.src 'a' location
vs_loc = locs(a,:).';
% wavefield of virt.src 'a',
ua = squeeze(d(:,:,a));
for i_=1:nr
  b = recs(i_);
  % virtual receiver location
  vr_loc = locs(b,:).';
  % wavefield of receiver b
  u = squeeze(d(:,:,b));
  % radial component of virt.rec 'b' coming from virt.src 'a' 
  u = ifm_radial(u , vs_loc , vr_loc );
  % bundle radial recs
  Bs(:,:,b) = u;
  % radial component of virt.src 'a' to virt.rec 'b' 
  u = ifm_radial(ua , vs_loc , vr_loc );
  % bundle radial srcs
  Ab(:,:,b) = u;
end
end