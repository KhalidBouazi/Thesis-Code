%% Load mat file
% var = 'hdmdresult';
% data = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel4\Beispielsystem.mat',var);
% data = data.(var);

%%
figure;
m = length(hdmdresult);
n = 2;
for j = 1:n
    subplot(1,n,j);
    for i = 1:m
        V = hdmdresult{1,i}.V_(:,j);
        plot3(5*i*ones(length(V),1),1:length(V),V,'Color',1/(i+1)*[1 1 1]);
        hold on;
    end
end


%%