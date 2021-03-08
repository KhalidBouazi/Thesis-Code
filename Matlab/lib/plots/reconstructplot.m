function figheight = reconstructplot(result,args)

%% Extract arguments
Xtrain = result.(args{1});
Xr = result.(args{2});
RMSEXr = result.(args{3});
Xtest = result.(args{4});
Xp = result.(args{5});
RMSEXp = result.(args{6});
x = args{7};

%%
if strcmp(args{1},'Vtrain')
    Xtrain = Xtrain';
    Xr = Xr';
    Xtest = Xtest';
    Xp = Xp';
end

%% Plot config
RecYColor = [0, 0.4470, 0.7410];
PredYColor = [0.6350, 0.0780, 0.1840];
TrueYColor = [0.4660, 0.6740, 0.1880];
RMSEFontSize = 10;

%% Start plotting
% if size(Xr,1) < 5
%     l = 1:size(Xr,1);
%     figheight = (size(Xr,1) + 1)*100;
% else
%     l = [1 round(linspace(2,size(Xr,1),4))];
%     figheight = 500;
% end
if size(RMSEXr,1) < 5
    l = 1:size(RMSEXr,1);
    figheight = (size(RMSEXr,1) + 1)*100;
else
    l = [1 round(linspace(2,size(RMSEXr,1),4))];
    figheight = 500;
end
n = length(l);

tr = result.tr;
tp = result.tp;
for i = 1:n
    subtightplot(n,2,2*i-1,[0.02 0.1],[0.12 0.03],[0.12 0.05]);
    varstr = strcat(x,'_{',num2str(l(i)),'}');
    
    plot(tr,Xtrain(l(i),:),'Color',TrueYColor);
    hold on;
    plot(tr,Xr(l(i),:),'Color',RecYColor);
    xlim([tr(1) tr(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Recon');
    end
    if i == n
        xlabel('Zeit in s');
    else
        set(gca,'xticklabel',{[]})
    end
    
    txt = ['recon. rmse: ' num2str(RMSEXr(l(i)))];
    text(1,1,txt,'Units','normalized','VerticalAlignment','bottom',...
        'HorizontalAlignment','right','FontSize',RMSEFontSize);
    
    %%%%
    subtightplot(n,2,2*i,[0.02 0.1],[0.12 0.03],[0.12 0.05]);
    varstr = strcat(x,'_{',num2str(l(i)),'}');
    
    plot(tp,Xtest(l(i),:),'Color',TrueYColor);
    hold on;
    plot(tp,Xp(l(i),:),'Color',PredYColor);
    xlim([tp(1) tp(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Pred');
    end
    if i == n
        xlabel('Zeit in s');
    else
        set(gca,'xticklabel',{[]})
    end
    
    txt = ['pred. rmse: ' num2str(RMSEXp(l(i)))];
    text(1,1,txt,'Units','normalized','VerticalAlignment','bottom',...
        'HorizontalAlignment','right','FontSize',RMSEFontSize);


end

end