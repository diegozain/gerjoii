% diego domenzain
% summer 2020 @ CSM
% ------------------------------------------------------------------------------
% builds relevant parameters to be used in the GPR chopped forward models.
% ------------------------------------------------------------------------------
fprintf('\n       your wave-cube domain is too large \n       and you chose this option to get around that. Pretty clever\n')
% ------------------------------------------------------------------------------
gerjoii_.domain_path = 'domains/';
epsi_name = 'depsi_domain.mat';
sigm_name = 'dsigm_domain.mat';

nddomain = 0.5; % (m) . should be equal to source-source separation
nddomain = floor(nddomain/parame_.dx); % number of grid-points
nx_domain = 11.5;% 9.5; % 5.5; % (m)
nx_domain = floor(nx_domain/parame_.dx); % number of grid-points in mini domain

% for printing the largest size of tiny domains at the end
domain_max = 0;
% ------------------------------------------------------------------------------
for is=1:gerjoii_.w.ns
 % do some magic and come up with
 % ix, ix_, x, and z for mini domain
 % 
 % ix is the index start of the mini domain in the big domain 
 % ix_ is the index end of the mini domain in the big domain 
 % x and z are the discretized length and depth of the mini domain
 
 ix = (is-1)*nddomain + 1;
 ix_= ix + nx_domain - 1;
 
 % if the mini domain end is larger than the big domain end
 if ix_>geome_.n
   ix_ = geome_.n;
   nx_domain = ix_-ix+1;
 end
 
 % if the mini domain end is smaller than the big domain end...
 % for the last source
 if (is==gerjoii_.w.ns) && (ix_<geome_.n)
   ix_ = geome_.n;
   nx_domain = ix_-ix+1;
 end
 
 x  = 0:parame_.dx:((nx_domain-1)*parame_.dx);

 gerjoii_.domain(is).ix = ix;
 gerjoii_.domain(is).ix_= ix_;
 gerjoii_.domain(is).x  = x;
 gerjoii_.domain(is).z  = parame_.z;
 
 % make directories domains/[1,...,ns]
 % and put domain_mini in there with names:
 % epsi_domain.mat and sigm_domain.mat
 domain_mini = struct;
 
 domain_mini.ix = ix;
 domain_mini.domain__ = zeros( numel(gerjoii_.domain(is).z), nx_domain );
 
 mkdir(strcat(gerjoii_.domain_path,num2str(is)));
 save(strcat(gerjoii_.domain_path,num2str(is),'/',epsi_name),'domain_mini');
 save(strcat(gerjoii_.domain_path,num2str(is),'/',sigm_name),'domain_mini');
 
 % for printing useful stuff
 domain_max = max([domain_max,nx_domain]);
end
% ------------------------------------------------------------------------------
fprintf('\n       largest size of wave-cube (no air, no PML) in ** singles ** is %1d (Gb)\n',domain_max*numel(parame_.z)*geome_.w.nt*4*1e-9)
% ------------------------------------------------------------------------------
