function abmn_ = dc_iris2abmn(abmn)
% make abmn sequence fast for Syscal
% ------------------------------------------------------------------------------
[srcu,i_abmn,i_srcu]=unique(abmn(:,1:2),'rows');
% srcu = abmn(i_abmn)
% abmn = srcu(i_srcu)
ns = size(srcu,1);
abmn_=[];
for i_shot=1:ns
  isrc_i = find(ismember(abmn(:,1:2),srcu(i_shot,:),'rows'));
  abmn_=[abmn_;abmn(isrc_i,:)];
end
end