function k = w_boundstep2(epsi,depsi,epsi_max_,epsi_min_,k_)
% diego domenzain.
% boise state university, 2018.
% ------------------------------------------------------------------------------
epsi=epsi(:); depsi=depsi(:);
% first round of search is a sparse logspace (reverse)
k=logspace(log10(max(k_)),log10(min(k_)),13);
ik = whileloop_rev(k,epsi,depsi,epsi_max_,epsi_min_);
if ik==1
  k=k(ik);
  return;
end
% second round of search is a finer search (forward)
k=linspace(k(ik),k(ik-1),20);
ik = whileloop_fwd(k,epsi,depsi,epsi_max_,epsi_min_);
if ik==1
  k=k(ik);
  return;
end
% % third round of search is a finer-finer search (reverse)
% k=linspace(k(ik),k(ik-1),10);
% ik = whileloop_rev(k,epsi,depsi,epsi_max_,epsi_min_);
k=k(ik);
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function ik = whileloop_rev(k,epsi,depsi,epsi_max_,epsi_min_)
epsi_ = epsi.*exp(k(1)*epsi.*depsi);
epsi_max=max(epsi_(:));
epsi_min=min(epsi_(:));
ik=1;
while or(epsi_max > epsi_max_ , epsi_min < epsi_min_)
  ik=ik+1;
  if ik>numel(k)
    ik=ik-1;
    return;
  end
  epsi_ = epsi.*exp(k(ik)*epsi.*depsi);
  epsi_max=max(epsi_(:));
  epsi_min=min(epsi_(:));
end
end
function ik = whileloop_fwd(k,epsi,depsi,epsi_max_,epsi_min_)
epsi_ = epsi.*exp(k(1)*epsi.*depsi);
epsi_max=max(epsi_(:));
epsi_min=min(epsi_(:));
ik=1;
while and(epsi_max <= epsi_max_ , epsi_min >= epsi_min_)
  ik=ik+1;
  if ik>numel(k)
    ik=ik-1;
    return;
  end
  epsi_ = epsi.*exp(k(ik)*epsi.*depsi);
  epsi_max=max(epsi_(:));
  epsi_min=min(epsi_(:));
end
ik=ik-1;
if ik==0
  ik=1;
end
end
