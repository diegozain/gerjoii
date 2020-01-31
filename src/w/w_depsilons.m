function [w_depsilon,a_] = w_depsilons(wdepsilon_self,wdepsilon_friend,Ee_self,Ee_friend)
% diego domenzain.
% boise state university, 2018.
% ..............................................................................
% ---- in
% wdepsilon_self:  is the raw depsilon update for all freqs
% wdepsilon_friend: is the raw depsilon update for low freqs
% Ee_self & Ee_friend: are the current objective function values for self and friend
% ---- out
% w_depsilon: is the joint update ready for rock 'n rolling
% a: are the weights used for summing the dsigma's & saves Ee_self,Ee_friend too.
% ---- gerjoii_
% in gerjoii_ structure:
% [gerjoii_.wdc.dsigma,a_] = w_depsilon(gerjoii_.w.dsigma,...
%                                       gerjoii_.dc.dsigma,...
%                                       gerjoii_.w.E_,gerjoii_.dc.E_);
% ---------------------------------
% magic weight calculation
% ---------------------------------
a = wdc_steps(Ee_self , Ee_friend);
% ---------------------------------
% normalizing updates
% NOTE: could it be better??
% ---------------------------------
wdepsi_self_ = max(abs(wdepsilon_self(:)));
wdepsi_friend_ = max(abs(wdepsilon_friend(:)));
wdepsilon_self = wdepsilon_self/wdepsi_self_;
wdepsilon_friend = wdepsilon_friend/wdepsi_friend_;
% weighing updates
wdepsilon_self = a(1)*wdepsilon_self; 
wdepsilon_friend = a(2)*wdepsilon_friend;
w_depsilon =  wdepsilon_self + wdepsilon_friend;
% ---------------------------------
% find step-size for joint update 
% NOTE: could it be better??
% ---------------------------------
% amp = 0.5*(a(1)*wdepsi_self_ + a(2)*wdepsi_friend_);
amp = 1;
% update
w_depsilon = amp * normali(w_depsilon);
% -----------------------------------
% store a 
% -----------------------------------
a_ = zeros(2,2);
a_(1,:) = a;
a_(2,:) = [Ee_self,Ee_friend];
end