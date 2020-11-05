function delayseriesplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'V'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Start plotting
if size(result.V,2) < 10
    m = size(result.V,2);
else
    m = 5; 
end

t = result.t(1:size(result.V,1));

for i = 1:m
    subplot(m,1,i);
    varstr = strcat('v_{',num2str(i),'}');
    plot(t,result.V(:,i));
    xlim([t(1) t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == m
        xlabel('Zeit in s');
    end
end

end