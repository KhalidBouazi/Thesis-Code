function singplot(s)

%% Plot config
SingValColor = [0.6350, 0.0780, 0.1840];
SingValMarker = 'o';

%% Start plotting
figure;

s = s/sqrt(sum(s.^2));
plot(s,'LineStyle','none','Marker',SingValMarker,'Color',SingValColor);
xlabel('Nummer');
ylabel('Normierter Singulaerwert');

end