function finite_ = w_exp2pml(parame_,finite_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% given materials built without pml,
% this function pads them with pml.
% also adds air.
% ..............................................................................
epsilon_w = single(parame_.w.epsilon);
sigma_w = single(parame_.w.sigma);
pml_w = finite_.w.pml_w;
pml_d = finite_.w.pml_d;
air = parame_.w.air;
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

finite_.w.eps_r_z = eps_r_z;
finite_.w.sigma_e_z = sigma_e_z;
end
