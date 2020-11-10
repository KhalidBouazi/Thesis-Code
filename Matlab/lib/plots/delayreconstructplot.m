function delayreconstructplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'V','V_','t','rmseV_'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Plot config
PredYColor = [0.6350, 0.0780, 0.1840];
TrueYColor = [0.4660, 0.6740, 0.1880];
RMSEFontSize = 10;

%% Start plotting
if size(result.V,2) - 1 < 5
    l = 1:(size(result.V,2) - 1);
else
    l = [1 round(linspace(2,size(result.V,2)-1,4))];
end
n = length(l);

offset = 3;
diffspan = (offset:size(result.V,1)-offset);
t = result.t_;

for i = 1:n
    subtightplot(n,1,i,[0.02 0],[0.07 0.03],[0.12 0.05]);
    varstr = strcat('v_{',num2str(l(i)),'}');
    plot(t,result.V(diffspan,l(i)),'Color',TrueYColor);
    hold on;
    plot(t,result.V_(:,l(i)),'Color',PredYColor);
    xlim([t(1) t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Pred');
    end
    if i == n
        xlabel('Zeit in s');
    else
        set(gca,'xticklabel',{[]})
    end
    
    txt = ['rmse: ' num2str(result.RMSEV_(l(i)))];
    text(1,1,txt,'Units','normalized','VerticalAlignment','bottom',...
        'HorizontalAlignment','right','FontSize',RMSEFontSize);
end

end