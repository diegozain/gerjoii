function [fid,binh,ebcdic] = segyopenrd(fname)
% [fid, binh, ebcdic] = segyopenrd(fname)
% SEGYOPENRD opens an existing SEGY file and reads in the EBCDIC header and 
% binary header, and puts the file pointer after the reel headers.
% The _FORCE extension means this module disregards the floating point
% format stored in the binary reel header
% Inputs:
% fname: input file name
% Outputs:
% fid   : file pointer
% binh  : binary reel header
% ebcdic: ebcdic reel header (potentially useful for subsequent output)


        %   Open file and position past the EBCDIC header
fid = fopen(fname, 'r','b');
if fid == -1
    error('error opening seismogram file')
end
ebcdic = fread(fid,3200,'char');

                % Read the Binary header & check data format
binh = fread(fid,200,'short');
fprintf(1,'Data format %d\n',binh(13));

if (binh(13) < 5)
%  error('Cannot read non-native floating point format');  
fprintf(1, 'Warning. May be non-native floating point format\n');
end
