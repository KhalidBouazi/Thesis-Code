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
if size(Xr,1) < 5
    l = 1:size(Xr,1);
    figheight = (size(Xr,1) + 1)*100;
else
    l = [1 round(linspace(2,size(Xr,1),4))];
    figheight = 500;
end
n = length(l);

tr = result.tr;
tp = result.tp;
t = [tr tp];
X = [Xtrain Xtest];
tp = [tr(end) tp];
Xp = [Xr(:,end) Xp];
for i = 1:n
    subtightplot(n,1,i,[0.02 0],[0.12 0.03],[0.12 0.05]);
    varstr = strcat(x,'_{',num2str(l(i)),'}');
    
    plot(t,X(l(i),:),'Color',TrueYColor);
    hold on;
    plot(tr,Xr(l(i),:),'Color',RecYColor);
    plot(tp,Xp(l(i),:),'Color',PredYColor);
    xlim([t(1) t(end)]);
    ylabel(strcat('$',varstr,'$'));
    
    if i == 1
        legend('Ref','Recon','Pred');
    end
    if i == n
        xlabel('Zeit in s');
    else
        set(gca,'xticklabel',{[]})
    end
    
    txt = ['recon. rmse: ' num2str(RMSEXr(l(i)))];
    text(1,1,txt,'Units','normalized','VerticalAlignment','bottom',...
        'HorizontalAlignment','right','FontSize',RMSEFontSize);
end

end