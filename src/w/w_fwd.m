function [finite_,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_)
  % diego domenzain.
  % boise state university, 2018.
  % ..............................................................................
  % solves the EM wave equation 
  % ..............................................................................
  % this method takes prameters in type double but solves in type single.
  % 
  % to change singles2doubles change:
  % . w_exp2pml.m
  % . w_coeff.m
  % . w_cpml.m
  % . w_solve.m
  % . w_grad.m
  % . w_adjoint_.m
  % ..............................................................................
  % expand materials to pml
  finite_ = w_exp2pml(parame_,finite_);
  % init coefficients for pml
  finite_ = w_cpml(geome_,parame_,finite_);
  % init inner coeffiecients
  finite_ = w_coeff(geome_,parame_,finite_,gerjoii_);
  % solve the wave
  gerjoii_ = w_solve(geome_,parame_,finite_,gerjoii_);
  % clean
  finite_.w = rmfield(finite_.w,'coeff');
  finite_.w = rmfield(finite_.w,'cpml');
  % mute data
  if strcmp(gerjoii_.w.MUTE , 'yes_MUTE')
    [gerjoii_,parame_] = w_lmute(gerjoii_,parame_);
  end
  % error
  if isfield(gerjoii_.w,'obj_FNC')==0; gerjoii_.w.obj_FNC='L2'; end
  [gerjoii_.w.e_2d,gerjoii_.w.d_2d,parame_.natu.w.d_2d] = ...
              w_bozdag(parame_.natu.w.d_2d,gerjoii_.w.d_2d,gerjoii_.w.obj_FNC);
end