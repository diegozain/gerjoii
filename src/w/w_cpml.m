function finite_ = w_cpml(geome_,parame_,finite_)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% inspired by the book: 
% "the finite-difference time-domain method for 
% electromagnetics with matlab simulations", Atef Z. Elsherbeni.
% ..............................................................................
% computes pml coefficients to be used in finite difference scheme.
% ..............................................................................
eps_0 = single(parame_.w.eps_0);
mu_0 = single(parame_.w.mu_0);
eps_r_z = finite_.w.eps_r_z;
dx = geome_.dx;
dy = geome_.dy;
dt = geome_.w.dt;
nx = finite_.w.nx;
ny = finite_.w.ny;
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
pml_w = single(finite_.w.pml_w);
pml_d = single(finite_.w.pml_d);
pml_order = finite_.w.pml_order;
R_0 = finite_.w.R_0;

c = 1/sqrt(mu_0*eps_0);
nxm1 = single(nx-1);
nym1 = single(ny-1);
% % disp('initializing PML');
% finite_.w.Epml.Ezx_xn = zeros(pml_w,nym1,'single');
% finite_.w.Epml.Ezy_xn = zeros(pml_w,nym1-pml_d-pml_d,'single'); 
% finite_.w.Epml.Ezx_xp = zeros(pml_w,nym1,'single');
% finite_.w.Epml.Ezy_xp = zeros(pml_w,nym1-pml_d-pml_d,'single'); 
% finite_.w.Epml.Ezx_yn = zeros(nxm1-pml_w-pml_w, pml_d,'single'); 
% finite_.w.Epml.Ezy_yn = zeros(nxm1,pml_d,'single');
% finite_.w.Epml.Ezx_yp = zeros(nxm1-pml_w-pml_w, pml_d,'single'); 
% finite_.w.Epml.Ezy_yp = zeros(nxm1,pml_d,'single');
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
%
sigma_pmx_xp = sigma_pmx_xp ./ eps_r_z(pie:nx,2:ny);
% Coeffiecients updating Hy 
finite_.w.cpml.Chyh_xp  =  (2*mu_0 - dt*sigma_pmx_xp)./(2*mu_0 + dt*sigma_pmx_xp); 
finite_.w.cpml.Chyez_xp =  (2*dt/dx)./(2*mu_0 + dt*sigma_pmx_xp); 
% Coeffiecients updating Ezx 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezxe_xp (just below this line) multiplies, 
% see manual for visual of this.
%
finite_.w.cpml.Cezxe_xp  =  (2*eps_0*eps_r_z(pie:nx,2:ny) - dt*sigma_pex_xp) ./ ...
             (2*eps_0*eps_r_z(pie:nx,2:ny) + dt*sigma_pex_xp); 
finite_.w.cpml.Cezxhy_xp =  (2*dt/dx) ./ ...
             (2*eps_0*eps_r_z(pie:nx,2:ny) + dt*sigma_pex_xp); 
% Coeffiecients updating Ezy 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezyhx_xp (just below this line) multiplies, 
% see manual for visual of this.
%
finite_.w.cpml.Cezye_xp  =  1; 
finite_.w.cpml.Cezyhx_xp = -dt ./ (dy*eps_0*eps_r_z(pie:nx,pjs+1:pje-1)); 
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
%
sigma_pmy_yn = sigma_pmy_yn ./ eps_r_z(2:nx,1:pjs-1);
% Coeffiecients updating Hx 
finite_.w.cpml.Chxh_yn  =  (2*mu_0 - dt*sigma_pmy_yn)./(2*mu_0 + dt*sigma_pmy_yn); 
finite_.w.cpml.Chxez_yn = -(2*dt/dy)./(2*mu_0 + dt*sigma_pmy_yn); 
% Coeffiecients updating Ezx 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezxhy_yn (just below this line) multiplies, 
% see manual for visual of this.
%
finite_.w.cpml.Cezxe_yn  =  1; 
finite_.w.cpml.Cezxhy_yn =  dt ./ (dx*eps_0 .* eps_r_z(pis+1:pie-1,2:pjs)); 
% Coeffiecients updating Ezy 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezye_yn (just below this line) multiplies, 
% see manual for visual of this.
%
finite_.w.cpml.Cezye_yn  =  (2*eps_0*eps_r_z(2:nx,2:pjs) - dt*sigma_pey_yn)./...
             (2*eps_0*eps_r_z(2:nx,2:pjs) + dt*sigma_pey_yn); 
finite_.w.cpml.Cezyhx_yn = -(2*dt/dy) ./ ...
             (2*eps_0*eps_r_z(2:nx,2:pjs) + dt*sigma_pey_yn);
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
%
sigma_pmy_yp = sigma_pmy_yp ./ eps_r_z(2:end,pje:ny);
% Coeffiecients updating Hx 
finite_.w.cpml.Chxh_yp  =  (2*mu_0 - dt*sigma_pmy_yp)./(2*mu_0 + dt*sigma_pmy_yp); 
finite_.w.cpml.Chxez_yp = -(2*dt/dy)./(2*mu_0 + dt*sigma_pmy_yp); 
% Coeffiecients updating Ezx 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezxe_yp (just below this line) multiplies, 
% see manual for visual of this.
%
finite_.w.cpml.Cezxe_yp  =  1; 
finite_.w.cpml.Cezxhy_yp =  dt ./ (dx*eps_0*eps_r_z(pis+1:pie-1,pje:ny)); 
% Coeffiecients updating Ezy 
%
% the vector inside eps_r_z comes from the FIRST term of H 
% that Cezye_yp (just below this line) multiplies, 
% see manual for visual of this.
%
finite_.w.cpml.Cezye_yp  =  (2*eps_0*eps_r_z(2:nx,pje:ny) - dt*sigma_pey_yp) ./ ...
             (2*eps_0*eps_r_z(2:nx,pje:ny) + dt*sigma_pey_yp); 
finite_.w.cpml.Cezyhx_yp = -(2*dt/dy) ./ ...
             (2*eps_0*eps_r_z(2:nx,pje:ny) + dt*sigma_pey_yp);
end