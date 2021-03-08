%% Load mat file
var = 'hdmdcresult';
data = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel5\Beispielsystem.mat',var);
data = data.(var);

%% Data

% continuous Eigenvalues
omega = [-1; -0.2; -0.1];   % true eigenvalues
omegaf = data{1,1}.omega;   % false
omegar = data{1,3}.omega;   % right

Omega = [real(omega),imag(omega)];
Omegaf = [real(omegaf),imag(omegaf)];
Omegar = [real(omegar),imag(omegar)];

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\5_bsp_eigenwerte');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\5_bsp_eigenwerte\1.txt', 'Omega', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\5_bsp_eigenwerte\2.txt', 'Omegaf', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\5_bsp_eigenwerte\3.txt', 'Omegar', '-ascii', '-double', '-tabs');

t = data{1,1}.t;
Y = [data{1,1}.Ytrain, data{1,1}.Ytest];
Yf = [data{1,1}.Yr, data{1,1}.Yp];
Yr = [data{1,3}.Yr, data{1,3}.Yp];

%% . Save as tikz
pgfplot(t,Y(1,:),'1',...
    t,Yf(1,:),'2',...
    t,Yr(1,:),'3','5_bsp_signalx1','C:\Users\bouaz\Desktop\Thesis\pics');
pgfplot(t,Y(2,:),'1',...
    t,Yf(2,:),'2',...
    t,Yr(2,:),'3','5_bsp_signalx2','C:\Users\bouaz\Desktop\Thesis\pics');
