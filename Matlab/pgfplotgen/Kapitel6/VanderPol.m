%% Load mat file
var = 'controlresult';
datac = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel6\VanderPol_x1_ref0.mat',var);
datac = datac.(var);

%%

t = datac{1,1}.t;
Y80 = datac{1,1}.y(end,:);
Y120 = datac{1,2}.y(end,:);
Y160 = datac{1,3}.y(end,:);
Y200 = datac{1,4}.y(end,:);
Y250 = datac{1,5}.y(end,:);

u80 = datac{1,1}.u;
u120 = datac{1,2}.u;
u160 = datac{1,3}.u;
u200 = datac{1,4}.u;
u250 = datac{1,5}.u;

uc80 = datac{1,1}.u_cost;
uc120 = datac{1,2}.u_cost;
uc160 = datac{1,3}.u_cost;
uc200 = datac{1,4}.u_cost;
uc250 = datac{1,5}.u_cost;

%%
pgfplot(t,Y80,'1',...
    t,Y120,'2',...
    t,Y160,'3',...
    t,Y200,'4',...
    t,Y250,'5','6_vdp_x1_ref0','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,u80,'1',...
    t,u120,'2',...
    t,u160,'3',...
    t,u200,'4',...
    t,u250,'5','6_vdp_u_x1_ref0','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,uc80,'1',...
    t,uc120,'2',...
    t,uc160,'3',...
    t,uc200,'4',...
    t,uc250,'5','6_vdp_ucost_x1_ref0','C:\Users\bouaz\Desktop\Thesis\pics');