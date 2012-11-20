function [errs] = test_myfun2()

% Suppose myfun2 is supposed to compute a set of statistics.
X = randn(10,5);

ref.rho = corrcoef(X);
ref.stats = struct('mean', mean(X), 'std', std(X));;

% Check for differences between desired outputs, will return an
% error message like 'myfun2(X).rho is wrong'
errs = grade.compare_fields(ref, myfun2(X), 'myfun2(X): ');

%% standard code for validating a single function
% If there were no errors, this marks the function as PASSED.
% If there were errors, this marks function as FAILED.
% If we never get to this point, the function is already marked as
% NOT VERIFIED because the code crashed.
global passed
testname = mfilename;
testname = testname(6:end);
if numel(errs) == 0, passed.(testname) = true;
else passed.(testname) = false;
end