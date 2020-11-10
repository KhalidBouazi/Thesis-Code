function reconstructplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','Y_','t_','rmseY_'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Plot config
PredYColor = [0.6350, 0.0780, 0.1840];
TrueYColor = [0.4660, 0.6740, 0.1880];
RMSEFontSize = 10;

%% Start plotting
m = size(result.Y,1);
t = result.t_;
for i = 1:m
    subtightplot(m,1,i,[0.02 0],[0.07 0.03],[0.12 0.05]);
    varstr = strcat('x_{',num2str(i),'}');
    plot(t,result.Y(i,1:size(result.Y_,2)),'Color',TrueYColor);
    hold on;
    plot(t,result.Y_(i,:),'Color',PredYColor);
    xlim([t(1) t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Pred');
    end
    if i == m
        xlabel('Zeit in s');
    else
        set(gca,'xticklabel',{[]})
    end
    
    txt = ['rmse: ' num2str(result.RMSEY_(i))];
    text(1,1,txt,'Units','normalized','VerticalAlignment','bottom',...
        'HorizontalAlignment','right','FontSize',RMSEFontSize);
end

end