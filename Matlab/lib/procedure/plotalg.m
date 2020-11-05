function plotalg(algdata,config)

dispstep('plot');

%% Plotting
mainfig = figure('Name','Ergebnisse','units','normalized','outerposition',[0 0.05 1 0.94]);
secfig = figure('Name','Ergebnisse','units','normalized','outerposition',[0 0.05 1 0.94]);
maintg = uitabgroup('Parent',mainfig);
sectg = uitabgroup('Parent',secfig);

for k = 1:length(algdata)
    
    % Define algorithm
    algorithm = algdata{k}.algorithm;
    
    % Extract algplots for algorithm
    if any(strcmp(config.algorithms,algorithm))
        mainalgplots = config.(['main' lower(algorithm) 'plots']);
        secalgplots = config.(['sec' lower(algorithm) 'plots']);
        algplots = [mainalgplots secalgplots];
    else
        error(['Plot: No algorithm ' algorithm ' available.']); 
    end
      
    % Plot on main figure
    ax = createmainplotui(maintg,algdata{k},k,algplots,config);
    plotonmainui(ax,algdata{k},mainalgplots,config);
    
    % Plot on second figure
    [axl,axr] = createsecplotui(sectg,algdata{k},k);
    plotonsecui(axl,axr,algdata{k},secalgplots,config);
    
end

%% Link axes
% for j = 1:size(ax,2)
%     if isequal(algplots{j},'disceig') 
%         linkaxes(ax(:,j),'xy');
%     end
% end

end