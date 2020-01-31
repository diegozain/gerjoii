function k = dc_boundstep2(sigm,dsigm,sigm_max_,sigm_min_,k_)
sigm=sigm(:); dsigm=dsigm(:);
% first round of search is a sparse logspace (reverse)
k=logspace(log10(max(k_)),log10(min(k_)),13);
ik = whileloop_rev(k,sigm,dsigm,sigm_max_,sigm_min_);
if ik==1
  k=k(ik);
  return;
end
% second round of search is a finer search (forward)
k=linspace(k(ik),k(ik-1),20);
ik = whileloop_fwd(k,sigm,dsigm,sigm_max_,sigm_min_);
if ik==1
  k=k(ik);
  return;
end
% % third round of search is a finer-finer search (reverse)
% k=linspace(k(ik),k(ik-1),10);
% ik = whileloop_rev(k,sigm,dsigm,sigm_max_,sigm_min_);
k=k(ik);
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function ik = whileloop_rev(k,sigm,dsigm,sigm_max_,sigm_min_)
epsi_ = sigm.*exp(k(1)*sigm.*dsigm);
epsi_max=max(epsi_(:));
epsi_min=min(epsi_(:));
ik=1;
while or(epsi_max > sigm_max_ , epsi_min < sigm_min_)
  ik=ik+1;
  if ik>numel(k)
    ik=ik-1;
    return;
  end
  epsi_ = sigm.*exp(k(ik)*sigm.*dsigm);
  epsi_max=max(epsi_(:));
  epsi_min=min(epsi_(:));
end
end
function ik = whileloop_fwd(k,sigm,dsigm,sigm_max_,sigm_min_)
epsi_ = sigm.*exp(k(1)*sigm.*dsigm);
epsi_max=max(epsi_(:));
epsi_min=min(epsi_(:));
ik=1;
while and(epsi_max <= sigm_max_ , epsi_min >= sigm_min_)
  ik=ik+1;
  if ik>numel(k)
    ik=ik-1;
    return;
  end
  epsi_ = sigm.*exp(k(ik)*sigm.*dsigm);
  epsi_max=max(epsi_(:));
  epsi_min=min(epsi_(:));
end
ik=ik-1;
if ik==0
  ik=1;
end
end
