function [errs failed] = quiet_assert(errs, testcond, varargin)
% Quiet assertion.

if ~testcond
    errs{end+1} = sprintf(varargin{:});
end
failed = ~testcond;