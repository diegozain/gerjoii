function [g_w,a_max] = w_grad(u_w,geome_,finite_,gerjoii_,parame_)  
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
% compute gradient of EM wave g_w using the adjoint method
% (aka full-waveform inversion)
% ------------------------------------------------------------------------------
e_w = gerjoii_.w.e_2d;                   
Mw = gerjoii_.w.M;
dt = geome_.w.dt;
nt = geome_.w.nt;
nx = finite_.w.nx;
ny = finite_.w.ny;
pml_w = finite_.w.pml_w;
pml_d = finite_.w.pml_d;
domain_i = finite_.w.domain_i;
domain_j = finite_.w.domain_j;
X = geome_.X;
Y = geome_.Y;
% ----------------------------------------
% dt <-- -dt nonsense for backpropagation
% ----------------------------------------
% init coefficients for pml
finite_ = w_cpml(geome_,parame_,finite_);
% init inner coeffiecients
finite_.w.sigma_e_z = - finite_.w.sigma_e_z;
finite_ = w_coeff(geome_,parame_,finite_,gerjoii_);
% solves the 2D EM wave equation on a rectangular grid on 
% finite difference time domain Yee grid with
% PML boundary conditions for the adjoint field,
% and calculates the gradient of the 
% sum squared error objective function.
%
% computational domain within the pml is:
%
% domain = [ants_i;ants_j]
% ants_i = pis+1:pie-1;   % x axis
% ants_j = pjs+1:pje-1;   % y axis
nxm1 = nx-1;
nxp1 = nx+1;
nym1 = ny-1;
nyp1 = ny+1;                       
%---------------------------------------------
% intialize fields and outputs
%---------------------------------------------
% .....................
% init pml fields
% .....................
finite_.w.Epml.Ezx_xn = zeros(pml_w,nym1,'single');
finite_.w.Epml.Ezy_xn = zeros(pml_w,nym1-pml_d-pml_d,'single'); 
finite_.w.Epml.Ezx_xp = zeros(pml_w,nym1,'single');
finite_.w.Epml.Ezy_xp = zeros(pml_w,nym1-pml_d-pml_d,'single'); 
finite_.w.Epml.Ezx_yn = zeros(nxm1-pml_w-pml_w, pml_d,'single'); 
finite_.w.Epml.Ezy_yn = zeros(nxm1,pml_d,'single');
finite_.w.Epml.Ezx_yp = zeros(nxm1-pml_w-pml_w, pml_d,'single'); 
finite_.w.Epml.Ezy_yp = zeros(nxm1,pml_d,'single');
% init fields
Hx = zeros(nxp1,ny,'single');    
Hy = zeros(nx,nyp1,'single');    
Ez = zeros(nxp1,nyp1,'single');

% gradient
g_w = zeros( numel(domain_i(:)),numel(domain_j(:)),'single' );
% adjoint (for Kurzmann's filter)
a_w_ = zeros(numel(domain_i(:)),numel(domain_j(:)),'single');

for it = 0:nt-1
% --------
% updates
%---------
% give observed as sources
Ez(Mw) = e_w(nt-it,:);
% Ez(Mw(1),Mw(2:end)) = e_w(nt-it,:);
% current_time  = current_time + dt/2;
% update H and H_pml
% current_time  = current_time + dt/2;
[Hx,Hy] = new_H(Hx,Hy,Ez,finite_);
[Hx,Hy] = new_H_pml(Hx,Hy,Ez,finite_);
% update Ez, Jz and Ez_pml
% current_time  = current_time + dt/2;
Ez = new_Ez(Hx,Hy,Ez,finite_);
% pml
[Ez,finite_] = new_Ez_pml(Hx,Hy,Ez,finite_);

% crosscorrelation of wavefields
a_w = Ez(domain_i(:),domain_j(:));
g_w = g_w - (u_w(:,:,nt-it) .* a_w);

% for Kurzmann's preconditioner
A(:,:,1) = a_w_;
A(:,:,2) = a_w;
a_max = max(abs(A),[],3);
a_w_ = a_w;
% %------------------------------------------------------------------------
%    
%    % display
%    %
%    figure(1);
%    imagesc(X,Y,g_w(:,:));
%    colormap(b2r(-1e-3, 1e-3))
%    caxis([-1e-3, 1e-3]);
%    axis square;
%    title(['time [ns]: ' num2str(dt*it/1e-9)]);
%    getframe;
%    
% %------------------------------------------------------------------------
end
g_w = dt*g_w;
% for Kurzmann's preconditioner
A(:,:,1) = a_w_;
A(:,:,2) = a_w;
a_max = max(abs(A),[],3);
% clean
finite_.w = rmfield(finite_.w,'Epml');
end
%-----------------------------^^^^^^^^^^^^^^^-----------------------------%
%----------------------------- local methods -----------------------------%
%-----------------------------_______________-----------------------------%
%-------------------------------------------------------------------------
%
%       new H
%
%-------------------------------------------------------------------------
function [Hx,Hy] = new_H(Hx,Hy,Ez,finite_)
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
%-------------
% inner
%------------
Hx(:,pjs:pje-1) = finite_.w.coeff.Chxh(:,pjs:pje-1) .* Hx(:,pjs:pje-1) ... 
    + finite_.w.coeff.Chxez(:,pjs:pje-1) .* (Ez(:,pjs+1:pje)-Ez(:,pjs:pje-1));  
Hy(pis:pie-1,:) = finite_.w.coeff.Chyh(pis:pie-1,:) .* Hy(pis:pie-1,:) ... 
    + finite_.w.coeff.Chyez(pis:pie-1,:) .* (Ez(pis+1:pie,:)-Ez(pis:pie-1,:));
end
%-------------------------------------------------------------------------
%
%       new H pml
%
%-------------------------------------------------------------------------
function [Hx,Hy] = new_H_pml(Hx,Hy,Ez,finite_)
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
nx = finite_.w.nx;
ny = finite_.w.ny;
nxp1 = nx+1;
nyp1 = ny+1;
%-------------
% pml
%------------
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
end
%-------------------------------------------------------------------------
%
%       new Ez
%
%-------------------------------------------------------------------------
function Ez = new_Ez(Hx,Hy,Ez,finite_)
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
%---------
% inner
%---------
Ez(pis+1:pie-1,pjs+1:pje-1) = ... 
finite_.w.coeff.Ceze(pis+1:pie-1,pjs+1:pje-1).*Ez(pis+1:pie-1,pjs+1:pje-1) ... 
        + finite_.w.coeff.Cezhy(pis+1:pie-1,pjs+1:pje-1) ... 
        .* (Hy(pis+1:pie-1,pjs+1:pje-1)-Hy(pis:pie-2,pjs+1:pje-1)) ... 
        + finite_.w.coeff.Cezhx(pis+1:pie-1,pjs+1:pje-1) ... 
        .* (Hx(pis+1:pie-1,pjs+1:pje-1)-Hx(pis+1:pie-1,pjs:pje-2));
end
%-------------------------------------------------------------------------
%
%       new Ez pml
%
%-------------------------------------------------------------------------
function [Ez,finite_] = new_Ez_pml(Hx,Hy,Ez,finite_)
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
nx = finite_.w.nx;
ny = finite_.w.ny;
nxm1 = nx-1;
nym1 = ny-1;
%---------
% pml
%---------
%-------------------------
% for left  side (sigmax) 
%-------------------------
    finite_.w.Epml.Ezx_xn = finite_.w.cpml.Cezxe_xn .* finite_.w.Epml.Ezx_xn ... 
        + finite_.w.cpml.Cezxhy_xn .* (Hy(2:pis,2:ny)-Hy(1:pis-1,2:ny)); 
    finite_.w.Epml.Ezy_xn = finite_.w.cpml.Cezye_xn .* finite_.w.Epml.Ezy_xn ... 
        + finite_.w.cpml.Cezyhx_xn .* (Hx(2:pis,pjs+1:pje-1)-Hx(2:pis,pjs:pje-2)); 
%-------------------------
% for right side (sigmax) 
%-------------------------
    finite_.w.Epml.Ezx_xp = finite_.w.cpml.Cezxe_xp .* finite_.w.Epml.Ezx_xp + finite_.w.cpml.Cezxhy_xp.*  ... 
        (Hy(pie:nx,2:ny)-Hy(pie-1:nx-1,2:ny)); 
    finite_.w.Epml.Ezy_xp = finite_.w.cpml.Cezye_xp .* finite_.w.Epml.Ezy_xp ... 
        + finite_.w.cpml.Cezyhx_xp .* (Hx(pie:nx,pjs+1:pje-1)-Hx(pie:nx,pjs:pje-2)); 
%-------------------------
% for low   side (sigmax) 
%-------------------------
    finite_.w.Epml.Ezx_yn = finite_.w.cpml.Cezxe_yn .* finite_.w.Epml.Ezx_yn ... 
        + finite_.w.cpml.Cezxhy_yn .* (Hy(pis+1:pie-1,2:pjs)-Hy(pis:pie-2,2:pjs)); 
    finite_.w.Epml.Ezy_yn = finite_.w.cpml.Cezye_yn .* finite_.w.Epml.Ezy_yn ... 
        + finite_.w.cpml.Cezyhx_yn .* (Hx(2:nx,2:pjs)-Hx(2:nx,1:pjs-1)); 
%-------------------------
% for upper side (sigmax) 
%-------------------------
    finite_.w.Epml.Ezx_yp = finite_.w.cpml.Cezxe_yp .* finite_.w.Epml.Ezx_yp ... 
        + finite_.w.cpml.Cezxhy_yp .* (Hy(pis+1:pie-1,pje:ny)-Hy(pis:pie-2,pje:ny)); 
    finite_.w.Epml.Ezy_yp = finite_.w.cpml.Cezye_yp .* finite_.w.Epml.Ezy_yp ... 
        + finite_.w.cpml.Cezyhx_yp .* (Hx(2:nx,pje:ny)-Hx(2:nx,pje-1:ny-1)); 
%-------------------------
%     Ez = Ezx + Ezy      
%-------------------------
Ez(2:pis,2:pjs)   = finite_.w.Epml.Ezx_xn(:,1:pjs-1) + finite_.w.Epml.Ezy_yn(1:pis-1,:); 
Ez(2:pis,pje:ny)  = finite_.w.Epml.Ezx_xn(:,pje-1:nym1) + finite_.w.Epml.Ezy_yp(1:pis-1,:); 
Ez(pie:nx,pje:ny) = finite_.w.Epml.Ezx_xp(:,pje-1:nym1) + finite_.w.Epml.Ezy_yp(pie-1:nxm1,:); 
Ez(pie:nx,2:pjs)  = finite_.w.Epml.Ezx_xp(:,1:pjs-1) + finite_.w.Epml.Ezy_yn(pie-1:nxm1,:); 
Ez(pis+1:pie-1,2:pjs)  = finite_.w.Epml.Ezx_yn + finite_.w.Epml.Ezy_yn(pis:pie-2,:); 
Ez(pis+1:pie-1,pje:ny) = finite_.w.Epml.Ezx_yp + finite_.w.Epml.Ezy_yp(pis:pie-2,:); 
Ez(2:pis,pjs+1:pje-1)  = finite_.w.Epml.Ezx_xn(:,pjs:pje-2) + finite_.w.Epml.Ezy_xn; 
Ez(pie:nx,pjs+1:pje-1) = finite_.w.Epml.Ezx_xp(:,pjs:pje-2) + finite_.w.Epml.Ezy_xp;         
end


