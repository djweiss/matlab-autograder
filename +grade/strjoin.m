function [s] = strjoin(sep, strs)

s = '';
for i = 1:numel(strs)
    if i == numel(strs)
        s = [s strs{i}];
    else
        s = [s strs{i} sep];
    end
end

        