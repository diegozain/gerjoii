function [CO,ca] = dc_coca(n,m,DELTAS,s_dc)
	
	% give oposite and adjacent sides of domain with respect to sources.
	%
	% very usefull for computing distance from sources to elements in domain,
	%
	% r  = sqrt(CO(:,:,1).^2 + ca(:,:).^2); for positive source
	% r_ = sqrt(CO(:,:,2).^2 + ca(:,:).^2); for negative source
	%
	% s_dc = (nx x 1) vector of zeros and ones.

s = find(s_dc);

co = zeros(n,2);

for i=1:n
	for j=1:2
		if i<s(j)
			co(i,j) = sum(DELTAS(i:s(j),1,1));
		elseif i>s(j)
			co(i,j) = sum(DELTAS(s(j):i,1,1));
		elseif i==s(j)
			co(i,j) = 0;
		end	
	end
end

ca = zeros(1,m);

for i=2:m
	ca(i) = sum(DELTAS(1,2:i,2));
end

CO = zeros(n,m,2);

CO(:,:,1) = repmat(co(:,1),1,m);
CO(:,:,2) = repmat(co(:,2),1,m);

ca = repmat(ca,n,1);

end
