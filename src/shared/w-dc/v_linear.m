function v_analy = v_linear(d,t,rx,v)
% diego domenzain
% spring 2018 @ TUDelft
% ------------------------------------------------------------------------------
% get sizes
[nt,nr] = size( d );
nv = numel(v);
v_analy = zeros(nt,nv);
% normalizer solves this problem:
% faster speed -> flatter hyperbola -> less hyperbolic moveout -> more stack
v_normalizer = (1./v);
v_normalizer = v_normalizer/max(v_normalizer);
% box car filter
nh = fix(nt/15);
h = ones(nh,1)/nh;
% loop over velocities and times_o
for iv=1:nv
  % do linear moveout
  d_lmo = lmo(d,t,rx,v(iv));
  stack = (sum(d_lmo,2)/nr).^2;
  stack = conv(stack,h,'same');
  % stack = v_normalizer(iv) * stack;
  v_analy(:,iv) =  v_analy(:,iv) + stack;
  % figure(100);
  % plot(t,v_analy(:,iv));
  % pause;
end
% % normalize somehow??
v_analy = v_analy/max(v_analy(:));
% v_analy = exp(v_analy);
% v_analy = v_analy/max(v_analy(:));
end