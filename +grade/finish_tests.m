border = repmat('*',  [1 72]);
fprintf(fid, [border '\nTest results: Passed %d / Failed %d\n'], ...
    result.passed, result.failed);

if result.failed == 0
    fprintf(fid, 'CONGRATULATIONS! You passed all the tests.\n');
end

fprintf(fid, '### Tests finished at: %s', datestr(now));
fclose(fid);

% Write into report.html as well.
results_txt = textread(results_file, '%s','delimiter','\n','whitespace','', ...
                       'bufsize', 1e6);
fprintf(report_fid, '<hr style="clear:both;" /><h1>Programmatic Tests:</h1><pre>');
fprintf(report_fid, grade.strjoin('\n', results_txt));
fprintf(report_fid, '</pre>\n');

% Copy code.html into report.html
fprintf(report_fid, '<h1>Required Code</h1>\n');
fclose(report_fid);
try
    unix(sprintf('cat code.html >> %s', report_file));
catch
    fprintf('Could not import code.html');    
end
report_fid = fopen(report_file, 'a');
fprintf(report_fid, '</body></html>');
fclose(report_fid);

% Rewrite results.txt so that all newlines get properly written to file.
results_txt = grade.strjoin('\n', results_txt);
fid = fopen(results_file,'w');
fprintf(fid, results_txt);
fclose(fid);
fprintf(results_txt);
