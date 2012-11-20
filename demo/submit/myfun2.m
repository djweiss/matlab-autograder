function [stats] = myfun2(X)

    stats.rho = corrcoef(X);
    stats.stats = struct('mean',mean(X)', 'std', std(X));
