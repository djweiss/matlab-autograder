function [errs] = assert_equal_mat(x, gold, label, tol)

caller = dbstack; caller = caller(2); 
prefix = [caller.name ' FAILED: '];   

if nargin==2
    label = inputnames(1);
    if isempty(label)
        label = 'input';
    end
end
if nargin==3
    tol = 1e-10;
end

errs = {};
if ~isequal(size(x), size(gold))
    errs{end+1} = ...
        sprintf('%s has incorrect size: %s vs. %s', ...
		label, mat2str(size(x)), mat2str(size(gold)));

    for i = 1:numel(errs)
        errs{i} = [prefix errs{i}];
    end

    return;
end

if any(abs(x(:)-gold(:)) > tol)
    errs{end+1} = sprintf('%s has incorrect values (max diff = %.3g)', label, full(max(abs(x(:)-gold(:)))));
end
    
for i = 1:numel(errs)
    errs{i} = [prefix errs{i}];
end
