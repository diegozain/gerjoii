function gerjoii_ = w_sources(geome_,finite_,parame_,gerjoii_)

% --------
% input
% -------- 
%
% lo is minimum wavelength for 
% characteristic frequency and target relative permittivity:
% 
% lo = c / ( sqrt( max(permittivity(:)) )) / fo
% 
% source_xz is source position ( in real numbers: [x z] )
% x is real x-domain length
% ns are number of sources wanted on x
% 
% --------
% output
% --------
% 
% sources (on real coordinates) spaced on x axis as:
%
% src_TYPE == 'xLINEAR_TIGHT':
% 
%    lo/4     lo/4     lo/4
% s ------ s ------ s ------ s

lo = parame_.w.lo;
source_xz = gerjoii_.w.source_xz;
ns = gerjoii_.w.ns;
src_TYPE = gerjoii_.w.src_TYPE;
x = geome_.X;
z = geome_.Y;
air = parame_.w.air;
pis = finite_.w.pis;
pjs = finite_.w.pjs;

lo4 = lo/4;
sources = zeros(ns,2);

% ----------
%       real
% ----------

if strcmp(src_TYPE,'xLINEAR_TIGHT')
  % 
  %    lo/4     lo/4     lo/4
  % s ------ s ------ s ------ s
  %
  
  % length to the end of x (right of x-axis)
  x_length = abs(source_xz(1)-(parame_.bb-1));
  
  % exact is +1 instead of -3, 
  % but -3 is to leave an extra wavelength in the model 
  ns = fix( (4/lo)*(x_length) );
  
  sources_real = zeros(ns,2);
  % first source
  sources_real(1,1) = source_xz(1);
  % rest of sources
  for i=2:ns
    sources_real(i,1) = sources_real(i-1,1) + lo4;
  end
  
elseif strcmp(src_TYPE,'xLINEAR_SOME')
  %
  %
  % s ---- s ---- s ---- s
  if ns > 1
    ns = ns-1;
    ds = ((parame_.bb-source_xz(1)) - source_xz(1)) / ns;
    
    sources_real = zeros(ns+1,2);
    sources_real(1,1) = source_xz(1);
    for i=2:ns+1
      sources_real(i,1) = sources_real(i-1,1) + ds;
    end
  else
    sources_real = zeros(ns,2);
    sources_real(1,1) = parame_.bb/2;
  end
end % if src_TYPE
% ----------
%     binned
% ----------
% build sources (index coordinates)
sources_x = binning(x,sources_real(:,1));
sources_z = binning(z,sources_real(:,2)) -1;
% note the order of x-z coordinates changes!
sources = [sources_z sources_x];
[ns,~] = size(sources);

gerjoii_.w.sources_real = sources_real;
gerjoii_.w.sources = sources;
gerjoii_.w.ns = ns;
end