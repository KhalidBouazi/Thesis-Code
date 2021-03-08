%% Load mat file
var = 'controlresult';
datac = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel6\Beispielsystem_ref-10.mat',var);
datac = datac.(var);

%%

t = datac{1,1}.t;
Yl = datac{1,4}.y(end,:);
Yk = datac{1,3}.y(2,:);
Yd = datac{1,2}.y(end,:);
Yd2 = datac{1,1}.y(end,:);

ul = datac{1,4}.u;
uk = datac{1,3}.u;
ud = datac{1,2}.u;
ud2 = datac{1,1}.u;

ucl = datac{1,4}.u_cost;
uck = datac{1,3}.u_cost;
ucd = datac{1,2}.u_cost;
ucd2 = datac{1,1}.u_cost;

%%
pgfplot(t,Yl,'1',...
    t,Yk,'2',...
    t,Yd,'3',...
    t,Yd2,'4','6_bsp_x2_-10','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,ul,'1',...
    t,uk,'2',...
    t,ud,'3',...
    t,ud2,'4','6_bsp_u_-10','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,ucl,'1',...
    t,uck,'2',...
    t,ucd,'3',...
    t,ucd2,'4','6_bsp_ucost_-10','C:\Users\bouaz\Desktop\Thesis\pics');