function axs = createsecplotui(tg,algdata,algnr)

tab = uitab(tg,'Title',[algdata.algorithm ' ' num2str(algnr)]);

%% Create 2 panels
plotpanleft = uipanel(tab,'FontSize',12,'BackgroundColor','white',...
    'Position',[0 0 0.6 1]);
plotpanrighttop = uipanel(tab,'FontSize',12,'BackgroundColor','white',...
    'Position',[0.6 0.6 0.4 0.4]);
plotpanright = uipanel(tab,'FontSize',12,'BackgroundColor','white',...
    'Position',[0.6 0 0.4 0.6]);

%% For plotting
axs(1) = axes('Parent',plotpanleft);
axs(2) = axes('Parent',plotpanrighttop);
axs(3) = axes('Parent',plotpanright);

end