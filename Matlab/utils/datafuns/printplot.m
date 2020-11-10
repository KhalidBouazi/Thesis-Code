function printplot(plottype, savetype, result, folderpath, config)

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
    fig = figure;
    fun = config.general.plots.(plottype).fun;
    fun(result);
    saveas(gcf,[folderpath plottype '.png']);
    close(fig);
end

end