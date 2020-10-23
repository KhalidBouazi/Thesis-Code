function plotalg(algdata,config)

%% Plotting
fig = figure('NumberTitle', 'off', 'Name','Ergebnisse','Position',[100 100 1300 650]);
tg = uitabgroup('Parent',fig);

for k = 1:length(algdata)
    
    % Define algorithm
    algorithm = algdata{k}.algorithm;
    
    % Extract algplots for algorithm
    if any(strcmp(config.algorithms,algorithm))
        algplots = config.([lower(algorithm) 'plots']);
    else
        error(['Plot: No algorithm ' algorithm ' available.']); 
    end
    
    % Compute layout dimension
    width = 2;
    height = round(length(algplots)/width);
  
    % Create figure layout with tabs
    createplotui(tg,algdata{k},k,algplots,config);
    
    % Plot algorithm data
    for j = 1:length(algplots)
        ax(k,j) = subplot(height,width,j);
        plotkey = algplots{j};
        if isfield(config.plotfuns,plotkey)
            fun = config.plotfuns.(plotkey);
            fun(algdata{k});
        else
            error(['Plot: No plot ' plotkey ' available.']);
        end
    end
    
end

%% Link axes
for j = 1:size(ax,2)
    if isequal(algplots{j},'disceig') 
        linkaxes(ax(:,j),'xy');
    end
end

end