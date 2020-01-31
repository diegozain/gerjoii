function [Ba, t_corr] = ifm_xcorr_comp(d,a,dt)
% ---
% d is data of size (time x components x receivers x time-windows)
% a is index of virtual source
% ---
% Ba is of size (time x components x receivers)
% ---
nt_=size(d,1);
% xcorr time interval
t_corr = dt*[(-nt_+1:-1) (0:nt_-1)];
Ba = zeros(numel(t_corr),size(d,2),size(d,3));
% for components
for icomp = 1:size(d,2)
  Ba_ = squeeze(d(:,icomp,:,:));
  % interferate
  [Ba_, cg_a, t_corr] = ifm_xcorr(Ba_,a,dt);
  Ba(:,icomp,:) = Ba_;
end
end