% simconfig;

%% Betrachtete Modelle
n = [4]% 5:6:36%18
% n = [4,7,10,13,16];
qy = {1e4,[1 1],1,1,1,1,1};
% qy = {1e3,1e3,1e3,1e3,1e3,1e3,1e3};
% qy = {1e6,1e6,1e6,1e6,1e6,1e6,1e6};
qu = {1,1,1,1,1,1,1};
s = {1,1,1,1,1,1,1};
data = {};
for i = n
    data{1,end+1} = hdmdcresult{1,i}; 
end
params = hdmdcresult{1,1}.params;
x0 = [3;-3];
% x0 = [0.8;0.5;0.8];

%% Zusätzliche Modelle
controlresult = {};
% data{1,end+1} = examplekoopsyslin_lqr(x0,params);
% qy{1,end+1} = [0 1 0];
% qu{1,end+1} = [1];
% s{1,end+1} = [1];
% data{1,end+1} = examplesyslin_lqr(x0,params);
% data{1,end+1} = duffinglin_lqr(x0,params);
% data{1,end+1} = vanderpollin_lqr(x0,params);
% data{1,end+1} = trippletanklin_lqr(x0);
% qy{1,end+1} = [0 1];
% qu{1,end+1} = [1];
% s{1,end+1} = [1];

%% Zu regeln
cntl = 1; % Variable
ref = 0;  % Wert

%% Simulationsparameter
timelen = 600;
dimred = 1;
colors = {[0, 0.4470, 0.7410],[0.8500, 0.3250, 0.0980],[0.9290, 0.6940, 0.1250]	,[0.4940, 0.1840, 0.5560],[0.4660, 0.6740, 0.1880],[0.3010, 0.7450, 0.9330],[0.6350, 0.0780, 0.1840]};
leg = {};

%% Regelung
figure('Position',[100 100 1000 500]);
for j = 1:length(ref)
for i = 1:length(data)
    %
    res = data{1,i};

    %
    qy_ = qy{i};
    qu_ = qu{i};
    s_ = s{i};
    yref = zeros(rows(res.Yr),1);
    for k = 1:length(cntl)
        idx = find(res.measured == cntl(k));
        yref(idx) = ref(j);
    end


    if i > length(n)     
        [t,y,u,u_cost,K,Q,omega] = LQRc(res,qy_,s_,yref,timelen,x0);
    else
        [t,y,u,u_cost,K,Q,yref,omega] = LQRd(res,qy_,qu_,s_,yref,timelen,dimred,x0);
    end
    
    controlresult{1,i} = struct('t',t,'y',y,'u',u,'u_cost',u_cost,'K',K,'Q',Q,'yref',yref,'omega',omega);
    
    nmeas = length(qy_);
    
    idx = find(res.measured == 1);
    if ~isempty(idx)
        subplot(2,3,1);
        hold on;
        plot(t,y(end-nmeas+idx,:),'Color',colors{i});
        ylabel('$y_1$');
        xlabel('Zeit in s');
    end

    idx = find(res.measured == 2);
    if ~isempty(idx)
        subplot(2,3,2);
        hold on;
        plot(t,y(end-nmeas+idx,:),'Color',colors{i});
        ylabel('$y_2$');
        xlabel('Zeit in s');
    end

    idx = find(res.measured == 3);
    if ~isempty(idx)
        subplot(2,3,3);
        hold on;
        plot(t,y(end-nmeas+idx,:),'Color',colors{i});
        ylabel('$y_3$');
        xlabel('Zeit in s');
    end
    
    subplot(2,3,4);
    hold on;
    plot(t,u(1,:),'Color',colors{i});
    ylabel('$u$');
    xlabel('Zeit in s');

    subplot(2,3,5);
    hold on;
    plot(t,u_cost,'Color',colors{i});
    ylabel('$\sum u^T u$');
    xlabel('Zeit in s');
    
%     leg = [leg {num2str(res.delays)}];
    leg = [leg {num2str(res.rank)}];
end
end

legend(leg);
