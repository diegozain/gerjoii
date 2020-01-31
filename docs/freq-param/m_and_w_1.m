% 
% visualize relationship between w (omega) and parameters (m = e & s)
%
clear
close all

eo = 8.854187817e-12;           % permittivity of free space
e = [18; 12; 7.8; 3.1];         % relative permittivities
s_dc = 0.01;                    % dc conductivity
t = [1e-5; 15e-9; 2*pi*15e-9];  % taus

w = linspace(0,1e+9,1e+5);      % omega discretization
w = 2*pi*w';

% debye model
e_debye = e(2);
for j=1:3
    sum = (e(j)-e(j+1))./(1 + 1i*t(j)*w);
    e_debye = e_debye + sum;    
end
e_debye = eo*e_debye;

% real and imaginary permittivity
e_imag = -imag(e_debye);
e_real = real(e_debye);
e_complex = e_real + 1i*e_imag;

% real conductivity
s_real = s_dc - w.*e_imag;

% visualize
figure(1)
plot(log(w),e_real);
xlabel('log(\omega) [2\pi Hz]','fontsize',13)
ylabel('Re(\epsilon) [F/m]','fontsize',13)

figure(2)
plot(log(w),s_real);
xlabel('log(\omega) [2\pi Hz]','fontsize',13)
ylabel('Re(\sigma) [S/m]','fontsize',13)

figure(3)
plot(e_complex);
xlabel('Re(\epsilon)','fontsize',13)
ylabel('Im(\epsilon)','fontsize',13)
