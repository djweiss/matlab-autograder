function [errs] = compare_fields(gold, x, prefix, tol)

caller = dbstack; caller = caller(2); 

if ~strcmp(caller.name, 'compare_fields')
    callprefix = [caller.name ' FAILED: '];   
else
    callprefix = '';
end

if 0
%%
clear gold x

gold.A = 1:5;
gold.B = {1:5, -5:-1};
gold.C = 1:10;
gold.E = -1;
gold.X = {1};
gold.string_match = 'match';
gold.size_mismatch = zeros(10, 5);
gold.S = struct('a', 1:3, 'b', 5);
gold.p = 1.001;

x.A = 1:5;
x.X = 'hello';
x.D = struct('a','b');
x.string_match = 'match';
x.S = struct('a', 1, 'c', 'hi');
x.size_mismatch = zeros(5, 10);
x.p = 1;

[errs] = compare_fields(gold, x, '', 0.1);
disp(strvcat(errs{:}));
%%

end

if nargin<3
    prefix = '';
end
if nargin<4
    tol = 1e-10;
end


gold_fields = fieldnames(gold);
x_fields = fieldnames(x);

errs = {};
for i = 1:numel(gold_fields)
    if ~ismember(gold_fields{i}, x_fields)
        errs{end+1} = [prefix sprintf('missing field ''%s''', gold_fields{i})];
    end
end
for i = 1:numel(x_fields)
    if ~ismember(x_fields{i}, gold_fields)
        errs{end+1} = [prefix sprintf('extra field ''%s''', x_fields{i})];
    end
end

same_fields = intersect(x_fields, gold_fields);
for i = 1:numel(same_fields)
    f = same_fields{i};
    xval = x.(f);
    goldval = gold.(f);
    if ~isequal(class(xval), class(goldval))
        errs{end+1} = [prefix sprintf('field ''%s'' is wrong class (%s vs. %s)', ...
            f, class(xval), class(goldval))];
    else
        if ~isequal(size(goldval), size(xval))
            errs{end+1} = [prefix sprintf('field ''%s'' is wrong size (%s vs %s)', ...
                f, mat2str(size(xval)), mat2str(size(goldval)))];
        else
            if iscell(goldval) % check cell array for structs
                for j = 1:numel(goldval)
                    if isstruct(goldval{j})
                        suberrs = grade.compare_fields(goldval{j}, xval{j}, ...
                            [prefix sprintf('%s.%s{%d}: ', inputname(2), f, j)], tol);
                        errs = {errs{:} suberrs{:}};
                    end
                end
            end
            if isstruct(goldval) % check struct / struct array
                for j = 1:numel(goldval)
                    suberrs = grade.compare_fields(goldval(j), xval(j), ...
                        [prefix sprintf('%s.%s(%d): ', inputname(2), f, j)], tol);
                    errs = {errs{:} suberrs{:}};
                end
            end
            if isnumeric(xval) && isnumeric(goldval)
                if any(abs(xval(:)-goldval(:)) > tol)
                    errs{end+1} = ...
                        [prefix sprintf(['field ''%s'' has wrong ' ...
                                        'value (max diff = %.3g)'], ...
                                        f, max(abs(xval(:)-goldval(:))))];
                end
            else
                if ~isequal(xval, goldval)
                    errs{end+1} = [prefix sprintf('field ''%s'' has wrong value', f)];
                end
            end
        end
    end
end

for i = 1:numel(errs)
    errs{i} = [callprefix errs{i}];
end

