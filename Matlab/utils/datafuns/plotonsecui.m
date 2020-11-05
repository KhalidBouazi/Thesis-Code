function plotonsecui(axl, axr, algdata, secalgplots, config)

%% Plotting
% for j = 1:length(secalgplots)
%     plotkey = secalgplots{j};
%     if isfield(config.secplotfuns,plotkey)
%         fun = config.secplotfuns.(plotkey);
%         fun(algdata);
%     end
% end

axes(axl);
fun = config.secplotfuns.(secalgplots{1});
fun(algdata);

axes(axr);
fun = config.secplotfuns.(secalgplots{2});
fun(algdata);

end