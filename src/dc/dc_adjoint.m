function a = dc_adjoint(L,M,e_)
% diego domenzain
% fall 2017 @ BSU
% ------------------------------------------------------------------------------
% computes adjoint potential field 'a'
% where L is discretized \nabla\cdot\sigma\nabla
% M is measuring operator taking voltages at electrode positions
% e_ is error vector of observed vs synthetic data.
% ------------------------------------------------------------------------------
a = L' \ (M'*e_);
end
