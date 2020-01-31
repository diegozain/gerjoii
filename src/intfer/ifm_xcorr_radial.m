function [Ba_comp,t_corr] = ifm_xcorr_radial(Bs,Ab,dt)
% Bs is 3d matrix (time by components by receivers), ie (nt,ncomp,nr).
%   it holds as columns the radially transformed traces of the receivers 
%   to be used for reconstruction of Green's function from source 'a' to recs.
% Ab is 3d matrix (time by components by receivers), ie (nt,ncomp,nr).
%   it holds as columns the radially transformed trace of the source 'a'
%   to be used for reconstruction of Green's function from source 'a' to recs.
% ---------------
% Ba_comp: shot gather with source a and receivers b, for each component.
%           size is (xcorr-time by components by receivers)
% t_corr: correlation time of size 2t-1.
% ---------------
[nt_,ncomp,nr,ns] = size(Bs);
% virtual shot gather (one for each component)
Ba_comp = zeros(2*nt_-1,ncomp,nr);
% loop through components
for icomp=1:ncomp
  % loop through sources (or time slices) and stack
  for is=1:ns
    % virtual shot gather for this component
    Ba = zeros(2*nt_-1,nr);
    % correlation gather for this component
    cg_a = zeros(2*nt_-1,ns);
    % get 2d data: (time by component by receivers)
    Bs_ = squeeze(Bs(:,icomp,:,is));
    Ab_ = squeeze(Ab(:,icomp,:,is));
    % virtual receivers: source a & receivers b ( b <- a ).
    % in this method, the source a is specific for receiver b.
    Bs_as = zeros(2*nt_-1,nr);
    for ir=1:nr
      Bs_as(:,ir) = xcorr( Bs_(:,ir) , Ab_(:,ir) );
    end 
    Ba = Ba + Bs_as;
  end
  % bundle components
  Ba_comp(:,icomp,:) = Ba;
end
% xcorr time interval
t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];
end