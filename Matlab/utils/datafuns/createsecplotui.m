function axs = createsecplotui(tg,algdata,algnr)

tab = uitab(tg,'Title',[algdata.algorithm ' ' num2str(algnr)]);

%% Create 2 panels
plotpanleft = uipanel(tab,'FontSize',12,'BackgroundColor','white',...
    'Position',[0 0 0.5 1]);
plotpanright = uipanel(tab,'FontSize',12,'BackgroundColor','white',...
    'Position',[0.5 0 0.5 1]);

%% For plotting
axs(1) = axes('Parent',plotpanleft);
axs(2) = axes('Parent',plotpanright);

end