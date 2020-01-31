function finite_ = dc_kfourier(finite_,gerjoii_)
% ------------------------------------------------------------------------------
% Function for generating a selection optimized wavenumbers
% and weighting coeff's for use with gerjoii. 
% 
% DELTAS is an (n,m,2) matrix encoding vertical and horizontal discretization 
% lengths.
% s_dc is an (n,1) vector with nonzero entries where sources are.
% n_ky is the number of wanted ky and w_ky values 
% 
% Code modified by Diego Domenzain from original 
% Adam Pidlisecky's 2006 FW2_5D package.
% ------------------------------------------------------------------------------
DELTAS = finite_.dc.DELTAS;
nx = finite_.dc.nx ; % geome_.n;
nz = finite_.dc.nz ; % geome_.m;
s_dc = gerjoii_.dc.s;
s_dc = s_dc(1:nx);
n_ky = finite_.dc.n_ky;
dx = finite_.dx;
% sig_o = gerjoii_.dc.sig_o;
% ------------------------------------------------------------------------------
% constants for optimization
% ---------------------------
% set the maximum number of iterations for the optimization routine
itsmax = 25;
% Number of linesearch steps
lsnum = 10;
% linesearch lower bound
ls_low_lim = 0.01;
% linesearch upper bound
ls_up_lim =0.9;
%  objective function history
obj = [];
% ------------
% distances
% ------------
if ~isfield(finite_.dc,'radius')
  [CO,ca] = dc_coca(nx,nz,DELTAS,s_dc);

  r  = sqrt(CO(:,:,1).^2 + ca(:,:).^2);
  r_ = sqrt(CO(:,:,2).^2 + ca(:,:).^2);
  r = r(:); r_ = r_(:);
  R = unique([r r_],'rows');
  r = R(:,1); r_ = R(:,2);
  I = find(r); r = r(I); r_ = r_(I);
  I = find(r_); r = r(I); r_ = r_(I);

  % reduce size of matrix K,
  r  = linspace( min(r),max(r),fix( 10^(log10(numel(r))*0.7) )).';
  r_ = linspace( min(r_),max(r_),fix( 10^(log10(numel(r_))*0.7) )).';
  
  R = ( (1./r) - (1./r_) ); R = 1 ./ R;
  I = find(~isinf(R));
  R = R(I); r = r(I); r_ = r_(I);
  R = R * ones(1,n_ky);
  
  % store
  finite_.dc.radius = [r,r_];
  finite_.dc.Radius = R;
else
  r = finite_.dc.radius(:,1);
  r_ = finite_.dc.radius(:,2);
  R = finite_.dc.Radius;
end
% ------------------------
% Calculate the K matrix
% ------------------------
% initialize a starting guess for kyo
kyo = logspace(-2,0.5,n_ky) * dx;
% kyo = linspace(0.01,10,n_ky) * dx;  
kyo = kyo';
% kyr values matrix   
kyr = r * kyo'; 
kyr_= r_ * kyo';
% Calculate the K matrix
K = (2/pi) * R.*real(besselk(0,kyr) - besselk(0,kyr_));
% ----------------------------------
% Estimate v for the given ky values
% ----------------------------------
% UNO vector. uno means one in spanish.
UNO = ones(size(K,1),1);
v = K*( (K'*K + 1e-7*eye(n_ky)) \ (K'*UNO) ); % 1e-8
% Evaluate the objective function for the initial guess
obj = [obj (1-v)'*(1-v)];
% -------------------------------------------------------
% Start counter and initialize the optimization
% -------------------------------------------------------
its = 1; % iteration counter
ky = kyo; % updated ky vector
stopper = 0; % Stopping toggle in case A becomes illconditioned
reduction = 1; % Variable to ensure sufficent decrease between iterations
% Optimization terminates if objective function is not
% reduced by at least 5% at each iteration
while obj > 1e-5 & its<itsmax & stopper == 0 & reduction > 0.05; 
  % ------------------------------
  % Create the derivative matrix
  % ------------------------------
  J = zeros(size(K));
  for i = 1:n_ky;
    k_ = ky;
    k_(i) = 1.05*k_(i);
    % kyr values matrix   
    kyr = r * k_';
    kyr_ = r_ * k_';
    % Calculate the K matrix
    K_ = (2/pi) * R.*real( besselk(0,kyr) - besselk(0,kyr_) );
    % Estimate v for the given k_ values
    v_ = K_ * ( (K_'*K_ + 1e-8*eye(n_ky)) \ (K_'*UNO) );
    % Calculate the derivative for the appropriate column
    J(:,i) = (v_-v) / (k_(i)-ky(i));
  end % for: derivative matrix
  % ------------------------------------
  % Apply some smallness regularization
  % ------------------------------------
  grad = J'*(1-v) + 1e-8*eye(n_ky)*ky;
  dky = ( J'*J + 1e-8*eye(n_ky) ) \ grad;
  % ------------------------------------------------
  % Perform a line-search to maximize the descent 
  % ------------------------------------------------
  ls_ = linspace(ls_low_lim,ls_up_lim,lsnum);
  warning off;
  for j=1:lsnum
    k_ = ky + ls_(j)*dky;    
    % ------------------------
    % Calculate the K matrix
    % ------------------------
    % kyr values matrix   
    kyr = r * k_';
    kyr_ = r_ * k_';
    % Calculate the K matrix
    K_ = (2/pi) * R.*real(besselk(0,kyr) - besselk(0,kyr_));
    % ----------------------------------
    % Estimate v for the given k_ values
    % ----------------------------------
    v_ = K_*( (K_'*K_ + 1e-8*eye(n_ky)) \ (K_'*UNO) );
    objt = (1-v_)'*(1-v_);
    ls_res(j,:) = [objt ls_(j)];
  end % for line-search
  warning on;
  % Find the smallest objective function from the line-search
  [b,c] = (min(ls_res(:,1)));
  % ---------------------------
  % Create a new guess for ky
  % ---------------------------
  ky = ky + ls_(c)*dky;
  % ------------------------
  % Calculate the K matrix
  % ------------------------
  % kyr values matrix   
  kyr = r * ky';
  kyr_ = r_ * ky';
  % Calculate the K matrix
  K = (2/pi) * R.*real(besselk(0,kyr) - besselk(0,kyr_));
  % ----------------------------------
  % Estimate v for the given ky values
  % ----------------------------------
  v = K*( (K'*K + 1e-8*eye(n_ky)) \ (K'*UNO) );
  % eval obj funct
  obj= [obj (1-v)'*(1-v)];
  reduction = (obj(its) / obj(its+1)) - 1;         
  its = its+1;
  % ------------------------------------
  % Check the conditioning of the matrix
  % NOTE: change this if the v is not 
  %       correctly solved for!
  % ------------------------------------
  if or(rcond(K'*K) < 1e-15,sum(isnan(v))~=0); % 1e-15
    ky = ky - ls_(c)*dky;
    stopper = 1;
  end
end % while
% --------------------
% Get the RMS fit 
% --------------------
err = sqrt(obj./numel(r));
% --------------------
% The final ky values
% --------------------
ky = abs(ky);
% ----------------------------------------
%  Reform K to obtian the final w_ky values
% ----------------------------------------
% kyr values matrix   
kyr = r * ky';
kyr_ = r_ * ky';
% Calculate the K matrix
K = (2/pi) * R.*real(besselk(0,kyr) - besselk(0,kyr_));
w_ky = (K'*K + 0*eye(n_ky)) \ (K'*UNO);
finite_.dc.ky_w_ = [ ky*dx , w_ky ];
% figure;
% plot(v,'k.','Markersize',10);axis tight
end