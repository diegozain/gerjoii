function y_ = integrate(y,dt,cte)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% y = dt(y_) -> y_ = cte + integral{ y dt }
% 
nt=numel(y);
[~,Dt]=Dx_Dz(1,nt); Dt=Dt/dt;

Dt=[zeros(1,nt) ; Dt]; 
Dt=[Dt , zeros(nt+1,1)];
Dt(1)=1;
Dt(nt+1,nt-2:nt) = 0; 
Dt(end)=1;

y=[ cte ; y ];
y_ = Dt\y;
y_(end)=[];
end
% % test
% 
% y=sin(2*t);
% y__=Dt*y; % cos(t)
% y__=2*cos(2*t);
% y_ = integrate(y__,dt,cte);
% 
% figure;
% hold on;
% plot(t,y,'k.-','Markersize',15);
% plot(t,y__,'b.-','Markersize',15);
% plot(t,y_,'r.-','Markersize',15);
% hold off
% 
% figure;
% plot(t,y-y_,'k.-','Markersize',15)
% norm(y-y_)*dt