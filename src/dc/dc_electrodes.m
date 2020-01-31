function gerjoii_ = dc_electrodes(geome_,parame_,finite_,gerjoii_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% . choose experiment bundle # i_e
% . find real coordinates of src-rec
% . bin these coordinates to discretized domain
% . expand to robin
% . vectorize src and rec
% . clean src
% . give current magnitude to src
% 
% . return s and r ready for dc_fwd.m
% ------------------------------------------------------------------------------

nx    = finite_.dc.nx;
nz    = finite_.dc.nz;
robin = parame_.dc.robin;
s     = gerjoii_.dc.s_;
i_    = gerjoii_.dc.i_;
r     = gerjoii_.dc.r_;
% ----------------------------------------
% s    = s_i_r_d_std{ i_e }{ 1 }(1:2);
% i_   = s_i_r_d_std{ i_e }{ 1 }(3);
% r    = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
% d    = s_i_r_d_std{ i_e }{ 2 }(:,3);
% std_ = s_i_r_d_std{ i_e }{ 2 }(:,4);
% ----------------------------------------
% real coordinates
s_real = zeros(1,2,2);
s_real(:,:,1) = gerjoii_.dc.electr_real(s(1),:);
s_real(:,:,2) = gerjoii_.dc.electr_real(s(2),:);
r_real = zeros( size(r,1) , 2 , 2 );
r_real(:,:,1) = gerjoii_.dc.electr_real(r(:,1),:);
r_real(:,:,2) = gerjoii_.dc.electr_real(r(:,2),:);
% bin
is = zeros(1,2,2);
is(1,1,:) = binning( geome_.X,s_real(1,1,:) );
is(1,2,:) = binning( geome_.Y,s_real(1,2,:) );
ir = zeros( size(r,1) , 2 , 2 );
ir(:,1,1) = binning( geome_.X,r_real(:,1,1) );
ir(:,1,2) = binning( geome_.X,r_real(:,1,2) );
ir(:,2,1) = binning( geome_.Y,r_real(:,2,1) );
ir(:,2,2) = binning( geome_.Y,r_real(:,2,2) );
% expand to robin
is(:,1,:) = is(:,1,:) + robin;
ir(:,1,:) = ir(:,1,:) + robin;
% clean src
is = clean_xsource(is);
% vect
s = vectorize_electrodes(is,nx);
r = vectorize_electrodes(ir,nx);
% give the current some electrifying magnituuuuude, dude. right on.
v = [1 ; -1] * i_;
s = sparse(s,1,v,double(nx*nz),1);
% ------------------------------------------------------------------------------
% return values
gerjoii_.dc.s = s;
gerjoii_.dc.r = r;
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------- private --------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function s = clean_xsource(s)
  for n_a=1:size(s,1)
    if mod(s(n_a,1,1),2)==1
        s(n_a,1,1) = s(n_a,1,1)+1;
    end
    if mod(s(n_a,1,2),2)==0
        s(n_a,1,2) = s(n_a,1,2)+1;
    end
  end
end
function s_ = vectorize_electrodes(s,n)
  n_rows = size(s,1);
  s_ = zeros(n_rows,2);
  for j=1:n_rows
    s_(j,1) = s(j,1,1) + n*(s(j,2,1) - 1);
    s_(j,2) = s(j,1,2) + n*(s(j,2,2) - 1);
  end
end
