function rmsecompplot(results,args)

figure;

%% Extract arguments
trainsamples = [];
for i = 1:length(results)
    trainsamples = [trainsamples results{i}.timesteps];
end

trainsamples = unique(sort(trainsamples));

end