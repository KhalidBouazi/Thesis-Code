function [saved,printed] = printresult(result, checkedplots, savetype, config)

%% Create directory to place results in
path = [config.general.(['plotpath' savetype]) result.algorithm '\' result.system];
if ~isdir(path)
    mkdir(path)
end
    
%% Create foldername, path and folder
foldername = foldernameconvention(result,config);
folderpath = [path '\' foldername];
if ~isdir(folderpath)
    mkdir(folderpath)
end

%% Delete tikz if folder exists
if strcmp(savetype,'tikz') && exist(folderpath,'dir')
    deletetikzinfolder(folderpath)
end

%% Save every plot that was checked in the figure
for i = 1:length(checkedplots)
    checkedplot = checkedplots{i};
    if isfield(config.general.plots,checkedplot)
        printplot(checkedplot,savetype,result,folderpath,config)
    end
end

%% Save data that generated those plots
saved = saveresult(result,folderpath,config);
printed = true;

end