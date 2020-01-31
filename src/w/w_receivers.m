function gerjoii_ = w_receivers(geome_,parame_,gerjoii_)
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
% nr are number of receivers wanted on x
% 
% --------
% output
% --------
% 
% receivers (on real coordinates) spaced on x axis as:
%
% rec_TYPE == 'xLINEAR_TIGHT':
% 
%     lo        lo/4     lo/4
% s -------- r ------ r ------ r

lo = parame_.w.lo;
sources = gerjoii_.w.sources;
ns = gerjoii_.w.ns;
rec_TYPE = gerjoii_.w.rec_TYPE;
x = geome_.X;
z = geome_.Y;

lo4 = lo/4;

% store all receivers in a cell of size # of sources
receivers_real = cell(ns,1);
receivers = cell(ns,1);

% ---------
%      real
% ---------
for i_source = 1:ns
  % choose source in real coordinates
  source_xz = gerjoii_.w.sources_real( i_source,: );
  if strcmp(rec_TYPE,'xLINEAR_TIGHT')
    % 
    %     lo        lo/4     lo/4
    % s -------- r ------ r ------ r
    %
    
    % ----------
    % right of x-axis
    % ----------
    % length to the end of x (right of x-axis)
    x_length_r = abs(source_xz(1)-parame_.bb);
    
    % # of receivers for this source
    % exact is +1 instead of -3, 
    % but -3 is to leave an extra wavelength in the model 
    nr_r = fix( (4/lo)*(x_length_r - lo) - 3 );
    
    if nr_r>0
      receivers_real_r = zeros(nr_r,2);
      % first receiver 
      receivers_real_r(1,1) = source_xz(1) + lo;
      % rest of receivers
      for i=2:nr_r
        receivers_real_r(i,1) = receivers_real_r(i-1,1) + lo4;
      end
    else 
      receivers_real_r = [];
    end
    % ----------
    % left of x-axis
    % ----------
    % length to the end of x (left)
    x_length_l = abs(source_xz(1)-parame_.aa);
    
    % exact is +1 instead of -3, 
    % but -3 is to leave an extra wavelength in the model 
    nr_l = fix( (4/lo)*(x_length_l - lo) - 3 );
    
    if nr_l>0
      receivers_real_l = zeros(nr_l,2);
      % first receiver 
      receivers_real_l(1,1) = source_xz(1) - lo;
      % rest of receivers
      for i=2:nr_l
        receivers_real_l(i,1) = receivers_real_l(i-1,1) - lo4;
      end
    else 
      receivers_real_l = [];
    end
    if nr_l>1
      receivers_real_l = flip(receivers_real_l);
    end
    receivers_real{i_source} = [receivers_real_l ; receivers_real_r];
  elseif strcmp(rec_TYPE,'xLINEAR_ALL')
    %
    %
    % r - r - r - s - r - r - r
    receivers_real{i_source} = zeros(numel(x),2);
    receivers_real{i_source}(:,1) = x;
  end % end if rec_TYPE
end % for sources

% ----------------
%           binned
% ----------------

for i_source = 1:ns
  receivers_x = binning(x,receivers_real{i_source}(:,1));
  receivers_z = binning(z,receivers_real{i_source}(:,2)) - 1;
  receivers{i_source} = uint32( zeros(numel(receivers_x),2) );
  receivers{i_source}(:,:) = [receivers_x, receivers_z];
end % for i_sources

gerjoii_.w.receivers_real = receivers_real;
gerjoii_.w.receivers = receivers;
end
