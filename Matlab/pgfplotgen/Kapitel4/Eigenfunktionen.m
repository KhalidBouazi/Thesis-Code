%% Load mat file
% var = 'hdmdresult';
% data = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel4\Duffing_Periodisch.mat',var);
% data = data.(var);

%% Delays
d = [6,8,48];
data = hdmdresult;

%%
phi = {};
for i = 1:length(data)
    hi = data{1,i};
    if any(hi.delays == d)
        t = 1:length(hi.tr)/2;
        [W,D,V] = eig(hi.Atilde);
        phi_ = real(V'*hi.U_'*hi.H);
        maxphi = max(abs(phi_),[],2);
        [~,idx] = sort(maxphi,'descend');
        maxphi = maxphi(idx,:);
        phi{end+1} = phi_(idx,t)./maxphi;
    end
end

for i = 1:length(phi)
    for j = 1:3
        subplot(3,1,j);
        hold on;
        plot(t,phi{1,i}(2*j,:));
    end 
end

t = data{1,1}.tr(t);

%%
% pgfplot(t,phi{1,1}(1,:),'1',...
%     t,phi{1,2}(1,:),'2',...
%     t,phi{1,3}(1,:),'3','4_duffing_eigf1','C:\Users\bouaz\Desktop\Thesis\pics');
% 
% pgfplot(t,phi{1,1}(3,:),'1',...
%     t,phi{1,2}(3,:),'2',...
%     t,phi{1,3}(3,:),'3','4_duffing_eigf2','C:\Users\bouaz\Desktop\Thesis\pics');
% 
% pgfplot(t,phi{1,1}(5,:),'1',...
%     t,phi{1,2}(5,:),'2',...
%     t,phi{1,3}(5,:),'3','4_duffing_eigf3','C:\Users\bouaz\Desktop\Thesis\pics');
% 
% 





