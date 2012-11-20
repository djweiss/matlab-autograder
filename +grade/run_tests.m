grade.init_tests;

global passed
passed = struct();

test_files = dir('test_*.m');
report_files = dir('report_*.m');

test_files = cellfun(@(x)x(1:end-2), {test_files.name}, 'uniformoutput', false);
report_files = cellfun(@(x)x(1:end-2), {report_files.name}, 'uniformoutput', false);

code_files_list;

for f = 1:numel(code_files)
    cf = code_files{f}(1:end-2);
    passed.(cf) = -1;
end

fprintf(fid, '** Running test cases for Homework...\n\n');
for f = 1:numel(test_files)
    [result] = grade.try_catch_error([test_files{f} ';'], fid, result);
end
   
fprintf(fid, '\n** Summary of test cases:');
fprintf(fid, '\n** IN ORDER TO RECEIVE FULL CREDIT, ALL MUST READ ''PASSED''\n\n');

mfiles = fieldnames(passed);
for f = 1:numel(mfiles)
    if passed.(mfiles{f}) == 1
        str = 'PASSED';
    elseif passed.(mfiles{f}) == -1
        str = 'NOT VERIFIED';
    else
        str = 'FAILED (or not verified due to crash)';
    end
    
    fprintf(fid, '\t%s.m: %s\n', mfiles{f}, str);
end

fprintf(fid, '\n** Checking for submitted/plots analysis...\n\n');
for f = 1:numel(report_files)
    [result] = grade.try_catch_error([report_files{f} ';'], fid, result);
end

[result] = grade.try_catch_error('grade.format_code;', fid, result);

grade.finish_tests;