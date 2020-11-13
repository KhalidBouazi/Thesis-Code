function conteigplot(result,args)

%% Extract arguments
omega = result.(args{1});

%% Plot config
AxesColor = [96, 96, 96]/255;
AxesWidth = 2;
PredEigColor = [0.6350, 0.0780, 0.1840];
TrueEigColor = [0.4660, 0.6740, 0.1880];
PredEigMarker = 'o';
TrueEigMarker = 'x';
    
%% Start plotting
realeig = real(omega);
imageig = imag(omega);
xlimit = [min(realeig),max(realeig)];
ylimit = [min(imageig),max(imageig)];

varstr = '$\omega$';
plot(xlimit,[0 0],'Color',AxesColor,'LineWidth',AxesWidth);
hold on;
plot([0 0],ylimit,'Color',AxesColor,'LineWidth',AxesWidth);

scatter(realeig,imageig,'MarkerEdgeColor',PredEigColor,'Marker',PredEigMarker);
if xlimit(1) < xlimit(2)
    xlim(xlimit);
end
if ylimit(1) < ylimit(2)
    ylim(ylimit);
end

xlabel(strcat('Re(',varstr,')'));
ylabel(strcat('Im(',varstr,')'));
% grid on;

end
