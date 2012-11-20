function [errs] = report_1_demo()

% Simple wrapper for error msgs
e = @(x) [mfilename ' FAILED: ' x];

% Report should be saved here
global report_fid;

% Reports are built up by section. Each report has an associated
% answers .mat file that contains a single cell array of strings
% 'answers.' For each answers{i}, there should be a corresponding
% section. Each section can have multiple plots with corresponding
% titles.
report.name = 'Demo - Problem 1';
report.load_answers = 'problem_1_answers.mat';
report.sections = { ...
    grade.makesection({'plot_1.1.jpg'}, {'Sample Plot 1'}), ...
    grade.makesection({'plot_1.2.jpg'}, {'Sample Plot 2'}), ...
    };

[html errors] = grade.build_report(report);
fprintf(report_fid, html);

assert(numel(errors) == 0, ...
       e('building report failed with errors:\n\t%s'), grade.strjoin('\n\t', errors));

