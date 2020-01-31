function [parame_,finite_,gerjoii_] = dc_exp2robin(geome_,parame_,finite_,gerjoii_)

nx = finite_.dc.nx;
nz = finite_.dc.nz;
robin = parame_.dc.robin;

% --------
%   DELTAS
% --------

x = geome_.X;
z = geome_.Y;

dx1 = x(2)-x(1);
dx2 = x(geome_.n)-x(geome_.n-1);
dz2 = z(geome_.m)-z(geome_.m-1);

dx1_robin = (1:robin)*dx1;
dx2_robin = (1:robin)*dx2;
dz2_robin = (1:robin)*dz2;

x = [dx1_robin x dx2_robin];
z = [z dz2_robin];

finite_.dc.x_robin = x;
finite_.dc.z_robin = z;

finite_.dc.DELTAS = do_grid(finite_);

% -------
%   sigma
% -------

sigma_robin = parame_.dc.sigma;

sig1 = sigma_robin(1,:);
sig2 = sigma_robin(geome_.n,:);
sig1 = repmat(sig1, robin  ,  1  );
sig2 = repmat(sig2, robin  ,  1  );
sigma_robin = [sig1; sigma_robin; sig2];

sig3 = sigma_robin(:,geome_.m);
sig3 = repmat(sig3, 1  , robin  );
sigma_robin = [sigma_robin , sig3];

parame_.dc.sigma_robin = sigma_robin;

% ------------------------- sources & receivers --------------------------------

% "ia" is index for a_spacing (a=src_a(ia)) of shot.
%       "ia" should be an integer between 1 and numel( src_a )
% "in" is index for n_spacing (n=an_spacings{ia}(in)) position of shot.
%       "in" should be an integer between 1 and src_n(ia).
src_n = gerjoii_.dc.src_n;
src_a = gerjoii_.dc.src_a;

sources_robin   = gerjoii_.dc.sources;
receivers_robin = gerjoii_.dc.receivers;
sources_robin_vect   = cell( size(gerjoii_.dc.sources) );
receivers_robin_vect = cell( size(gerjoii_.dc.receivers) );

for ia=1:numel(src_a);
  
  % ---------
  %   sources
  % ---------
  
  % so
  sources_robin{ia}(:,1,1) = sources_robin{ia}(:,1,1)+robin;
  % si
  sources_robin{ia}(:,1,2) = sources_robin{ia}(:,1,2)+robin;
  % clean
  sources_robin{ia} = clean_xsource(sources_robin{ia});
  % vect
  sources_robin_vect{ia} = vectorize_source(sources_robin{ia},nx);
  
  % -----------
  %   receivers
  % -----------
  
  for in=1:src_n(ia);
    % so & si
    receivers_robin{ia}{in}(:,1,1) = receivers_robin{ia}{in}(:,1,1)+robin;
    receivers_robin{ia}{in}(:,1,2) = receivers_robin{ia}{in}(:,1,2)+robin;
    % vect
    receivers_robin_vect{ia}{in} = vectorize_source(receivers_robin{ia}{in},nx);
  end
end

gerjoii_.dc.sources   = sources_robin;
gerjoii_.dc.receivers = receivers_robin;
gerjoii_.dc.sources_vectorized   = sources_robin_vect;
gerjoii_.dc.receivers_vectorized = receivers_robin_vect;

end

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

function ss = clean_xsource(ss)
  for n_a=1:size(ss,1)
    if mod(ss(n_a,1,1),2)==1
      ss(n_a,1,1) = ss(n_a,1,1)+1;
    end
    if mod(ss(n_a,1,2),2)==0
      ss(n_a,1,2) = ss(n_a,1,2)+1;
    end
  end
end

function ss_ = vectorize_source(ss,n)
  n_rows = size(ss,1);
  ss_ = zeros(n_rows,2);
  for j=1:n_rows
    ss_(j,1) = ss(j,1,1) + n*(ss(j,2,1) - 1);
    ss_(j,2) = ss(j,1,2) + n*(ss(j,2,2) - 1);
  end
end