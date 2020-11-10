function plotonmainui(ax, algdata, algplots, config)

%% Plotting
width = 2;
height = round(length(algplots)/width);
cnt = 1;

axes(ax);
for j = 1:length(algplots)
    plotname = algplots{j};
    if isfield(config.general.plots,plotname)
        %axs(k,j) = subplot(height,width,j);
        subtightplot(height,width,cnt,[0.1 0.1],[0.1 0.05],[0.1 0.05]);
        fun = config.general.plots.(plotname).fun;
        fun(algdata);
        cnt = cnt + 1;
    end
end

end