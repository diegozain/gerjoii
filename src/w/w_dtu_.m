function w_dtu_chunks(dt,parallel_memory_w,is)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% --
% 1. load 1st chunk, u
%     RAM: u
% 2. take derivative, dtu
%     RAM: u, dtu
% 3. save in ram last two time-steps of u, u_
%     RAM: u, dtu, u_
% 4. erase u
%     RAM: dtu, u_
% 5. load next chunk, u
%     RAM: dtu, u_, u
% 6. take derivative of u_ and first two time-steps of u (erase), dtu_
%     RAM: dtu, u, dtu_
% 7. append first time-step of dtu_ in the end of dtu
%     RAM: dtu, u, dtu_
% 8. save dtu to disk and erase from ram
%     RAM: u, dtu_
% 9. take derivative of u, dtu
%     RAM: u, dtu_, dtu
% 10. append last time-step of dtu_ in the beginning of dtu (erase)
%     RAM: u, dtu
% 11. save in ram last two time-steps of u, u_
%     RAM: u, dtu, u_
% 12. erase u
%     RAM: dtu, u_
% 13. repeat from 5 until second to last chunk.
% 14. load last chunk u, do 6-10 and save dtu.
% --
% n_chunks: # of chunks
% nt:       # of time-steps inside chunk
% dt = geome_.w.dt;

% ------------
% path to load wavefield,
% ------------
% u_folder = parallel_memory/w/source#/u/
% parallel_memory_w = '/path/to/disk/parallel_memory/w/'
u_folder = strcat(parallel_memory_w,'source',num2str(is),'/u/');
% number of wavefield chunks
n_chunks = numel(dir( strcat(u_folder,'*.mat') ));
% ------------
% path to save dtu
% ------------
% save( 'path/to/dir/name-of-file' , 'variable-name' );
dtu_folder = strcat(parallel_memory_w,'source',num2str(is),'/dtu/');
% --
% load first u
load( strcat( u_folder,'u',num2str(1),'.mat') );
% take derivative
[nz,nx,nt] = size(u_w);
dtu = zeros(nz,nx,nt);
dtu(:,:,1)     = (1/(dt)) * ((-3/2)*u_w(:,:,1) + 2*u_w(:,:,2) - (1/2)*u_w(:,:,3));
dtu(:,:,2:nt-1) = (1/(dt)) * ((-1/2)*u_w(:,:,1:nt-2) + (1/2)*u_w(:,:,3:nt));
% save last two time-steps of u and delete u
u_ = u_w(:,:,nt-1:nt);
clear u_w;
% loop through 2nd to 2nd to last chunk
for ichunk=2:n_chunks-1
  % load next chunk
  load(  strcat( u_folder,'u',num2str(ichunk),'.mat') );
  % take derivative with u_ and first two time-steps of u and erase u_
  dtu_ = (1/(dt)) * ((-1/2)*u_ + (1/2)*u_w(:,:,1:2));
  clear u_;
  % append 1st time-step of dtu_ in the end of dtu
  dtu(:,:,nt) = dtu_(:,:,1);
  % save and erase dtu
  name = strcat(dtu_folder,'dtu',num2str( ichunk-1 ),'.mat');
  save( name , 'dtu' );
  clear dtu;
  % derivative of u
  [nz,nx,nt] = size(u_w);
  dtu = zeros(nz,nx,nt);
  dtu(:,:,2:nt-1) = (1/(dt)) * ((-1/2)*u_w(:,:,1:nt-2) + (1/2)*u_w(:,:,3:nt));
  % append 2nd time-step of dtu_ in the beginning of dtu and erase dtu_
  dtu(:,:,1) = dtu_(:,:,2);
  clear dtu_;
  % save last two time steps of u
  u_ = u_w(:,:,nt-1:nt);
  clear u_w;
end
% load last chunk
load(  strcat( u_folder,'u',num2str(n_chunks),'.mat') );
% take derivative with u_ and first two time-steps of u and erase u_
dtu_ = (1/(dt)) * ((-1/2)*u_ + (1/2)*u_w(:,:,1:2));
clear u_;
% append 1st time-step of dtu_ in the end of dtu
dtu(:,:,nt) = dtu_(:,:,1);
% save and erase dtu
name = strcat(dtu_folder,'dtu',num2str( n_chunks-1 ),'.mat');
save( name , 'dtu' );
clear dtu;
% derivative of u
[nz,nx,nt] = size(u_w);
dtu = zeros(nz,nx,nt);
dtu(:,:,2:nt-1) = (1/(dt)) * ((-1/2)*u_w(:,:,1:nt-2) + (1/2)*u_w(:,:,3:nt));
dtu(:,:,nt)     = (1/(dt)) * ((3/2)*u_w(:,:,nt) - 2*u_w(:,:,nt-1) + (1/2)*u_w(:,:,nt-2));
% append 2nd time-step of dtu_ in the beginning of dtu and erase dtu_
dtu(:,:,1) = dtu_(:,:,2);
clear dtu_;
% save last one
name = strcat(dtu_folder,'dtu',num2str( n_chunks ),'.mat');
save( name , 'dtu' );
end