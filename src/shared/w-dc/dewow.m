function [dat_]=dewow(dat,dt,fo)
% tic
% written by John Bradford 6/22/2005
% modified by Bradford from Liberty's code 6/24/2005
% applies low cut filter to data
% uses sensors and software moving boxcar filter

% dat is (nt x nr) matrix

nr = length(dat(1,:));
nt = length(dat(:,1));
lf = round(1/fo/dt);
bg = zeros(nt-lf-1,nr);
dat_ = zeros(size(dat));
bgs = mean(dat(1:2*lf+1,:));
bge = mean(dat(nt-2*lf:nt,:));

for t=1:nt
	if(t < lf+1 )
		dat_(t,:) = dat(t,:)-bgs;
	elseif (t > nt-lf-1)
		dat_(t,:) = dat(t,:)-bge;
	else
		bg(t,:) = mean(dat(t-lf:t+lf,:));
		dat_(t,:) = dat(t,:)-bg(t,:);
	end
end
% toc

end
