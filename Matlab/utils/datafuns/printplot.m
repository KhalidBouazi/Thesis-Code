function printplot(plottype, savetype, result, folderpath, config)

fun = config.general.plots.(plottype).fun;
plotfunname = func2str(fun);
plotfunname = plotfunname(1:end-4);

%% Switch through plotnames
if strcmp(savetype,'tikz')
    switch plottype
        case 'phase'
            x = result.X(1,:);
            y = result.X(2,:);
            z = result.X(3,:);
            pgfplot3(x,y,z,plottype,folderpath);
        case 'disceig'
            d = result.d;
            pgfdisceigplot_(real(d),imag(d),plottype,folderpath);
        case 'sing'
            s = result.s;
            pgfsingplot_(1:length(s),s,plottype,folderpath);
        otherwise
            error('Print plot: Not all plotfunctions implemented as tikz.');
    end
elseif strcmp(savetype,'png')
    if strcmp(plotfunname,'reconstruct') || strcmp(plotfunname,'delayreconstruct') || strcmp(plotfunname,'convcoordreconstruct')
        fig = figure('Position',[300 300 1200 800]);
    elseif strcmp(plotfunname,'phase') || strcmp(plotfunname,'delayphase') || strcmp(plotfunname,'phasebasis')
        fig = figure('Position',[300 300 600 500]);
    elseif strcmp(plotfunname,'matrix') || strcmp(plotfunname,'disceig') || strcmp(plotfunname,'conteig') 
        fig = figure('Position',[300 300 600 500]);
    elseif strcmp(plotfunname,'sing') || strcmp(plotfunname,'rmse')
        fig = figure('Position',[300 300 600 300]);
    end
    args = config.general.plots.(plottype).args;
    fun(result,args);
    saveas(gcf,[folderpath plottype '.png']);
    close(fig);
end

end