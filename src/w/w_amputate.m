function [d,r,dsr] = w_amputate(d,r,dsr,r_keepx_,r_keepx__)
% diego domenzain
% spring 2019 @ BSU
% ------------------------------------------------------------------------------
% amputates chunks of traces at the beginnig or ending of shot-gather.
% ------------------------------------------------------------------------------
rx=r(:,1);
rz=r(:,2);
% put in absolute distance
r_keepx_  = r_keepx_  + rx(1);
r_keepx__ = r_keepx__ + rx(1);
% get indicies
ir_keep_  = binning(rx,r_keepx_);
ir_keep__ = binning(rx,r_keepx__);
% dsr changes if amputation is on side next to source
dsr = dsr + abs(rx(1)-rx(ir_keep_));
% amputate
rx = rx(ir_keep_:ir_keep__);
rz = rz(ir_keep_:ir_keep__);
r = [rx,rz];
d = d(:,ir_keep_:ir_keep__);
end