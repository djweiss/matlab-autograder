function [errs] = test_myfun()

% Suppose myfun is supposed to compute the mean of some data.
X = randn(10,5);
mn = mean(X);

% Check for differences between desired outputs, will return an
% error message like 'returned mean differs by <some amount>'.
errs = grade.assert_equal_mat(mn, myfun(X), 'returned mean');

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