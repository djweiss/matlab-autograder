function [result] = try_catch_error(cmd, fid, result)

try
    eval(['errs = ' cmd]);
    if numel(errs) > 0
        for i = 1:numel(errs)
            fprintf(fid, '%s\n', errs{i});
        end
        result.failed = result.failed + 1;
    else
        result.passed = result.passed + 1;    
    end
    
catch ME
    if isempty(ME.identifier)
        fprintf(fid, '%s\n', ME.message);
    else
        [path name ext] = fileparts(ME.stack(1).file);
        fprintf(fid, 'critical FAILED: Your code crashed the test suite running command ''%s'' at %s:%d, error:\n\t%s\n', ...
             cmd, [name ext], ME.stack(1).line, ME.message);
        fprintf(fid, '\t-->NOTE: This means that we could not verify whether or not some subset of your submitted code worked.\n');
    end    
    result.failed = result.failed + 1;
end
