function abmn = dc_abmn_flip(abmn,n_electrodes)
% diego domenzain
% Spring 2018, TUDelft
%
% given abmn list with receivers on only one side of src (i.e. right side),
% flip src-rec pairs so receivers are on the other side of array (i.e. left):
%
% a ---- b ---- m ---- n ---- end-of-array   becomes,
% begini-array ---- m ---- n ---- a ---- b

% create electrodes by index
electr = 1:n_electrodes;
% flip so first is last, second is second-to-last, etc..
electr_ = flip(electr);
% re-index electrodes so sources are now to the right and rec to the left
abmn = electr_(abmn);
% put src+ first, src- second in array order. same for rec.
ab = flip( abmn(:,1:2),2 );
mn = flip( abmn(:,3:4),2 );
% bundle together
abmn = [ab mn];

end