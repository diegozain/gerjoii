function finite_ = w_coeff(geome_,parame_,finite_,gerjoii_)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% inspired by the book:
% "the finite-difference time-domain method for
% electromagnetics with matlab simulations", Atef Z. Elsherbeni.
% ..............................................................................
% computes central coefficients to be used in finite difference scheme.
% ..............................................................................
eps_0 = single(parame_.w.eps_0);
mu_0      = single(parame_.w.mu_0);
mu_r_x    = single(parame_.w.mu_r_x);
sigma_m_x = single(parame_.w.sigma_m_x);
mu_r_y    = single(parame_.w.mu_r_y);
sigma_m_y = single(parame_.w.sigma_m_y);
eps_r_z   = finite_.w.eps_r_z;
sigma_e_z = finite_.w.sigma_e_z;
dx = geome_.dx;
dy = geome_.dy;
dt = geome_.w.dt;
s_w = gerjoii_.w.s;
% ..............................................................................
% for inner nodes.
%--------------------------------------------------------------------------------
%                       coeffiecients updating Ez
%--------------------------------------------------------------------------------
finite_.w.coeff.Ceze  =  (2*eps_r_z*eps_0 - dt*sigma_e_z)./(2*eps_r_z*eps_0 + dt*sigma_e_z);
finite_.w.coeff.Cezhy =  (2*dt/dx)./(2*eps_r_z*eps_0 + dt*sigma_e_z);
finite_.w.coeff.Cezhx = -(2*dt/dy)./(2*eps_r_z*eps_0 + dt*sigma_e_z);
%--------------------------------------------------------------------------------
%                       coeffiecients updating Hx
%--------------------------------------------------------------------------------
finite_.w.coeff.Chxh  =  (2*mu_r_x*mu_0 - dt*sigma_m_x)./(2*mu_r_x*mu_0 + dt*sigma_m_x);
finite_.w.coeff.Chxez = -(2*dt/dy)./(2*mu_r_x*mu_0 + dt*sigma_m_x);
%--------------------------------------------------------------------------------
%                       coeffiecients updating Hy
%--------------------------------------------------------------------------------
finite_.w.coeff.Chyh  =  (2*mu_r_y*mu_0 - dt*sigma_m_y)./(2*mu_r_y*mu_0 + dt*sigma_m_y);
finite_.w.coeff.Chyez =  (2*dt/dx)./(2*mu_r_y*mu_0 + dt*sigma_m_y);
%--------------------------------------------------------------------------------
%                       coeffiecients updating Jz
%--------------------------------------------------------------------------------
finite_.w.coeff.Cezj = -(2*dt)/ ...
        (2*eps_r_z(s_w(1),s_w(2))*eps_0 + dt*sigma_e_z(s_w(1),s_w(2)));
%--------------------------------------------------------------------------------
%                       coeffiecients updating Mx
%--------------------------------------------------------------------------------
finite_.w.coeff.Chxm = -(2*dt)/ ...
        (2*mu_r_x(s_w(1),s_w(2))*mu_0 + dt*sigma_m_x(s_w(1),s_w(2)));
%--------------------------------------------------------------------------------
%                       coeffiecients updating My
%--------------------------------------------------------------------------------
finite_.w.coeff.Chym = -(2*dt)/ ... 
        (2*mu_r_y(s_w(1),s_w(2))*mu_0 + dt*sigma_m_y(s_w(1),s_w(2)));
end
