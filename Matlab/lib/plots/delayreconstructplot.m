function delayreconstructplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'V','V_'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Plot config
PredYColor = [0.6350, 0.0780, 0.1840];
TrueYColor = [0.4660, 0.6740, 0.1880];

%% Start plotting
if size(result.V,2) - 1 < 5
    m = size(result.V,2) - 1;
else
    m = 5; 
end

offset = 3;
diffspan = (offset:size(result.V,1)-offset);
t = result.t(diffspan);

for i = 1:m
    subplot(m,1,i);
    varstr = strcat('v_{',num2str(i),'}');
    plot(t,result.V(diffspan,i),'Color',TrueYColor);
    hold on;
    plot(t,result.V_(:,i),'Color',PredYColor);
    xlim([t(1) t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Pred');
    elseif i == m
        xlabel('Zeit in s');
    end
end

end