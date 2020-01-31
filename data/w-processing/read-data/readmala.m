function [dat,dt,f0,dx]=readmala(fnam)

% This function reads Mala *.RD3 formatted data with input
%	format [dat,dt,f0,dx]=readmala(fnam)
%	fnam=string with filename.RD3
% 	dat is the data matrix
%   dt is sampling rate in ns
%   f0 is center freqency of antenna
%   dx is trace interval in m

fnam

k=0;
[~,ns]=textread([fnam '.RAD'],'%8c%f%*[^\n]',1);
[~,t]=textread([fnam '.RAD'],'%11c%f%*[^\n]',1,'headerlines',18);
[~,dx]=textread([fnam '.RAD'],'%18c%f%*[^\n]',1,'headerlines',10);
[~,f0]=textread([fnam '.RAD'],'%9c%4f%*[^\n]',1,'headerlines',14);
[~,ntr]=textread([fnam '.RAD'],'%11c%f%*[^\n]',1,'headerlines',22);

dt=t./(ns-1);

fid=fopen([fnam '.RD3'],'r');
dat=fread(fid,[ns,ntr],'int16');
fclose(fid)

end
