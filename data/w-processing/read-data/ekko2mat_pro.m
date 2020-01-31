function [A,x,t,header,skips]=ekko2mat_pro(filename)
%function [A,x,t,header]=ekko2mat_pro(filename)
%
% EKKO2MAT_pro syntax: [A,x,t, header]=ekko2mat_pro('filename')
%                  where filename has no .hd/.dt1 extension
%
% ENHANCED VERSION OF EKKO2MAT NEEDED FOR READING FULL DATA FILES. 
%
% This function reads a PulseEkko binary file into a MATLAB matrix,
% where A is the matrix, x is a horizontal position vector, and t
% is a time vector.  The filename should have no extension supplied.
%
% The variable HEADER is a matrix that contains all of the additional 
% information from the DT1 file (e.g., GPS positions).  Each column
% contains one field from the DT1 file header where each row corresponds 
% to a trace.  
%
% Column definitions for HEADER:
% # 1 - number of points in trace
% # 2 - topo data
% # 3 - unused entry
% # 4 - bytes per point
% # 5 - time window  <--- Looks like the Trace # Adam Mangel 2/21/2013
% # 6 - number of stacks
% # 7 - x GPS position
% # 8 - y GPS position
% # 9 - z GPS position
% #10 - receiver x position
% #11 - reciever y position
% #12 - reciever z position
% #13 - transmitter x position
% #14 - transmitter y position
% #15 - transmitter z position
% #16 - time zero adjustment
% #17 - data zero flag
% #18 - skipped trace marker (set to zero if trace not skipped)
% #19 - channel number
% #20 - time trace is collected (seconds past midnight)
% #21 - trace comment flag
% 
% NOTE: skipped traces are removed from the data before returning the
% output of this function to the user.
%
% To increase the speed by which the data is loaded, ekko2mat has now
% been written as the MEX-file ekko2mat.dll.  This speeds up data loading
% by roughly 100 times.  (NOTE: MEX is no longer necessary - S.Moysey, 2011)
%
% by James Irving
% June, 1998 (M-File)
% November, 1998 (MEX-File)
% 
% Revisions:
% May, 2011 - S. Moysey 
% - initialized A matrix and x vector to improve speed of m file in MATLAB
% - modified original ekko2mat to read in header file data
% - currently doesn't read comments -- need to fix without loss of speed!!


headerfile=[filename '.hd'];
datafile=[filename '.dt1'];

[fph,msg]=fopen(headerfile,'rt');  % open ASCII header file
if fph==-1                         % display error if necessary
   disp(msg)
   return
end

while(~feof(fph))                  % read information from header
   temp=fgets(fph);
   if (strncmp(temp,'NUMBER OF TRACES   =',20))
      ntraces=sscanf(temp(21:length(temp)),'%d');
   end
   if (strncmp(temp,'NUMBER OF PTS/TRC  =',20))
      nppt=sscanf(temp(21:length(temp)),'%d');
   end
   if (strncmp(temp,'TIMEZERO AT POINT  =',20))
      zeropt=sscanf(temp(21:length(temp)),'%d');
   end
   if (strncmp(temp,'TOTAL TIME WINDOW  =',20))
      window=sscanf(temp(21:length(temp)),'%d');
   end
end

fclose(fph);


[fpd,msg]=fopen(datafile,'rb','l'); % open binary data file
if fpd==-1                          % display error if necessary
   disp(msg)
   return
end

%initialize data matrices:
x = zeros(ntraces-1,1);
A = zeros(nppt,ntraces-1);
tracenum = zeros(ntraces-1,1);

block1 = zeros(ntraces-1,6);
block2 = zeros(ntraces-1,3);
block3 = zeros(ntraces-1,8);
block4 = zeros(ntraces-1,2);
block5 = zeros(ntraces-1,2);


for j=1:ntraces-1                     % read data from file into A and x
    tracenum(j) = fread(fpd,1,'float32');   %read trace number
    x(j)=fread(fpd,1,'real*4');             %read trace position 
  
    %Data file header is split into different blocks so that each format is
    %read independently.  Reading by blocks increases speed substantially.
    block1(j,:) = fread(fpd,6,'real*4');
    block2(j,:) = fread(fpd,3,'double');
    block3(j,:) = fread(fpd,8,'real*4');
    block4(j,:) = fread(fpd,2,'bit8');
    fseek(fpd,2,0); %skip 2 unused bytes
    block5(j,:) = fread(fpd,2,'real*4');
    fseek(fpd,28,0);%skip comments    
    
    A(:,j)=fread(fpd,nppt,'int16');          %read trace data    
end

fclose(fpd);

%create full header matrix
header = [block1 block2 block3 block4 block5];

%find skipped traces (these cause repeats that mess up data ordering)
skips = find(header(:,18)~=0);
%remove skipped traces from data
header(skips,:) = [];
A(:,skips) = [];
x(skips) = [];

%Create time vector.
sampint=round((window/(nppt-1)*10))/10;   % create vertical time vector t
tstart=(zeropt-1)*(-sampint);
tend=tstart+(nppt-1)*sampint;
t=linspace(tstart,tend,nppt);

