function h = wigb(a,scal,x,z,amx)
% WIGB: Plot seismic data using wiggles.
%
%  H = WIGB(a,scal,x,z,amx)
%
%  IN  a:     seismic data (a matrix, traces are columns)
%      scale: multiple data by scal
%      x:     horizontal axis (often offset)
%      z:     vertical axis (often time)
%      amx:   scale data for plotting
%
%  Note
%
%    If only 'a' is enter, 'scal,x,z,amn,amx' are set automatically;
%    otherwise, 'scal' is a scalar; 'x, z' are vectors for annotation in
%    offset and time, amx are the amplitude range.
%
%
%  Author(s): Xingong Li (Intseis, Integrated Seismic Solutions)
%  Copyright 1998-2003 Xingong
%  Revision: 1.2  Date: Dec/2002
%

%--------------------------------------------------------------------------
% default plot of random numbers
%--------------------------------------------------------------------------
if nargin == 0
    nx = 10;
    nz = 100; 
    a  = randn(nz,nx);
end
%--------------------------------------------------------------------------
if (nargin <= 1)
    scal = 1; % default to unit amplitude scaling
end
%--------------------------------------------------------------------------
% setup dimensions and defaults
%--------------------------------------------------------------------------
[nz, nx] = size( a ); % get the dimensions of matrix

if (nargin <= 2)
    x = 1 : nx; % default to unit x-coordinate
    z = 1 : nz; % default to unit z-coordinate
end
%--------------------------------------------------------------------------
trmx = max( abs( a ) ); % get the max value of each trace for scaling
% check the input
if (nargin <= 4) 
    amx = mean( trmx ); % 
end
%--------------------------------------------------------------------------
if scal == 0 
    scal = 1; % default 
end
%--------------------------------------------------------------------------
if (nx <= 1) 
    disp(' ERR:PlotWig: nx has to be more than 1');
    return;
end
%--------------------------------------------------------------------------
% Process the data
%--------------------------------------------------------------------------

% take the average as dx
dx1 = abs( x( 2:nx ) - x( 1:nx-1 ) );
dx = median( dx1 );
dz = z(2) - z(1);

% set display range
x1 = min(x) - 2.0*dx; 
x2 = max(x) + 2.0*dx;
z1 = min(z) - dz; 
z2 = max(z) + dz;

% scale the matrix columns according to dx and scal parameters
a = a * dx / amx;
a = a * scal;

% print the max and min amplitudes to the screen output
xmx = max( max( a ) ); 
xmn = min( min( a ) );
% fprintf(' PlotWig: data range [%f, %f], plotted max %f \n',xmn,xmx,amx);

%--------------------------------------------------------------------------
% Process the data
%--------------------------------------------------------------------------

% set default plot parameters
fillColor = [0 0 0];
lineColor = [0 0 0];
lineWidth = 1.0;

z      = z'; % input as row vector
zstart = z(1);
zend   = z(nz);

% make the figure
h = figure('Color','w');
set( gca,...
    'NextPlot','add',...
    'Box','on',...
    'XLim', [x1 x2], ...
    'YDir','reverse', ...
    'YLim',[z1 z2]...
    );

for i = 1 : nx
    
    if trmx(i) ~= 0; % skip the zero traces
        tr   = a( :, i ); % --- one scale for all section
        s    = sign( tr );
        i1   = find( s(1:nz-1) ~= s(2:nz) ); % zero crossing points
        npos = length( i1 );
        
        %12/7/97
        zadd = i1 + (tr(i1)) ./ (tr(i1) - tr(i1+1)); %locations with 0 amplitudes
        aadd = zeros( size( zadd ) );
        
        [zpos, vpos] = find( tr > 0 );
        [zz,iz] = sort( [zpos; zadd] ); % indices of zero point plus positives
        aa = [ tr(zpos); aadd ];
        aa = aa( iz );
        
        [zneg, vneg] = find( tr < 0 );
        [zz_,iz_] = sort( [zneg; zadd] ); % indices of zero point plus negs
        aa_ = [ tr(zneg); aadd ];
        aa_ = aa_( iz_ );
        
        % be careful at the ends
        if or(tr(1) > 0, tr(1) < 0)
            a0 = 0; 
            z0 = 1.00;
        else
            a0 = 0; 
            z0 = zadd(1);
        end;
        
        if or(tr(nz) > 0, tr(nz) < 0) 
            a1 = 0; 
            z1 = 0;%nz;i
        else
            a1 = 0; 
            z1 = max(zadd);
        end;
        
        zz = [z0; zz; z1; z0];
        aa = [a0; aa; a1; a0];
        zzz = zstart + zz*dz - dz;
        patch( aa + x(i) , zzz,  'r', 'EdgeColor','None' ); % plot the fill +
        
        zz_ = [z0; zz_; z1; z0];
        aa_ = [a0; aa_; a1; a0];
        zzz_ = zstart + zz_*dz - dz;
        % patch( aa_ + x(i) , zzz_,  'b', 'EdgeColor','None' ); % plot the fill -

        line( 'Color',lineColor, 'LineWidth',lineWidth, ...
            'Xdata', tr+x(i), 'Ydata',z);	% line
        
    else % zeros trace 
        % We still plot a zero trace as a blank black line
        line( 'Color',lineColor, 'LineWidth',lineWidth, ...
            'Xdata', [x(i) x(i)], 'Ydata',[zstart zend]);
    end;
end;
