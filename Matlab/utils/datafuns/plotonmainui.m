function plotonmainui(ax, algdata, mainalgplots, config)

%% Plotting
width = 2;
height = round(length(mainalgplots)/width);
cnt = 1;

axes(ax);
for j = 1:length(mainalgplots)
    plotkey = mainalgplots{j};
    if isfield(config.mainplotfuns,plotkey)
        %axs(k,j) = subplot(height,width,j);
        subplot(height,width,cnt);
        fun = config.mainplotfuns.(plotkey);
        fun(algdata);
        cnt = cnt + 1;
    end
end

end