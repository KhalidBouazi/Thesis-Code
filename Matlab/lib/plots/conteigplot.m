function conteigplot(result,args)

%% Extract arguments
omega = result.(args{1});

%% Plot config
AxesColor = [96, 96, 96]/255;
AxesWidth = 1.5;
PredEigColor = [0.6350, 0.0780, 0.1840];
TrueEigColor = [0.4660, 0.6740, 0.1880];
PredEigMarker = 'o';
TrueEigMarker = 'x';
    
%% Start plotting
realeig = real(omega);
imageig = imag(omega);

scatter(realeig,imageig,'MarkerEdgeColor',PredEigColor,'Marker',PredEigMarker);
hold on;

ymax = max(abs(min(ylim)),max(ylim));
ylim([-ymax ymax]);
xlim([min(min(xlim),-1) max(max(xlim),0.5)]);

varstr = '$\omega$';
plot(xlim,[0 0],'Color',AxesColor,'LineWidth',AxesWidth);
plot([0 0],ylim,'Color',AxesColor,'LineWidth',AxesWidth);

xlabel(strcat('Re(',varstr,')'));
ylabel(strcat('Im(',varstr,')'));
% grid on;
box on;

end
