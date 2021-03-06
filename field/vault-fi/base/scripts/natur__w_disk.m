% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
% run the GPR forward model for a bunch of sources to collect some 
% synthetic "real" data.
% ..............................................................................
% # of sources
ns = gerjoii_.w.ns;
% complete parame_
parame_.w.pis = finite_.w.pis;
parame_.w.pie = finite_.w.pie;
parame_.w.pjs = finite_.w.pjs;
parame_.w.pje = finite_.w.pje;
parame_.w.t = geome_.w.T*1e-9;
% print some funny stuff so user is amused
fprintf('\n-----------~~~ gpr forward models\n');
fprintf('  # of fwd models    : %i\n',ns);
fprintf('  # of src-rec pairs : who knows, there are plenty\n\n');
% choose source and run fwd models
parfor is=1:ns
  % run nature
  w_natur__disk(geome_,parame_,finite_,gerjoii_,is);
end
clear is ns;