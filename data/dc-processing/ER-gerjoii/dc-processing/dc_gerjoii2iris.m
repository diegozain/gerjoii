function [abmn_dd,abmn_wen,abmn] = dc_gerjoii2iris(n_electrodes)
% ------------------------------------------------------------------------------
% builds list of src-rec pairs in abmn format for:
% . dipole-dipole
% . wenner
% . schlumberger (switch mn with ab in wenner)
%
% Author: Diego Domenzain,
% Spring 2018 while in TU-Delft.
%
% This file is to be run inside
%  gerjoii2iris_dc.m
% to generate a .txt file ready as input for Iris-Syscal.
% ------------------------------------------------------------------------------
% generate ALL shots for all possible a-spacings and respective n-levels
% returns cells, see below.
abmn_dd = dipoledipole(n_electrodes);
abmn_wen = wenner(n_electrodes);
% bundle all in matricies
abmn_dd_ = bundle_abmn(abmn_dd);
abmn_wen_ = bundle_abmn(abmn_wen);
% merge matricies
abmn = [abmn_wen_; abmn_dd_];
end
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
function src_list = dipoledipole(n_electrodes)
% ----------
% dipole-dipole
% ----------
% src_list is a cell where,
% 
% src_list{ a_spacing }{ n_lvl }
% 
% is the [a b m n] matrix for all shots with cte (a_spacing,n_lvl)

% maximum a-spacing possible
a_max = floor((n_electrodes)/3)-1;

src_list = cell(a_max,1);
for a=1:a_max;
  % max # of n-levels for this a-spacing
  nlvl_max = floor( (n_electrodes-1-2*a)/a );
  src_list_a=cell(nlvl_max,1);
  for n_lvl=1:nlvl_max;
    % # of shots for this (a,n) pair
    n_an = n_electrodes-a*n_lvl-a-a;
    src_list_an = zeros(n_an,4);
    for i_electr=1:n_an
      src_list_an(i_electr,:) = [i_electr,...
                                 i_electr+a,...
                                 i_electr+a+ a*n_lvl,...
                                 i_electr+a+ a*n_lvl+a];
    end
    src_list_a{n_lvl}=src_list_an;
  end
  src_list{a}=src_list_a;
end
end
% ---
function src_list = wenner(n_electrodes)
% ----------
%     wenner
% ----------
% src_list is a cell where,
% 
% src_list{ a_spacing }( n_lvl , : )
% 
% is the [a b m n] vector for shot with cte (a_spacing,n_lvl)

% maximum a-spacing possible
a_max=floor((n_electrodes-1)/3);
src_list = cell(a_max,1);
for a=1:a_max
  % build sources and receivers for that a-spacing like so,
  %
  % a b m n
  %
  src_list_a = zeros(n_electrodes-3*a,4);
  for i_electr=1:n_electrodes-3*a
    src_list_a(i_electr,:) = [i_electr,i_electr+3*a,i_electr+a,i_electr+2*a];
  end
  src_list{a}=src_list_a;
end
end
% ---
function abmn = bundle_abmn( src_list )
% ---------------
%   print surveys
% ---------------
abmn = [];
a_max = size(src_list,1);
% dipole-dipole survey
if iscell( src_list{1} )
  for a=1:a_max
    nlvl_max = size(src_list{a},1);
    for n_lvl=1:nlvl_max
      abmn = [abmn; src_list{a}{n_lvl}];
    end
  end
  % print abmn to file
% wenner survey
else
  for a=1:a_max
    nlvl_max = size(src_list{a},1);
    for n_lvl=1:nlvl_max
      abmn = [abmn; src_list{a}(n_lvl,:)];
    end
  end
  % print abmn to file
end
end