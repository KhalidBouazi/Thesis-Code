function reconstructplot(t,X,X_)

%% Check function arguments
if nargin < 3
    error('Arguments: Minimum number of arguments is 3.');
end

%% Plot config
PredXColor = [0.6350, 0.0780, 0.1840];
TrueXColor = [0.4660, 0.6740, 0.1880];

%% Start plotting
m = size(X,1);
for i = 1:m
    subplot(m,1,i);
    varstr = strcat('x_',num2str(i));
    plot(t,X(i,:),'Color',TrueXColor);
    hold on;
    plot(t,X_(i,:),'Color',PredXColor);
    xlim([t(1) t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Pred');
    elseif i == 3
        xlabel('Zeit in s');
    end
end

end