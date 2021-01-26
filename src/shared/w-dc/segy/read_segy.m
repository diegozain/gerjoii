function [seis, hdr, binh, ebcdic] = read_segy(fname, ntr)
% [seis, hdr, binh, ebcdic] = read_segy(filename);    
% Reads entire SEG-Y file, stores data in seis, trace headers in hdr
% and reel headers in binh, ebcdic
%
% [seis, hdr, binh, ebcdic] = read_segy(filename, ntr); 
% Reads first ntr traces from SEG-Y file with corresponding headers
%
% seis = read_segy(filename);
% Reads entire SEG-Y file, stores data in seis,  trace headers in hdr,
% in the format 
% hdr =
%       ffid: [ntr.x1 double]
%         ch: [ntrx1 double]
%       shot: [ntrx1 double]
%        cdp: [ntrx1 double]
%     offset: [ntrx1 double]
%    rec_xyz: [ntrx3 double]
%    src_xyz: [ntrx3 double]
% I.e.,  hdr.cdp is the array of cdp numbers etc. The reel headers are 
% available in binh, ebcdic if they are specified on input
%
% seis = read_segy(filename, ntr);
% Reads first ntr traces from SEG-Y file
%
% Ex. 
% seis  = read_segy('seismogram.segy',2001);
% [seis, hdr] = read_segy('seismogram.segy',2001);
% 
[fid, binh, ebcdic] = segyopenrd_force(fname);
fprintf('Reelheader %d samples per trace and %d traces\n', binh(11), binh(31))

if (binh(31)~=0 & ~exist('ntr'))
  ntr = binh(31);
end

if (~exist('ntr'))
fprintf('Reelheader does not contain ntr. Use the form read_segy(fname, ntr)\n')
return
end

fprintf('Reading %d traces\n', ntr)

if (ntr~=0)
[seis, hdr.ffid, hdr.ch, hdr.shot, hdr.cdp, hdr.offset, hdr.rec_xyz, hdr.src_xyz ] = rdsegy_traces(fid,ntr);
end

fclose(fid);

