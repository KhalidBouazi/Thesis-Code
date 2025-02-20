function disceigplot(result,args)

%% Extract arguments
d = result.(args{1});

%% Plot config
AxesColor = [96, 96, 96]/255;
AxesWidth = 1.5;
PredEigColor = [0.6350, 0.0780, 0.1840];
TrueEigColor = [0.4660, 0.6740, 0.1880];
PredEigMarker = 'o';
TrueEigMarker = 'x';
    
%% Start plotting
realeig = real(d);
imageig = imag(d);
% xlimit = [min(realeig),max(realeig)];
% ylimit = [min(imageig),max(imageig)];

varstr = '$\lambda$';
theta = 0:0.001:2*pi;
x = cos(theta);
y = sin(theta);
plot(x,y,'Color',AxesColor,'LineWidth',AxesWidth);
hold on;

scatter(realeig,imageig,'MarkerEdgeColor',PredEigColor,'Marker',PredEigMarker);
% if xlimit(1) < xlimit(2)
%     xlim(xlimit);
% end
% if ylimit(1) < ylimit(2)
%     ylim(ylimit);
% end

axis equal;
xlabel(strcat('Re(',varstr,')'));
ylabel(strcat('Im(',varstr,')'));
% grid on;

end
