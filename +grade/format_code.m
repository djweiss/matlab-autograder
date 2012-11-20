function [errs] = format_code()

errs = {};

% Get the list of code files
code_files_list;
    
addpath m2html
m2html('mfiles', code_files);

unix('cp -av doc/m2html.css .');

!rm -vf code.html
for i = 1:numel(code_files)
    unix(sprintf('awk -f extract_src_html.awk doc/%s.html >> code.html', ...
        code_files{i}(1:end-2)));
end
!rm -rf doc
 