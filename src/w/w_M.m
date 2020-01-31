function gerjoii_ = w_M(gerjoii_,ny,nx)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% takes receivers gerjoii_.w.r as (i,j) coordinates in the discretized grid
% and returns a an index vector Mw whose entries are the vectorized 
% indexed receivers.
% this method allows for any configuration of receivers as long as they are 
% first specified as (x,z) coordinates and then (i,j) indexed coordinates.
% a cool example of this is to place them around a circle and model sap flow 
% in a tree, or around a person and image their stomach or something.
% ..............................................................................
% domain is
%
% ants_i = pis+air:pie-1;     % x axis
% ants_j = pjs:pje-1;         % y axis
% ..............................................................................
r = gerjoii_.w.r;
% for fancy receivers
Mw = sub2ind([nx+1,ny+1],r(:,2),r(:,1));
% Mw has to be row vector because the data is (nt x nr)
if size(Mw,1)>1
  Mw=Mw.';
end
nr = numel(Mw);
gerjoii_.w.M = Mw;
gerjoii_.w.nr = nr;
end
