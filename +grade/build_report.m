function [html errors] = build_report(report)
% function [html] = build_report(report)
e = @(x) [mfilename ' FAILED: ' x];

html = [sprintf('<h1>%s</h1>', report.name)];
errors = {};

for i = 1:numel(report.sections)
    default_answers{i} = 'Answers file not found.';
end

if isfield(report, 'load_answers')    
    [errors failed] = grade.quiet_assert(errors, exist(report.load_answers, 'file')>0, ...
                                   e('Unable to find written answers file: %s'), ...
                                   report.load_answers);
    if failed
        answers = default_answers;        
    else
        load(report.load_answers, 'answers');        
    end
end

[errors failed] = grade.quiet_assert(errors, numel(answers) == numel(report.sections), ...
       e('%s: numel(answers) == %d but should be %d'), report.name, ...
       numel(answers), numel(report.sections));
if failed
    answers = default_answers;
end

for i = 1:numel(report.sections)
    html = [html sprintf('<hr><h4>%s.%d</h4>', report.name, i)];
    if isfield(report, 'load_answers')
        [add_html errors] = section_html(errors, report.sections{i}, answers{i});
    else
        [add_html errors] = section_html(errors, report.sections{i});
    end
    html = [html add_html];
end

function [html errors] = section_html(errors, section, answer)
e = @(x) [mfilename ' FAILED: ' x];

imgtemplate = ['<div style="float:left; background: #aaa; padding:20px; ">' ...
    '<center><b>[%s] %s:</b>' ...
    '<br /><img src="%s" width=500/></center></div>'];

answertemplate = ['<p style="clear:both;" ><b>Answer:</b>%s</p>'];
html = '';

if isfield(section, 'images')
    for i = 1:numel(section.images)

        % try to find any variant of the file, accepting either - or _.        
        filename = section.images{i};
        [path name ext] = fileparts(filename);
        possible_matches = dir(fullfile(path, ['*' ext]));
        possible_matches = {possible_matches.name};
        fixed_matches = regexprep(possible_matches, '[_\-]', '_');
        fixed_name = regexprep([name ext], '[_\-]', '_');
        file_idx = strmatch(fixed_name, fixed_matches);
        if ~isempty(file_idx)
            filename = possible_matches{file_idx(1)};
        end
        errors = grade.quiet_assert(errors, numel(file_idx) <= 1, ...
            e('Too many plot images: which one do you want? %s'), ...
                              grade.strjoin(',', possible_matches(file_idx)));
        [errors failed] = grade.quiet_assert(errors, ~isempty(file_idx), ...
            e('File does not exist: %s'), section.images{i});
        if failed
            filename = 'missing.jpg';
        end
        html = [html sprintf(imgtemplate, filename, ...
            section.captions{i}, filename)];
    end
end

if isfield(section, 'matrix')
    for i = 1:numel(section.matrix)
        [errors failed] = grade.quiet_assert(errors, ...
            exist(section.matrix{i}, 'file')>0, ...
            e('File does not exist: %s'), section.matrix{i});

        if ~failed
            userdata = load(section.matrix{i});
            refdata = load(['ref_' section.matrix{i}]);
            
            errors = grade.quiet_assert(errors, isequal(size(userdata), size(refdata)), ...
                   e('Data is incorrect size: %s should be %s, not %s'), ...
                   section.matrix{i}, size(refdata), size(userdata));
            errors = grade.quiet_assert(errors, isequal(userdata, refdata), ...
                   e('Data is incorrect: %s'), section.matrix{i});
        end
    end
end

if nargin==3
    html = [html sprintf(answertemplate, answer)];
end



