function [us,i_uss] = unsort(u)
% diego domenzain
% spring 2017 @ BSU
% ------------------------------------------------------------------------------
% sort
[us,i_us] = sort(u);
% get indicies for reversing sort
[~,i_uss] = sort(i_us);
% now us(i_uss) == u
end