function [main,sec] = divideplots(algdata,config)

algplots = config.(lower(algdata.algorithm)).plots;
plots = config.general.plots;

main = {};
sec = {};
for i = 1:length(algplots)
    algplot = algplots{i};
    if isfield(plots,algplot)
        if strcmp(plots.(algplot).loc,'main')
            main = [main algplot];
        elseif strcmp(plots.(algplot).loc,'sec')
            sec = [sec algplot];
        end
    end
end

end