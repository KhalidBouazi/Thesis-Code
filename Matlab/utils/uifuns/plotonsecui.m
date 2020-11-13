function plotonsecui(axs, algdata, algplots, config)

%% Plotting
for i = 1:length(algplots)
    plottype = algplots{i};
    if isfield(config.general.plots,plottype)
        axes(axs(i));
        fun = config.general.plots.(plottype).fun;
        args = config.general.plots.(plottype).args;
        fun(algdata,args);
    end
end

end