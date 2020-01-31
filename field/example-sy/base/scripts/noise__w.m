% diego domenzain
% fall 2019 @ BSU
% ------------------------------------------------------------------------------
% give each shot-gather some noise.
% ------------------------------------------------------------------------------
ns = gerjoii_.w.ns;
% print some funny stuff so user is amused
fprintf('\n-----------~~~ give noise to gpr\n\n');
% choose source and run fwd models
parfor is=1:ns
  w_noiser_(parame_,gerjoii_,is);
end
