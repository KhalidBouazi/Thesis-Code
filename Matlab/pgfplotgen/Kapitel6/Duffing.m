%% Load mat file
var = 'controlresult';
datac = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel6\Duffing_dimred_x1_q1e6_ref0.mat',var);
datac = datac.(var);

%%

t = datac{1,1}.t;
Y50 = datac{1,1}.y(end,:);
Y100 = datac{1,2}.y(end,:);
Y150 = datac{1,3}.y(end,:);
Y200 = datac{1,4}.y(end,:);
Y300 = datac{1,5}.y(end,:);

u50 = datac{1,1}.u;
u100 = datac{1,2}.u;
u150 = datac{1,3}.u;
u200 = datac{1,4}.u;
u300 = datac{1,5}.u;

uc50 = datac{1,1}.u_cost;
uc100 = datac{1,2}.u_cost;
uc150 = datac{1,3}.u_cost;
uc200 = datac{1,4}.u_cost;
uc300 = datac{1,5}.u_cost;

%%
pgfplot(t,Y50,'1',...
    t,Y100,'2',...
    t,Y150,'3',...
    t,Y200,'4',...
    t,Y300,'5','6_duf_x1_q1e6_ref0','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,u50,'1',...
    t,u100,'2',...
    t,u150,'3',...
    t,u200,'4',...
    t,u300,'5','6_duf_u_x1_q1e6_ref0','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,uc50,'1',...
    t,uc100,'2',...
    t,uc150,'3',...
    t,uc200,'4',...
    t,uc300,'5','6_duf_ucost_x1_q1e6_ref0','C:\Users\bouaz\Desktop\Thesis\pics');