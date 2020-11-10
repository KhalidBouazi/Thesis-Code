function singplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'s'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Plot config
SingValColor = [0.6350, 0.0780, 0.1840];
SingValMarker = 'o';

%% Start plotting
plot(result.sn,'LineStyle','none','Marker',SingValMarker,'Color',SingValColor);
xlabel('Rang');
ylabel('Norm. Singulaerwert');
ylim([0 1])
grid on;

end