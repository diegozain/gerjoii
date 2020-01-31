function [parame_,gerjoii_] = dc_image_2d(geome_,parame_,finite_,gerjoii_)

% choose source:
% "ia" is index for a_spacing (a=src_a(ia)) of shot.
%       "ia" should be an integer between 1 and numel( src_a )
% "in" is index for n_spacing (n=an_spacings{ia}(in)) position of shot.
%       "in" should be an integer between 1 and src_n(ia).
src_n = gerjoii_.dc.src_n;
src_a = gerjoii_.dc.src_a;

% robin
robin = parame_.dc.robin;
nx = finite_.dc.nx;
nz = finite_.dc.nz;

tol_iter = gerjoii_.dc.tol_iter;
tol_error = gerjoii_.dc.tol_error;

E = [];
E_ = Inf;
iter = 0;
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  
  % shuffle "a" spacings order
  IA = randperm( numel( src_a ) );
  
  % loop over "a" spacings
  for iia=1:numel( src_a );
    
    ia = IA(iia);
    % shuffle "a" spacings order
    IN = randperm( src_n(ia) );
    
    % loop over "n" spacings
    for iin=1:src_n(ia);
      in = IN(iin);
      
      % ---------------
      %   choose source
      % ---------------
      
      % choose source, receivers, measuring operator, observed data & std
      [parame_,gerjoii_] = dc_choose(parame_,finite_,gerjoii_,ia,in);
      
      % --------
      %    image
      % --------
      
      % expand to robin
      [parame_,~,~] = dc_exp2robin(geome_,parame_,finite_,gerjoii_);
      % fwd model
      [gerjoii_,finite_] = dc_fwd2d(parame_,finite_,gerjoii_);
      % gradient of data
      gerjoii_ = dc_gradient_2d(parame_,finite_,gerjoii_);
      % filter gradient
      gerjoii_ = dc_regularize_2d(gerjoii_);
      %
      % step size
      step_ = dc_pica(geome_,parame_,finite_,gerjoii_);
      % update
      dsigma = -step_*gerjoii_.dc.g_2d;
      parame_.dc.sigma = parame_.dc.sigma .* exp(step_*parame_.dc.sigma .* dsigma); 
      % obj
      e_2d = gerjoii_.dc.e_2d;
      Ndc = sparse_diag(parame_.natu.dc.N);
      E_ = E_ + dc_E(e_2d,Ndc)/src_n(ia);
    end % for "n-spacing"
  end % for "a-spacing"
  % figure; fancy_imagesc(dsigma',geome_.X,geome_.Y);
  % title('dsigma')
  % pause;
  E_ = E_/numel( src_a );
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  E = [E E_];
  iter = iter+1;
end % while
gerjoii_.dc.E = E;
end

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

function [parame_,gerjoii_] = dc_choose(parame_,finite_,gerjoii_,ia,in)
  % build source
  gerjoii_ = dc_sosi(gerjoii_,finite_,ia,in);
  % choose receivers for that source
  gerjoii_.dc.r = gerjoii_.dc.receivers_vectorized{ia}{in};
  % build M for that source
  gerjoii_ = dc_M(finite_,gerjoii_);
  % choose observed data
  parame_.natu.dc.d_2d = parame_.natu.dc.data_2d{ia}{in};
  % choose standard deviation
  parame_.natu.dc.N = parame_.natu.dc.std_2d{ia}{in};
end