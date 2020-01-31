function u = vid_w_(x,z,dt,path_to_files,filename)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% make videos out of saved files in disk.
% files have to be named 'filename#.mat'
% where # ranges from 0 to end.
% 'filename#.mat' files must have a matrix inside them named 'filename'.
% ------------------------------------------------------------------------------
if ~strcmp(path_to_files(end),'/')
  path_to_files = strcat(path_to_files,'/');
end
% ------------------------------------------------------------------------------
prompt = '\n\n    Tell me if only so many files (e.g. 5 or Inf):  ';
nf = input(prompt,'s');
nf = str2num(nf);
prompt = '    Tell me if you want to transpose (y or n):  ';
transp = input(prompt,'s');
prompt = '    Tell me if you want colormap centered around zero (y or n):  ';
centered = input(prompt,'s');
prompt = '    Tell me how much clip in percentage (e.g. 1e-1):  ';
pct = input(prompt,'s');
pct = str2num(pct);
% ------------------------------------------------------------------------------
% number of files in path
nf = min(nf , numel(dir( strcat(path_to_files,'*.mat') )));
% bundle all files in one cube-matrix u
u=load( strcat(path_to_files,filename,num2str( 1 ),'.mat') );
[nz,nx]=size(eval(strcat('u.',filename)));
u=zeros(nz,nx,nf);
for i_=0:(nf-1)
  u_=load( strcat(path_to_files,filename,num2str( i_ ),'.mat') );
  u(:,:,(i_+1)) = eval(strcat('u_.',filename));
end
% the dc .mat files are all transposed
if strcmp(transp,'y')
  u=permute(u,[2,1,3]);
end
% ------------------------------------------------------------------------------
% video wave
vid_w(u,x,z,dt,filename,centered,pct);
% ------------------------------------------------------------------------------
end