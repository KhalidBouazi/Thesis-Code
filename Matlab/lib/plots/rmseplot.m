function rmseplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%%
algorithm = result.algorithm;
if strcmp(algorithm,'DMD')
    rmse = result.rmseY_;
elseif strcmp(algorithm,'HDMD')
    rmse = result.rmseY_;
elseif strcmp(algorithm,'HAVOK')
    rmse = result.rmseV_;
elseif strcmp(algorithm,'CONVCOORD')
    rmse = result.rmseW_;
end

%% Start plotting
for i = 1:size(rmse,1)
    plot(result.t_,rmse(i,:));
    hold on;
end
xlabel('Zeit in s');
ylabel('RMSE');

end