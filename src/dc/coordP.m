function u = coordP(XX,n)
% given grid coordinate, find number coordinate of point.
%
% XX <-- is a vector whose entries are the coordinate of the point in the 
%        grid.
% n  <-- horizontal grid size.
%
% u  <-- number coordinate of point.

	i = XX(1);
	j = XX(2);
	
	u = i + (j-1)*n;
end