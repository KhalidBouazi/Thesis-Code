function eigplot(eig,type)

%% Check function arguments
if nargin < 2
    error('Arguments: Minimum number of arguments is 2.');
end

%% Plot config
AxesColor = [96, 96, 96]/255;
AxesWidth = 2;
PredEigColor = [0.6350, 0.0780, 0.1840];
TrueEigColor = [0.4660, 0.6740, 0.1880];
PredEigMarker = 'o';
TrueEigMarker = 'x';

%% Start plotting
figure;

realeig = real(eig);
imageig = imag(eig);
xlimit = [min(realeig),max(realeig)];
ylimit = [min(imageig),max(imageig)];

if strcmp(type,'discrete')
    varstr = '$\lambda$';
    theta = 0:0.001:2*pi;
    x = cos(theta);
    y = sin(theta);
    plot(x,y,'Color',AxesColor,'LineWidth',AxesWidth);
    hold on;
elseif strcmp(type,'continuous')
    varstr = '$\omega$';
    plot(xlimit,[0 0],'Color',AxesColor,'LineWidth',AxesWidth);
    hold on;
    plot([0 0],ylimit,'Color',AxesColor,'LineWidth',AxesWidth);
else
    error('Eigenvalue type: No such type available.');
end

scatter(realeig,imageig,'MarkerEdgeColor',PredEigColor,'Marker',PredEigMarker);
xlim(xlimit);
ylim(ylimit);
xlabel(strcat('Re(',varstr,')'));
ylabel(strcat('Im(',varstr,')'));
grid on;

end
