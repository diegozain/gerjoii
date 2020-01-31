function [finite_,gerjoii_] = w_fwd_all(geome_,parame_,finite_,gerjoii_,is)
% ------------------------------------------------------------------------------
%
% solves a 2d electromagnetic wave with Ez and (Hx,Hy) fields.
% 
% does this with minimal ram usage,
% so code might be tricky to read.
%
% if you want to read this file, 
% 
%               buckle up buckaroo!!
%
% ------------------------------------------------------------------------------
eps_0 = parame_.w.eps_0;
mu_0 = parame_.w.mu_0;
dx = geome_.dx;
dy = geome_.dy;
dt = geome_.w.dt;
nx = finite_.w.nx;
ny = finite_.w.ny;
nt = geome_.w.nt;
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
pml_w = finite_.w.pml_w;
pml_d = finite_.w.pml_d;
pml_order = finite_.w.pml_order;
air = parame_.w.air;
%
R_0 = finite_.w.R_0;
c = 1/sqrt(mu_0*eps_0);
%
Mw = gerjoii_.w.M;
wvlet_ = gerjoii_.w.wvlet_;
domain_i = finite_.w.domain_i;
domain_j = finite_.w.domain_j;
tau = parame_.w.tau;
%
nxm1 = nx-1;
nxp1 = nx+1;
nym1 = ny-1;
nyp1 = ny+1;
% ..............................................................................
% expand materials to pml: from w_exp2pml.m
% ..............................................................................
% load private variables
epsilon_w = parame_.w.epsilon;
sigma_w = parame_.w.sigma;
%-----------------
% build materials
%-----------------
[m,n] = size(epsilon_w);
% air
eps_r_z = [ones(air,n);epsilon_w];
sigma_e_z = [zeros(air,n);sigma_w];
% sides
left = ones(pml_w,1) * eps_r_z(:,1)';
left = left';
right = ones(pml_w,1) * eps_r_z(:,end)';
right = right';
eps_r_z = [left, eps_r_z, right];
sigma_e_z = [zeros(air+m,pml_w), sigma_e_z, zeros(air+m,pml_w)];
% bottom & top
up = ones(pml_d,1) * eps_r_z(1,:);
down = ones(pml_d,1) * eps_r_z(end,:);
eps_r_z = [up; eps_r_z;down];
sigma_e_z = [zeros(pml_d,n + 2*pml_w); sigma_e_z;zeros(pml_d,n + 2*pml_w)];
% change variable type
eps_r_z = eps_r_z;
sigma_e_z = sigma_e_z;
% % save variables 
% finite_.w.eps_r_z = eps_r_z;
% finite_.w.sigma_e_z = sigma_e_z;
% clear variables
clear epsilon_w sigma_w m n left right up down;
% ..............................................................................
% init coefficients for pml: from w_cpml.m
% ..............................................................................
%-------------------------%
% for left  side (sigmax) %
%-------------------------%
sigma_pex_xn = zeros(pml_w,nym1); 
sigma_pmx_xn = zeros(pml_w,nym1); 			  
sigma_max = -(pml_order+1) ...
	    * 1 * eps_0 * (c/sqrt(1)) * log(R_0)/(2*dx*pml_w); 
rho_e = ((pml_w:-1:1) - 0.75)/pml_w; 
rho_m = ((pml_w:-1:1) - 0.25)/pml_w; 
for ind = 1:pml_w 
    sigma_pex_xn(ind,:) = sigma_max * rho_e(ind)^pml_order; 
    sigma_pmx_xn(ind,:) = ... 
        (mu_0/eps_0) * sigma_max * rho_m(ind)^pml_order; 
end 
% Coeffiecients updating Hy 
finite_.w.cpml.Chyh_xn  =  (2*mu_0 - dt*sigma_pmx_xn)./(2*mu_0 + dt*sigma_pmx_xn); 
finite_.w.cpml.Chyez_xn =  (2*dt/dx)./(2*mu_0 + dt*sigma_pmx_xn); 
% Coeffiecients updating Ezx 
finite_.w.cpml.Cezxe_xn  =  (2*eps_0 - dt*sigma_pex_xn)./(2*eps_0 + dt*sigma_pex_xn); 
finite_.w.cpml.Cezxhy_xn =  (2*dt/dx)./(2*eps_0 + dt*sigma_pex_xn); 
% Coeffiecients updating Ezy 
finite_.w.cpml.Cezye_xn  =  1; 
finite_.w.cpml.Cezyhx_xn = -dt/(dy*eps_0);
% clear variables
clear sigma_pex_xn sigma_pmx_xn sigma_max rho_e rho_m ind;
%-------------------------%
% for right side (sigmax) %
%-------------------------%
sigma_pex_xp = zeros(pml_w,nym1); 
sigma_pmx_xp = zeros(pml_w,nym1); 
sigma_max = -(pml_order+1)...
	    * 1 * eps_0 * (c/sqrt(1)) * log(R_0)/(2*dx*pml_w); 
rho_e = ((1:pml_w) - 0.75)/pml_w; 
rho_m = ((1:pml_w) - 0.25)/pml_w; 
for ind = 1:pml_w 
    sigma_pex_xp(ind,:) = sigma_max * rho_e(ind)^pml_order; 
    sigma_pmx_xp(ind,:) = ... 
        (mu_0/eps_0) * sigma_max * rho_m(ind)^pml_order; 
end 
% the vector inside eps_r_z comes from the part of H 
% that Chyh_xp (just below this line) multiplies, 
% see manual for visual of this.
sigma_pmx_xp = sigma_pmx_xp ./ eps_r_z(pie:nx,2:ny);
% Coeffiecients updating Hy 
finite_.w.cpml.Chyh_xp  =  (2*mu_0 - dt*sigma_pmx_xp)./(2*mu_0 + dt*sigma_pmx_xp); 
finite_.w.cpml.Chyez_xp =  (2*dt/dx)./(2*mu_0 + dt*sigma_pmx_xp); 
% Coeffiecients updating Ezx 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezxe_xp (just below this line) multiplies, 
% see manual for visual of this.
finite_.w.cpml.Cezxe_xp  =  (2*eps_0*eps_r_z(pie:nx,2:ny) - dt*sigma_pex_xp) ./ ...
             (2*eps_0*eps_r_z(pie:nx,2:ny) + dt*sigma_pex_xp); 
finite_.w.cpml.Cezxhy_xp =  (2*dt/dx) ./ ...
             (2*eps_0*eps_r_z(pie:nx,2:ny) + dt*sigma_pex_xp); 
% Coeffiecients updating Ezy 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezyhx_xp (just below this line) multiplies, 
% see manual for visual of this.
finite_.w.cpml.Cezye_xp  =  1; 
finite_.w.cpml.Cezyhx_xp = -dt ./ (dy*eps_0*eps_r_z(pie:nx,pjs+1:pje-1));
% clear variables
clear sigma_pex_xp sigma_pmx_xp sigma_max rho_e rho_m ind;
%-------------------------%
% for low   side (sigmay) %
%-------------------------%
sigma_pey_yn = zeros(nxm1,pml_d); 
sigma_pmy_yn = zeros(nxm1,pml_d); 
sigma_max = -(pml_order+1)...
	    * 1 * eps_0 * (c/sqrt(1)) * log(R_0)/(2*dy*pml_d);  
rho_e = ([pml_d:-1:1] - 0.75)/pml_d; 
rho_m = ([pml_d:-1:1] - 0.25)/pml_d; 
for ind = 1:pml_d 
    sigma_pey_yn(:,ind) = sigma_max * rho_e(ind)^pml_order; 
    sigma_pmy_yn(:,ind) = ... 
        (mu_0/(eps_0)) * sigma_max * rho_m(ind)^pml_order; 
end
% the vector inside eps_r_z comes from the part of H 
% that Chyh_xp (just below this line) multiplies, 
% see manual for visual of this.
sigma_pmy_yn = sigma_pmy_yn ./ eps_r_z(2:nx,1:pjs-1);
% Coeffiecients updating Hx 
finite_.w.cpml.Chxh_yn  =  (2*mu_0 - dt*sigma_pmy_yn)./(2*mu_0 + dt*sigma_pmy_yn); 
finite_.w.cpml.Chxez_yn = -(2*dt/dy)./(2*mu_0 + dt*sigma_pmy_yn); 
% Coeffiecients updating Ezx 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezxhy_yn (just below this line) multiplies, 
% see manual for visual of this.
finite_.w.cpml.Cezxe_yn  =  1; 
finite_.w.cpml.Cezxhy_yn =  dt ./ (dx*eps_0 .* eps_r_z(pis+1:pie-1,2:pjs)); 
% Coeffiecients updating Ezy 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezye_yn (just below this line) multiplies, 
% see manual for visual of this.
finite_.w.cpml.Cezye_yn  =  (2*eps_0*eps_r_z(2:nx,2:pjs) - dt*sigma_pey_yn)./...
             (2*eps_0*eps_r_z(2:nx,2:pjs) + dt*sigma_pey_yn); 
finite_.w.cpml.Cezyhx_yn = -(2*dt/dy) ./ ...
             (2*eps_0*eps_r_z(2:nx,2:pjs) + dt*sigma_pey_yn);
% clear variables
clear sigma_pey_yn sigma_pmy_yn sigma_max rho_e rho_m ind;
%-------------------------%
% for upper side (sigmay) %
%-------------------------%
sigma_pey_yp = zeros(nxm1,pml_d); 
sigma_pmy_yp = zeros(nxm1,pml_d); 
% *eps_0*c*
sigma_max = -(pml_order+1)...
	    * 1 * eps_0 * (c/sqrt(1)) *  log(R_0)/(2*dy*pml_d); 
rho_e = ([1:pml_d] - 0.75)/pml_d; 
rho_m = ([1:pml_d] - 0.25)/pml_d; 
for ind = 1:pml_d 
    sigma_pey_yp(:,ind) = sigma_max * rho_e(ind)^pml_order; 
    sigma_pmy_yp(:,ind) = ... 
        (mu_0/eps_0) * sigma_max * rho_m(ind)^pml_order; 
end 
% the vector inside eps_r_z comes from the part of H 
% that Chxh_yp (just below this line) multiplies, 
% see manual for visual of this.
sigma_pmy_yp = sigma_pmy_yp ./ eps_r_z(2:end,pje:ny);
% Coeffiecients updating Hx 
finite_.w.cpml.Chxh_yp  =  (2*mu_0 - dt*sigma_pmy_yp)./(2*mu_0 + dt*sigma_pmy_yp); 
finite_.w.cpml.Chxez_yp = -(2*dt/dy)./(2*mu_0 + dt*sigma_pmy_yp); 
% Coeffiecients updating Ezx 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezxe_yp (just below this line) multiplies, 
% see manual for visual of this.
finite_.w.cpml.Cezxe_yp  =  1; 
finite_.w.cpml.Cezxhy_yp =  dt ./ (dx*eps_0*eps_r_z(pis+1:pie-1,pje:ny)); 
% Coeffiecients updating Ezy 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezye_yp (just below this line) multiplies, 
% see manual for visual of this.
finite_.w.cpml.Cezye_yp  =  (2*eps_0*eps_r_z(2:nx,pje:ny) - dt*sigma_pey_yp) ./ ...
             (2*eps_0*eps_r_z(2:nx,pje:ny) + dt*sigma_pey_yp); 
finite_.w.cpml.Cezyhx_yp = -(2*dt/dy) ./ ...
             (2*eps_0*eps_r_z(2:nx,pje:ny) + dt*sigma_pey_yp);
% clear variables
clear sigma_pey_yp sigma_pmy_yp sigma_max rho_e rho_m ind;
% ..............................................................................
% init inner coeffiecients: from w_coeff.m
% ..............................................................................
% load private variables
mu_r_x    = parame_.w.mu_r_x;
sigma_m_x = parame_.w.sigma_m_x;
mu_r_y    = parame_.w.mu_r_y;
sigma_m_y = parame_.w.sigma_m_y;
s_w = gerjoii_.w.s;
% for inner nodes.
%---------------------------% 
% Coeffiecients updating Ez %
%---------------------------%
finite_.w.coeff.Ceze  =  (2*eps_r_z*eps_0 - dt*sigma_e_z)./(2*eps_r_z*eps_0 + dt*sigma_e_z); 
finite_.w.coeff.Cezhy =  (2*dt/dx)./(2*eps_r_z*eps_0 + dt*sigma_e_z); 
finite_.w.coeff.Cezhx = -(2*dt/dy)./(2*eps_r_z*eps_0 + dt*sigma_e_z); 
%---------------------------%
% Coeffiecients updating Hx %
%---------------------------%
finite_.w.coeff.Chxh  =  (2*mu_r_x*mu_0 - dt*sigma_m_x)./(2*mu_r_x*mu_0 + dt*sigma_m_x); 
finite_.w.coeff.Chxez = -(2*dt/dy)./(2*mu_r_x*mu_0 + dt*sigma_m_x); 
%---------------------------%
% Coeffiecients updating Hy %
%---------------------------%
finite_.w.coeff.Chyh  =  (2*mu_r_y*mu_0 - dt*sigma_m_y)./(2*mu_r_y*mu_0 + dt*sigma_m_y); 
finite_.w.coeff.Chyez =  (2*dt/dx)./(2*mu_r_y*mu_0 + dt*sigma_m_y); 
%---------------------------%
% Coeffiecients updating Jz %
%---------------------------%
finite_.w.coeff.Cezj = -(2*dt)/ ... 
        (2*eps_r_z(s_w(1),s_w(2))*eps_0 + dt*sigma_e_z(s_w(1),s_w(2)));
% clear local variables
clear  mu_r_x sigma_m_x mu_r_y sigma_m_y;
clear eps_r_z sigma_e_z;
% ..............................................................................
% solve the wave: from w_solve_.m
% ..............................................................................
%------------------------------
% intialize fields and outputs
%------------------------------
% time counter
current_time = 0;
% .....................
% init pml fields
% .....................
% NOTE change these to singles: zeros(size,'single')
Ezx_xn = zeros(pml_w,nym1);
Ezy_xn = zeros(pml_w,nym1-pml_d-pml_d); 
Ezx_xp = zeros(pml_w,nym1);
Ezy_xp = zeros(pml_w,nym1-pml_d-pml_d); 
Ezx_yn = zeros(nxm1-pml_w-pml_w, pml_d); 
Ezy_yn = zeros(nxm1,pml_d);
Ezx_yp = zeros(nxm1-pml_w-pml_w, pml_d); 
Ezy_yp = zeros(nxm1,pml_d);
% .....................
% init inner fields
% .....................
% NOTE make these 'simple'
Hx = zeros(nxp1,ny);    
Hy = zeros(nx,nyp1);    
Ez = zeros(nxp1,nyp1);
% observed wavefield (time series)
d_w = zeros(nt,length(Mw(2:end)));
if is~=0
  % wavefield
  u_w = zeros(numel(domain_i(:)),numel(domain_j(:)),nt);
end
% point observation of source
Jz = zeros(nt,1);
% ........................
% time loop
% ........................
for it = 1:nt
  % --------
  % updates
  %---------
  % update H and H_pml
  current_time  = current_time + dt/2;
  %-------------
  % inner Hx,Hy
  %-------------
  Hx(:,pjs:pje-1) = finite_.w.coeff.Chxh(:,pjs:pje-1) .* Hx(:,pjs:pje-1) ... 
      + finite_.w.coeff.Chxez(:,pjs:pje-1) .* (Ez(:,pjs+1:pje)-Ez(:,pjs:pje-1));  
  Hy(pis:pie-1,:) = finite_.w.coeff.Chyh(pis:pie-1,:) .* Hy(pis:pie-1,:) ... 
      + finite_.w.coeff.Chyez(pis:pie-1,:) .* (Ez(pis+1:pie,:)-Ez(pis:pie-1,:));
  %-------------
  % pml Hx,Hy
  %-------------
  %-------------------------
  % for left  side (sigmax) 
  %-------------------------
  Hy(1:pis-1,2:ny) = finite_.w.cpml.Chyh_xn .* Hy(1:pis-1,2:ny) ... 
      + finite_.w.cpml.Chyez_xn .* (Ez(2:pis,2:ny)-Ez(1:pis-1,2:ny));   
  %-------------------------
  % for right  side (sigmax)
  %-------------------------
  Hy(pie:nx,2:ny) = finite_.w.cpml.Chyh_xp .* Hy(pie:nx,2:ny) ... 
  + finite_.w.cpml.Chyez_xp .* (Ez(pie+1:nxp1,2:ny)-Ez(pie:nx,2:ny));  
  %-------------------------
  % for low  side (sigmay) 
  %-------------------------
  Hx(2:nx,1:pjs-1) = finite_.w.cpml.Chxh_yn .* Hx(2:nx,1:pjs-1) ... 
      + finite_.w.cpml.Chxez_yn.*(Ez(2:nx,2:pjs)-Ez(2:nx,1:pjs-1));  
  %-------------------------
  % for upper  side (sigmay)
  %-------------------------
  Hx(2:nx,pje:ny) = finite_.w.cpml.Chxh_yp .* Hx(2:nx,pje:ny) ... 
      + finite_.w.cpml.Chxez_yp.*(Ez(2:nx,pje+1:nyp1)-Ez(2:nx,pje:ny));
  % .....................................
  % update Ez, Jz and Ez_pml
  current_time  = current_time + dt/2;
  %-------------
  % inner Ez
  %-------------
  Ez(pis+1:pie-1,pjs+1:pje-1) = ... 
  finite_.w.coeff.Ceze(pis+1:pie-1,pjs+1:pje-1).*Ez(pis+1:pie-1,pjs+1:pje-1) ... 
          + finite_.w.coeff.Cezhy(pis+1:pie-1,pjs+1:pje-1) ... 
          .* (Hy(pis+1:pie-1,pjs+1:pje-1)-Hy(pis:pie-2,pjs+1:pje-1)) ... 
          + finite_.w.coeff.Cezhx(pis+1:pie-1,pjs+1:pje-1) ... 
          .* (Hx(pis+1:pie-1,pjs+1:pje-1)-Hx(pis+1:pie-1,pjs:pje-2));
  %
  % source
  Ez(s_w(1),s_w(2)) = Ez(s_w(1),s_w(2)) + finite_.w.coeff.Cezj * wvlet_(it);
  % -------------
  % pml Ez
  % -------------
  %-------------------------
  % for left  side (sigmax) 
  %-------------------------
  Ezx_xn = finite_.w.cpml.Cezxe_xn .* Ezx_xn ... 
      + finite_.w.cpml.Cezxhy_xn .* (Hy(2:pis,2:ny)-Hy(1:pis-1,2:ny)); 
  Ezy_xn = finite_.w.cpml.Cezye_xn .* Ezy_xn ... 
      + finite_.w.cpml.Cezyhx_xn .* (Hx(2:pis,pjs+1:pje-1)-Hx(2:pis,pjs:pje-2)); 
  %-------------------------
  % for right side (sigmax) 
  %-------------------------
  Ezx_xp = finite_.w.cpml.Cezxe_xp .* Ezx_xp + finite_.w.cpml.Cezxhy_xp.*  ... 
      (Hy(pie:nx,2:ny)-Hy(pie-1:nx-1,2:ny)); 
  Ezy_xp = finite_.w.cpml.Cezye_xp .* Ezy_xp ... 
      + finite_.w.cpml.Cezyhx_xp .* (Hx(pie:nx,pjs+1:pje-1)-Hx(pie:nx,pjs:pje-2)); 
  %-------------------------
  % for low   side (sigmax) 
  %-------------------------
  Ezx_yn = finite_.w.cpml.Cezxe_yn .* Ezx_yn ... 
      + finite_.w.cpml.Cezxhy_yn .* (Hy(pis+1:pie-1,2:pjs)-Hy(pis:pie-2,2:pjs)); 
  Ezy_yn = finite_.w.cpml.Cezye_yn .* Ezy_yn ... 
      + finite_.w.cpml.Cezyhx_yn .* (Hx(2:nx,2:pjs)-Hx(2:nx,1:pjs-1)); 
  %-------------------------
  % for upper side (sigmax) 
  %-------------------------
  Ezx_yp = finite_.w.cpml.Cezxe_yp .* Ezx_yp ... 
      + finite_.w.cpml.Cezxhy_yp .* (Hy(pis+1:pie-1,pje:ny)-Hy(pis:pie-2,pje:ny)); 
  Ezy_yp = finite_.w.cpml.Cezye_yp .* Ezy_yp ... 
      + finite_.w.cpml.Cezyhx_yp .* (Hx(2:nx,pje:ny)-Hx(2:nx,pje-1:ny-1)); 
  %-------------------------
  %     Ez = Ezx + Ezy      
  %-------------------------
  Ez(2:pis,2:pjs)   = Ezx_xn(:,1:pjs-1) + Ezy_yn(1:pis-1,:); 
  Ez(2:pis,pje:ny)  = Ezx_xn(:,pje-1:nym1) + Ezy_yp(1:pis-1,:); 
  Ez(pie:nx,pje:ny) = Ezx_xp(:,pje-1:nym1) + Ezy_yp(pie-1:nxm1,:); 
  Ez(pie:nx,2:pjs)  = Ezx_xp(:,1:pjs-1) + Ezy_yn(pie-1:nxm1,:); 
  Ez(pis+1:pie-1,2:pjs)  = Ezx_yn + Ezy_yn(pis:pie-2,:); 
  Ez(pis+1:pie-1,pje:ny) = Ezx_yp + Ezy_yp(pis:pie-2,:); 
  Ez(2:pis,pjs+1:pje-1)  = Ezx_xn(:,pjs:pje-2) + Ezy_xn; 
  Ez(pie:nx,pjs+1:pje-1) = Ezx_xp(:,pjs:pje-2) + Ezy_xp;
  % --------
  % observe
  %---------
  % observed wavefield (time series)
  d_w(it,:) = Ez(Mw(1),Mw(2:end));
  % ------------------------
  % save wavefield
  % ------------------------
  if is~=0
    % wavefield
    u_w(:,:,it) = Ez(domain_i(:),domain_j(:));
  end
  % recorder of source
  Jz(it) = Ez(s_w(1),s_w(2));
end
% save wavefield
if is~=0
  % wavefield
  gerjoii_.w.u_2d = u_w;
end
% save data
gerjoii_.w.d_2d = d_w;
% clear local variables
clear Ez Hx Hy it current_time u_w d_w;
% ..............................................................................
% mute data
% ..............................................................................
if strcmp(gerjoii_.w.MUTE , 'yes_MUTE')
  gerjoii_ = w_lmute(gerjoii_,parame_);
end
% ..............................................................................
% error
% ..............................................................................
gerjoii_.w.e_2d = gerjoii_.w.d_2d - parame_.natu.w.d_2d;
% ..............................................................................
% clear fields
% ..............................................................................
clear Ezx_xn Ezy_xn Ezx_xp Ezy_xp Ezx_yn Ezy_yn Ezx_yp Ezy_yp;
clear Ez Hx Hy it current_time;
finite_.w = rmfield(finite_.w,'cpml');
finite_.w = rmfield(finite_.w,'coeff');
end