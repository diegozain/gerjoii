function [parame_,gerjoii_] = w_image_e_f(geome_,parame_,finite_,gerjoii_)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% while loop (iteration)
%   parfor loop (sources)
%     choose source, data and receivers
%     fwd
%     obj
%     store obj
%     gradient
%     step size
%     compute update 
%     store update
%   end parfor
%   stack obj
%   stack updates
%   update
% end while
%
% inside of while (except updating) is w_update_[e,s].m

tol_iter = gerjoii_.w.tol_iter;
tol_error = gerjoii_.w.tol_error;

a = zeros(2,2);
E = [];
E_ = Inf;
iter = 0;
while (E_>tol_error & iter<tol_iter)
  E_ = 0;
  % ............................................................................
  % compute updates
  % ............................................................................
  % % --
  % % 'imaginary' low frequency friend
  % gerjoii_.w.regu.f_yesno = 'YES';
  % gerjoii_.w.regu.f__ =   gerjoii_.w.regu.f_friend;
  % gerjoii_.w.regu.f_  = - gerjoii_.w.regu.f__;
  % gerjoii_ = w_update_e_(geome_,parame_,finite_,gerjoii_);
  % gerjoii_.w.depsilon_friend = gerjoii_.w.depsilon;
  % Ee_friend = gerjoii_.w.Ee_;
  % % full frequency
  % gerjoii_.w.regu.f_yesno = 'NO';
  % gerjoii_.w.regu.f__ =   gerjoii_.w.regu.f_self;
  % gerjoii_.w.regu.f_  = - gerjoii_.w.regu.f__;
  % gerjoii_ = w_update_e_(geome_,parame_,finite_,gerjoii_);
  % gerjoii_.w.depsilon_self = gerjoii_.w.depsilon;
  % Ee_ = gerjoii_.w.Ee_;
  % % --
  % gerjoii_ = w_update_e_f_(geome_,parame_,finite_,gerjoii_);
  % Ee_ = gerjoii_.w.Ee;
  % Ee_friend = gerjoii_.w.Ee_;
  % --
  gerjoii_ = w_update_e_f_(geome_,parame_,finite_,gerjoii_);
  % filter update
  ax = gerjoii_.w.regu.ax; az = gerjoii_.w.regu.az;
  gerjoii_.w.depsilon = image_gaussian(full(gerjoii_.w.depsilon),...
                                        ax,az,'LOW_PASS');
  % % ............................................................................
  % % joint update
  % % ............................................................................
  % fprintf('\nepsilon friend error %2.2d',Ee_friend)
  % fprintf('\nepsilon self error %2.2d\n',Ee_)
  % [gerjoii_.w.depsilon,a_] = w_depsilons(gerjoii_.w.depsilon_self,...
  %                                        gerjoii_.w.depsilon_friend,...
  %                                        Ee_,Ee_friend);
  % % save a's
  % a = cat(3,a,a_);
  % % filter update
  % ax = gerjoii_.w.regu.ax; az = gerjoii_.w.regu.az;
  % gerjoii_.w.depsilon = image_gaussian(full(gerjoii_.w.depsilon),...
  %                                       ax,az,'LOW_PASS');
  % ............................................................................
  % store obj
  % ............................................................................
  % E_ = 0.5*(Ee_+Ee_friend);
  % E = [E E_];
  E_ = gerjoii_.w.Ee;
  E = [E E_];
  % ............................................................................
  % update
  % ............................................................................
  parame_.w.epsilon = parame_.w.epsilon .* ...
                      exp(parame_.w.epsilon.*gerjoii_.w.depsilon);                
  % ............................................................................
  % print funny stuff
  % ............................................................................
  fprintf('\n  min of relative permittivity %2.2d',min(parame_.w.epsilon(:)));
  fprintf('\n  max of relative permittivity %2.2d\n',max(parame_.w.epsilon(:)));
  fprintf('  current error %2.2d at iteration %i \n',E_,iter+1);
  iter = iter+1;  
end % while
gerjoii_.w.Ee = E;
% gerjoii_.w.ae = a;
end