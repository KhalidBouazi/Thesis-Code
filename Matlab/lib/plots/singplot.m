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
s = result.s;
s = s/sqrt(sum(s.^2));
plot(s,'LineStyle','none','Marker',SingValMarker,'Color',SingValColor);
xlabel('Rang');
ylabel('Norm. Singulaerwert');
grid on;

end