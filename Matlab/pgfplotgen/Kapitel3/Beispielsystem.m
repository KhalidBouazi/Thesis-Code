%% Load mat file
var = 'hdmdresult';
data = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel3\Beispielsystem.mat',var);
data = data.(var);

%% Data

%continuous Eigenvalues
omega = [-1; -0.2; -0.1];   % true eigenvalues
omegaf = data{1,1}.omega;   % false
omegar = data{1,2}.omega;   % right

Omega = [real(omega),imag(omega)];
Omegaf = [real(omegaf),imag(omegaf)];
Omegar = [real(omegar),imag(omegar)];

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\3_bsp_eigs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\3_bsp_eigs\1.txt', 'Omega', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\3_bsp_eigs\2.txt', 'Omegaf', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\3_bsp_eigs\3.txt', 'Omegar', '-ascii', '-double', '-tabs');

t = data{1,1}.t;
Y = [data{1,1}.Ytrain, data{1,1}.Ytest];
Yf = [data{1,1}.Yr, data{1,1}.Yp];
Yr = [data{1,2}.Yr, data{1,2}.Yp];

%% . Save as tikz
pgfplot(Y(1,:),Y(2,:),'1',...
    Yf(1,:),Yf(2,:),'2',...
    Yr(1,:),Yr(2,:),'3','3_bsp_signal','C:\Users\bouaz\Desktop\Thesis\pics');
