function abmn = dc_schlumberger(n_electrodes)
% ------------------------------------------------------------------------------
%     wenner
% ------------------------------------------------------------------------------
% src_list is a cell where,
% 
% src_list{ a_spacing }( n_lvl , : )
% 
% is the [a b m n] vector for shot with cte (a_spacing,n_lvl)
% ------------------------------------------------------------------------------
% maximum a-spacing possible
a_max=floor((n_electrodes-1)/3);
src_list = cell(a_max,1);
for a=1:a_max
  % ----------------------------------------------------------------------------
  % build sources and receivers for that a-spacing like so,
  %
  % a b m n
  % ----------------------------------------------------------------------------
  % max # of n-levels for this a-spacing
  nlvl_max = n_electrodes-3*a ;
  src_list_a=cell(nlvl_max,1);
  for n_lvl=1:nlvl_max;
    % # of shots for this (a-spacing,n-level) pair
    n_an = n_electrodes - 2*a*n_lvl - a;
    src_list_an = zeros(n_an,4);
    for i_electr=1:n_an
      src_list_an(i_electr,:) = [i_electr,...
                                 i_electr+a+2*a*n_lvl,...
                                 i_electr+a*n_lvl,...
                                 i_electr+a+a*n_lvl];
      %
    end
    src_list_a{n_lvl}=src_list_an;
  end
  src_list{a}=src_list_a;
end
abmn = bundle_abmn( src_list );
end
% ------------------------------------------------------------------------------
%   print surveys
% ------------------------------------------------------------------------------
function abmn = bundle_abmn( src_list )
abmn = [];
a_max = size(src_list,1);
for a=1:a_max
  nlvl_max = size(src_list{a},1);
  for n_lvl=1:nlvl_max
    abmn = [abmn; src_list{a}{n_lvl}];
  end
end
end
