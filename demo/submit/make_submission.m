%% Make plots and answers for submission

x = -pi:0.1:pi;
plot(x, sin(x));
print -djpeg plot-1.1.jpg

%%
clear answers;
answers{1} = 'Here is my answer for part 1.'
answers{2} = 'Here is my answer for part 2.'

save('problem_1_answers.mat', 'answers');

