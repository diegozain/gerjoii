function [gaindat] = gain_rt(dat,tpow)

% dat is (nt x ns) matrix
%
% John Bradford gave me this.

ns=length(dat(1,:));
nt=length(dat(:,1));
tg=[1:nt].^tpow.';

k=0;
gaindat=zeros(size(dat));
while (k < ns)
	gaindat(:,k+1)=dat(:,k+1).*tg;
	k=k+1;
end

end
