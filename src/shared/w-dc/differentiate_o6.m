function y = differentiate_o6(y,dt)
% diego domenzain
% spring 2021 @ CSM
% ------------------------------------------------------------------------------
% 
% given a time series 'y' sampled at dt, who is its derivative?
% 
% sixth order accurate.
% 
% ------------------------------------------------------------------------------
% this code finds the derivative with minimal storage,
% it is a void method.
% ------------------------------------------------------------------------------
% for a time series of size 17, the diff operator is:
% 
% ** pretty large and annoying **
% 
% 
% 
% ------------------------------------------------------------------------------
nt= numel(y);

fwd = zeros(1,7);
ctd = zeros(1,3);
bwd = zeros(1,7);

y_ =zeros(9,1);
y__=zeros(9,1);

fwd(1)= -49/20/dt;
fwd(2)= 6/dt;
fwd(3)= -15/2/dt;
fwd(4)= 20/3/dt;
fwd(5)= -15/4/dt;
fwd(6)= 6/5/dt;
fwd(7)= -1/6/dt;

ctd(1)= -1/60/dt;
ctd(2)= 3/20/dt;
ctd(3)= -3/4/dt;
ctd(4)= 0;
ctd(5)= 3/4/dt;
ctd(6)= -3/20/dt;
ctd(7)= 1/60/dt;

bwd(1)= 1/6/dt;
bwd(2)= -6/5/dt;
bwd(3)= 15/4/dt;
bwd(4)= -20/3/dt;
bwd(5)= 15/2/dt;
bwd(6)= -6/dt;
bwd(7)= 49/20/dt;
% ------------------------------------------------------------------------------
y_(1:9) = y(1:9);
y(1) = fwd*y_(1:7);
y(2) = fwd*y_(2:8);
y(3) = fwd*y_(3:9);

for it=4:3:(nt-8)
  
  y__(1:9)= y(it:(it+8));
  
  y(it)  = ctd*y_(1:7);
  y(it+1)= ctd*y_(2:8);
  y(it+2)= ctd*y_(3:9);
  
  y_=y__;
end

% NOTE: this part with ifs is ugly. 
% I should fix it one day.
if mod(nt,3)==2
  it=nt-10;
  
  y__(1:9)= y((it+2):(it+10));

  y(it+3)= ctd*y_(1:7);
  y(it+4)= ctd*y_(2:8);
  y(it+5)= ctd*y_(3:9);

  y(it+6)= bwd*y_(1:7);
  y(it+7)= bwd*y_(2:8);
  y(it+8)= bwd*y_(3:9);

  y_=y__;

  y(nt-1)= bwd*y_(2:8);
  y(nt)  = bwd*y_(3:9);
elseif mod(nt,3)==1
  it=nt-9;
  
  y__(1:9)= y((it+1):(it+9));
  
  y(it+3)= ctd*y_(1:7);
  y(it+4)= ctd*y_(2:8);
  y(it+5)= ctd*y_(3:9);
  
  y(it+6)= bwd*y_(1:7);
  y(it+7)= bwd*y_(2:8);
  y(it+8)= bwd*y_(3:9);
  
  y_=y__;
  
  y(nt)  = bwd*y_(3:9);
elseif mod(nt,3)==0
  it=nt-8;
  
  y(it+3)= ctd*y_(1:7);
  y(it+4)= ctd*y_(2:8);
  y(it+5)= ctd*y_(3:9);
  
  y(it+6)= bwd*y_(1:7);
  y(it+7)= bwd*y_(2:8);
  y(it+8)= bwd*y_(3:9);
end
end

% % test:
% t=linspace(0,2*pi,1001).';dt=t(2)-t(1);nt=numel(t);y_sin=sin(t);y_cos=cos(t);
% y_sin_=differentiate_o6(y_sin,dt);y_cos_=differentiate_o6(y_cos,dt);
% figure;hold on;plot(t,y_cos);plot(t,y_sin_,'--')
% figure;hold on;plot(t,-y_sin);plot(t,y_cos_,'--')

