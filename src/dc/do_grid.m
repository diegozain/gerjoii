function DELTAS = do_grid(finite_)
nx=finite_.dc.nx;
nz=finite_.dc.nz;
x=finite_.dc.x_robin;
z=finite_.dc.z_robin;
dx = x(2)-x(1);
dz = z(2)-z(1);
%
% diego domenzain
% spring 2017
% boise state university
%
%			nz
%   	1-------b-------2
%   	| o-----------o |
%   	| |           | |
%  nx	a |           | c
%   	| |           | |
%   	| o-----------o |
%   	3-------d-------4
%
%   grid inside -o- is inner grid.
%   -o- is inner grid boundary.
%
% input:
% dx are the values of lengths in the horizontal direction.
% dz are the values of lengths in the vertical direction.
%
% output:
% DELTAS: grid size information, edge by edge in matrix form, 
%         DELTAS(:,:,i) i=1 horizontal, i=2 vertical.
%         ghost edges on a/b share values with ghost edges c/d.
%
%
%       o   o       o   o
%       |   |       |   |       
%    o--.---.-------.---.--o     
%     1 | 2          nz | 1    
%       |               |     
%       |               |     
%       | DELTAS(:,:,2) |
%       |               |
%    o--.---.-----------.--o  
%       |   |           |
%       o   o           o 
%
%
%
%       o   o       o   o
%     1 |   |       |   |       
%    o--.---.-------.---.--o     
%     2 |               |     
%       |               |     
%       |               |     
%       | DELTAS(:,:,1) |
%    nx |               |
%    o--.---.-----------.--o  
%     1 |   |           |
%       o   o           o 

DELTAS = ones(nx,nz,2);
DELTAS(:,:,1) = dx.*DELTAS(:,:,1);
DELTAS(:,:,2) = dz.*DELTAS(:,:,2);

end
