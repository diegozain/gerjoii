function parame_ = w_magmat(finite_,parame_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% build magnetic permeability and magnetic conductivity values
% ..............................................................................
nx = finite_.w.nx;
ny = finite_.w.ny;
% magnetic %
mu_r_x = ones(nx+1 , ny);
mu_r_y = ones(nx , ny + 1);
sigma_m_x = zeros(nx + 1 , ny);
sigma_m_y = zeros(nx , ny + 1); 
%
parame_.w.mu_r_x = mu_r_x;
parame_.w.mu_r_y = mu_r_y;
parame_.w.sigma_m_x = sigma_m_x;
parame_.w.sigma_m_y = sigma_m_y;
end