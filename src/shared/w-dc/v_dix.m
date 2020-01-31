function vi = v_dix(v,to)
% compute interval velocities from vrms and to picks.
vi=sqrt( ( (v(2:end).^2 .* to(2:end))-(v(1:(end-1)).^2 .* to(1:(end-1)))  )...
  ./(to(2:end)-to(1:(end-1)))  );
vi=vi(:);
end