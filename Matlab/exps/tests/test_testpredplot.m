%%
n = 16;
% res = havok__result{1,n};
% res = hdmdresult{1,n};
res = hdmdcresult{1,n};
alg = res.algorithm;
rank = res.rank;
delays = res.delays;
name = 'ttank';
cha = '5_';
meas = '_x1';

%%
perm = randperm(cols(res.xv0s));
idx = perm(1:50);
% idx = round(linspace(1,100,20));
Yvs = {};
Yps = {};

if strcmp(alg,'HAVOK__')
    for i = idx
        Yvs{end+1} = res.Vtest((1:0+res.delays)+(i-1)*(res.horizon+res.delays),:)';
    end
    for i = idx
        Yps{end+1} = res.Vp((1:0+res.delays)+(i-1)*(res.horizon+res.delays),:)'; %res.horizon
    end
elseif strcmp(alg,'HDMD')
    for i = idx
        Yvs{end+1} = res.Ytest(:,(1:0+res.delays-1)+(i-1)*(res.horizon+2*res.delays-1));
    end
    for i = idx
        Yps{end+1} = res.Yp(:,(1:0+res.delays-1)+(i-1)*(res.horizon+2*res.delays-1)); %res.horizon
    end
else
    t = res.dt*(0:res.horizon+res.delays-1);
    for i = idx
        Yvs{end+1} = res.Ytest(:,(1:res.horizon+res.delays)+(i-1)*(res.horizon+res.delays));
    end
    for i = idx
        Yps{end+1} = res.Yp(:,(1:res.horizon+res.delays)+(i-1)*(res.horizon+res.delays)); %res.horizon
    end
end



% for i = idx
%      Yvs{end+1} = res.Ytest(:,(1:0+res.horizon)+(i-1)*(res.horizon));
% end
% Yps = {};
% for i = idx
%      Yps{end+1} = res.Yp(:,(1:0+res.horizon)+(i-1)*(res.horizon)); %res.horizon
% end
%%
figure;
for i = 1:length(Yps)
    if rows(Yvs{i}) > 1
        plot(Yvs{i}(1,:),Yvs{i}(2,:),'Color','b')
        hold on;
        plot(Yps{i}(1,:),Yps{i}(2,:),'Color','r')
    else
        subplot(length(Yps),1,i);
        plot(1:cols(Yvs{i}),Yvs{i},'Color','b')
        hold on;
        plot(1:cols(Yps{i}),Yps{i},'Color','r')
    end
end

%%
if ~strcmp(alg,'HDMDc')
    folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_delays' num2str(delays) '_rank' num2str(rank) '_' alg '_valid'];
    mkdir(folder);
    for i = 1:length(Yvs)
        table = [Yvs{i}(1,:)' Yvs{i}(2,:)'];
        save([folder '\' num2str(i) '.txt'], 'table', '-ascii', '-double', '-tabs');
    end


    folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_delays' num2str(delays) '_rank' num2str(rank) '_' alg '_pred'];
    mkdir(folder);
    for i = 1:length(Yps)
        table = [Yps{i}(1,:)' Yps{i}(2,:)'];
        save([folder '\' num2str(i) '.txt'], 'table', '-ascii', '-double', '-tabs');
    end
else
    folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_delays' num2str(delays) '_rank' num2str(rank) meas '_' alg '_valid'];
    mkdir(folder);
    for i = 1:length(Yps)
        table = [t' Yvs{i}'];
        save([folder '\' num2str(i) '.txt'], 'table', '-ascii', '-double', '-tabs');
    end
    
    folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_delays' num2str(delays) '_rank' num2str(rank) meas '_' alg '_pred'];
    mkdir(folder);
    for i = 1:length(Yps)
        table = [t' Yps{i}'];
        save([folder '\' num2str(i) '.txt'], 'table', '-ascii', '-double', '-tabs');
    end  
    
end
