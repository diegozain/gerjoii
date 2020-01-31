function [experiments] = dc_depth_spacing(x_or_ze,low,high)

% find pairs of a-spacing and n-levels on a typical ER experiment.
%
% experiments = matrix of size (# of experiments x 2), where first column 
%             is a-spacing, second is n-level.
%
% x_or_ze = matrix of size (n's x a's) with entries of 
%           minimum depth (ze) or minimum x spacing (x_min).
%           has to be discretized on an positive integer coordinate grid.
% low, high = real numbers bounding interval of search either on ze or xmin.
%
% plot output like so,
% plot(experiments(:,1),experiments(:,2),'k.','Markersize',30)

[n,~] = size(x_or_ze);
I = (x_or_ze(:)<=high) .* (x_or_ze(:)>=low);
I = find(I);
i = mod(I,n); i(i==0) = n;
j = ( (I-i) / n ) + 1;
experiments = [j i];

end