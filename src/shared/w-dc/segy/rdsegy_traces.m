function  [seis, ffid, ch, shnm, cdp, offset, rec_xyz, src_xyz ] = rdsegy_traces(fid,ntr)
%  [seis, ffid, ch, shnm,cdp, offset, rec_xyz, src_xyz ]= segysrprd(fid,ntr)
%  RDSEGY_TRACES Reads a SEGY file, and returns the named header parameters and data
%  (seis) in MATLAB format.
% fname: input file name
% Outputs:
% ffid   : ffid
% ch     : channel
% shnm   : shot
% cdp    : cdp
% offset : offset
% rec_xyz : [rec_x, rec_x, rec_elev]
% src_xyz : [src_x, src_x, src_elev]
% RDSEGY_TRACES assigns buffer space for the traces & headers in increments to speed
% up input.


%   Next read the trace headers and data, putting into temp arrays
%   Reads each header twice, first putting into ibuf in short int format
%   then into lbuf in long int format
%   Array ibuf is (nx by 120) and array lbuf is (nx by 60)

nx = 0;   % Number of traces read

% Preassign Buffer space for trace headers/data

T1 = fread(fid,120,'short')';
if (length(T1) ~= 120)
  nt = 0;
  return
end

nsamps = T1(58);
fseek(fid,-240,0);

ibuf = zeros(120,ntr);
lbuf = zeros(60,ntr);
fbuf = zeros(60,ntr);
seis = zeros(nsamps, ntr);

%tic
while (nx < ntr)
  T1 = fread(fid,120,'short')';
  if (feof(fid) == 1) break; end

  nsamps = T1(58);
  fseek(fid,-240,0);
  T2 = fread(fid,60,'int32')';
  fseek(fid,-240,0);
%  T2a = ibmconv(fread(fid,240,'char'))';
  T2a = fread(fid,60,'float')';

  T3 = fread(fid,nsamps,'float')';

  nx = nx + 1;
  ibuf(:,nx) = T1';
  lbuf(:,nx) = T2';
  fbuf(:,nx) = T2a';
  seis(:,nx) = T3';

end
%toc
fprintf(1,'There are %d seismograms of %d points each\n',nx,nsamps);

% Identify the variables inside the ibuf or lbuf arrays to pass on

if (nx ~= 0) 
seis = seis(:,1:nx);
ibuf = ibuf(:,1:nx);
lbuf = lbuf(:,1:nx);
fbuf = fbuf(:,1:nx);

% Headers
% two byte
ssc_el = ibuf(35, :)' ; % scalar for the elevation numbers
ssc_xy = ibuf(36, :)'; % scalar for the range  numbers

% four byte
ffid  = lbuf(3,:)' ;  % ffid
ch    = lbuf(4,:)' ;  % channel
shnm  = lbuf(5,:)' ;  % shot
cdp   = lbuf(6,:)' ;  % cdp
offset   = lbuf(10,:)' ; % offset
if (ssc_el)
 rec_el   = -lbuf(11,:)'./ssc_el ; % rec_elev
 src_el   = -lbuf(12,:)'./ssc_el ; % sou_elev
else
 rec_el   = -lbuf(11,:)' ; % rec_elev
 src_el   = -lbuf(12,:)' ; % sou_elev
end

if (ssc_xy)
 srclat = lbuf(19,:)'./ssc_xy ; % sou_x
 srclon = lbuf(20,:)'./ssc_xy ; % sou_y
 reclat = lbuf(21,:)'./ssc_xy ; % rec_x
 reclon = lbuf(22,:)'./ssc_xy ; % rec_y
else
 srclat = lbuf(19,:) ; % sou_x
 srclon = lbuf(20,:) ; % sou_y
 reclat = lbuf(21,:) ; % rec_x
 reclon = lbuf(22,:) ; % rec_y
end

rec_xyz=-[reclat reclon rec_el];
src_xyz=-[srclat srclon src_el];

% fprintf(1,'Elevation scalar = [%d, %d], XY scalar = [%d, %d]', min(ssc_el), max(ssc_el), min(ssc_xy), max(ssc_xy))

else
nt = 0;
end
