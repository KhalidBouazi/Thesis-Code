function singplot(result,args)

%% Extract arguments
sn = result.(args{1});

%% Plot config
SingValColor = [0.6350, 0.0780, 0.1840];
SingValMarker = 'o';

%% Start plotting
plot(1:length(sn),sn,'LineStyle','none','Marker',SingValMarker,'Color',SingValColor);
xlabel('Rang');
ylabel('Norm. Singulaerwert');
xlim([0 length(sn)+1])
ylim([0 1])
% grid on;
gap = round(length(sn)/10);
xlabels = 0:gap:length(sn)+1;
set(gca,'XTick',xlabels);

end