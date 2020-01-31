function [datcor] = t0corr(dat,s0);

% dat is (nt x ns) matrix

datcor = zeros(size(dat));
nt = length(dat(:,1));
datcor(1:nt-s0+1,:) = dat(s0:nt,:);

end
