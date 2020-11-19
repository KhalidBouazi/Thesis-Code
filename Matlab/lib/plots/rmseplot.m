function rmseplot(result,args)

%% Extract arguments
rmse = result.(args{1});

%% Start plotting
if size(rmse,1) < 5
    l = 1:size(rmse,1);
else
    l = [1 round(linspace(2,size(rmse,1),4))];
end
n = length(l);

legendstr = {};
tr = result.tr;
t = [tr result.tp];
for i = 1:n
    legendstr = [legendstr, ['$\mathrm{rmse}_{' num2str(l(i)) '}$']];
    plot(t,rmse(l(i),:));
    hold on;
end
xlabel('Zeit in s');
ylabel('RMSE');
xlim([t(1) t(end)]);
ylimit = get(gca,'YLim');
x = [tr(end); max(xlim); max(xlim); tr(end)];
y = [0; 0; max(ylimit); max(ylimit)];
patch('Faces',1:4,'Vertices',[x y],'FaceColor','r','FaceAlpha',0.1);
legend(legendstr,'Location','southeast');

end