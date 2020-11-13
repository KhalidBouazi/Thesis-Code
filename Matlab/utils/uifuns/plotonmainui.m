function plotonmainui(ax, algdata, algplots, config)

%% Plotting
width = 2;
height = round(length(algplots)/width);
cnt = 1;

axes(ax);
for j = 1:length(algplots)
    plottype = algplots{j};
    if isfield(config.general.plots,plottype)
        subtightplot(height,width,cnt,[0.1 0.1],[0.1 0.05],[0.1 0.05]);
        fun = config.general.plots.(plottype).fun;
        args = config.general.plots.(plottype).args;
        fun(algdata,args);
        cnt = cnt + 1;
    end
end

end