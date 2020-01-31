function u = ifm_radial(u , vs_loc , vr_loc )
% given a received wavefield u_en (which we call u in the input of this file)
% on location vs_loc,
% what is the radial wavefield pointing to the 
% virtual receiver in location vr_loc?
% well, the answer is ur (which we call u in the output of this file).
% ------------------------------------------------------------------------------
% radial direction
r = vr_loc - vs_loc;
% % add Z component 
% r = [r;1];
% project wavefield (E,N) onto radial direction to virtual rec
u = (1/(r.'*r)) * u * r;
u = u * r.';
end