result = struct('passed', 0, 'failed', 0);
results_file = 'results.txt';
fid = fopen(results_file,'w');

% Also setup easy to read version.
report_file = 'report.html';
global report_fid;
report_fid = fopen(report_file, 'w');
fprintf(report_fid, '<html><head><link type="text/css" rel="stylesheet" href="m2html.css" /></head><body>');

if exist('header.html', 'file')
    header_html = textread('header.html', '%s','delimiter','\n','whitespace','', ...
        'bufsize', 1e6);
    fprintf(report_fid, strjoin('\n', header_html));
end
