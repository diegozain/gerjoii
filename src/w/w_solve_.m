function gerjoii_ = w_solve_(geome_,parame_,finite_,gerjoii_,is)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% inspired by the book: 
% "the finite-difference time-domain method for 
% electromagnetics with matlab simulations", Atef Z. Elsherbeni.
% ..............................................................................
% solves the wave equation.
% ..............................................................................
Mw = gerjoii_.w.M;
s_w = gerjoii_.w.s;
wvlet_ = gerjoii_.w.wvlet_;
dt = geome_.w.dt;
nt = geome_.w.nt;
nx = finite_.w.nx;
ny = finite_.w.ny;
pis = finite_.w.pis;
pie = finite_.w.pie;
pje = finite_.w.pje;
pjs = finite_.w.pjs;
pml_w = finite_.w.pml_w;
pml_d = finite_.w.pml_d;
domain_i = finite_.w.domain_i;
domain_j = finite_.w.domain_j;
X = geome_.X;
Y = geome_.Y;
% ..............................................................................
% solves the 2D EM wave equation on a rectangular grid on 
% finite difference time domain Yee grid with
% PML boundary conditions.
%
% see wave-manual for pseudo code and code diagrams.
%
%
% output:
% u_w --> is wavefield at all grid points at all times.
% d_w --> is data, which is wavefield at receiver locations at all times.
%
% computational domain within the pml is:
%
% domain = [ants_i;ants_j]
% ants_i = pis+1:pie-1;   % x axis
% ants_j = pjs+1:pje-1;   % y axis
% ..............................................................................
nxm1 = nx-1;
nxp1 = nx+1;
nym1 = ny-1;
nyp1 = ny+1;                       
%---------------------------------------------
% intialize fields and outputs
%---------------------------------------------
% time counter
current_time = 0;
% .....................
% init pml fields
% .....................
% NOTE change these to singles: zeros(size,'single')
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
% observed wavefield (time series)
d_w = zeros(nt,gerjoii_.w.nr,'single');
if is~=0
  % path to save wavefield,
  % u_folder = parallel_memory/w/source#/u/
  % parallel_memory_w = '/path/to/disk/parallel_memory/w/'
  parallel_memory_w = parame_.w.parallel_memory;
  % u_folder = strcat(parallel_memory_w,'source',num2str(is),'/u/');
  u_folder = parallel_memory_w;
  % access chunks
  chunks = gerjoii_.w.chunks;
  % initialize first chunk
  u_w = zeros(numel(domain_i(:)),numel(domain_j(:)),chunks(1));
  it_=1;
  i_chunk=1;
end
% point observation of source
Jz = zeros(nt,1,'single');
% fprintf('\n');
% display(['doing the wave u for ' num2str(nt) ' timesteps']);
% tic;
for it = 1:nt
% --------
% updates
%---------
% update H and H_pml
current_time  = current_time + dt/2;
[Hx,Hy] = new_H(Hx,Hy,Ez,finite_);
[Hx,Hy] = new_H_pml(Hx,Hy,Ez,finite_);
% update Ez, Jz and Ez_pml
current_time  = current_time + dt/2;
Ez = new_Ez(Hx,Hy,Ez,finite_);
% source
% Ez(s_w(1),s_w(2)) = Ez(s_w(1),s_w(2)) ... 
%            + finite_.w.coeff.Cezj * w_wavelet(current_time,ampli,tau);
% source
Ez(s_w(1),s_w(2)) = Ez(s_w(1),s_w(2)) + finite_.w.coeff.Cezj * wvlet_(it);
% pml
[Ez,finite_] = new_Ez_pml(Hx,Hy,Ez,finite_);
% --------
% observe
%---------
% observed wavefield (time series)
% d_w(it,:) = Ez(Mw(1),Mw(2:end));
d_w(it,:) = Ez(Mw); % data at time-step it
% ------------------------
% save chunks
% ------------------------
if is~=0
  if ( it_ <= chunks(i_chunk) )
    % save wavefield frame 
    u_w(:,:,it_) = Ez(domain_i(:),domain_j(:));
    it_ = it_+1;
  else
    % save chunk
    name = strcat(u_folder,'u',num2str( i_chunk ),'.mat');
    % save( 'path/to/dir/name-of-file' , 'variable-name' );
    save( name , 'u_w' );
    % increase iterator
    it_=1;
    i_chunk=i_chunk+1;
    % erase previous chunk
    u_w = zeros(numel(domain_i(:)),numel(domain_j(:)),chunks(i_chunk));
    % save current frame in ram
    u_w(:,:,it_) = Ez(domain_i(:),domain_j(:));
    it_=it_+1;
  end
end
% recorder of source
Jz(it) = Ez(s_w(1),s_w(2));
% %------------------------------------------------------------------------
%    
%    % display
%    %
%    figure(1);
%    imagesc(X,Y,u_w(:,:,it));
%    colormap(b2r(-1e-2, 1e-2))
%    caxis([-1e-2, 1e-2]);
%    axis square;
%    title(['time [ns]: ' num2str(dt*it/1e-9)]);
%    getframe;
% 
% %------------------------------------------------------------------------
end
% clean
finite_.w = rmfield(finite_.w,'Epml');
if is~=0
  % save last chunk
  name = strcat(u_folder,'u',num2str( i_chunk ),'.mat');
  % save( 'path/to/dir/name-of-file' , 'variable-name' );
  save( name , 'u_w' );
end
gerjoii_.w.d_2d = d_w;
gerjoii_.w.Jy = Jz;
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
