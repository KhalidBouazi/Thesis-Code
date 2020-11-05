function reconstructplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','Y_'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Plot config
PredYColor = [0.6350, 0.0780, 0.1840];
TrueYColor = [0.4660, 0.6740, 0.1880];

%% Start plotting
m = size(result.Y,1);
for i = 1:m
    subplot(m,1,i);
    varstr = strcat('x_{',num2str(i),'}');
    plot(result.t,result.Y(i,:),'Color',TrueYColor);
    hold on;
    plot(result.t,result.Y_(i,:),'Color',PredYColor);
    xlim([result.t(1) result.t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Pred');
    elseif i == m
        xlabel('Zeit in s');
    end
end

end