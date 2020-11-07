function plotonsecui(axs, algdata, algplots, config)

%% Plotting
for j = 1:length(algplots)
    plotname = algplots{j};
    if isfield(config.general.plots,plotname)
        axes(axs(j));
        fun = config.general.plots.(plotname).fun;
        fun(algdata);
    end
end

end