%% Load mat file
var = 'hdmdresult';
data = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel4\Duffing_Periodisch.mat',var);
data = data.(var);

%% Data

Omega1 = {};
Omega2 = {};
Omega3 = {};
for i = 1:length(data)/3
    d = data{1,3*i-2}.delays;
    if d == 20 || d == 40 || d == 60
        Omega1{end+1} = data{1,3*i-2}.omega;
        Omega2{end+1} = data{1,3*i-1}.omega;
        Omega3{end+1} = data{1,3*i}.omega;
    end
end

table1_1 = [real(Omega1{1}) imag(Omega1{1})];
table1_2 = [real(Omega1{2}) imag(Omega1{2})];
table1_3 = [real(Omega1{3}) imag(Omega1{3})];

table2_1 = [real(Omega2{1}) imag(Omega2{1})];
table2_2 = [real(Omega2{2}) imag(Omega2{2})];
table2_3 = [real(Omega2{3}) imag(Omega2{3})];

table3_1 = [real(Omega3{1}) imag(Omega3{1})];
table3_2 = [real(Omega3{2}) imag(Omega3{2})];
table3_3 = [real(Omega3{3}) imag(Omega3{3})];

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x1');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x1\1.txt', 'table1_1', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x1\2.txt', 'table1_2', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x1\3.txt', 'table1_3', '-ascii', '-double', '-tabs');

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x2');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x2\1.txt', 'table2_1', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x2\2.txt', 'table2_2', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x2\3.txt', 'table2_3', '-ascii', '-double', '-tabs');

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x\1.txt', 'table3_1', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x\2.txt', 'table3_2', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_eigenwerte_x\3.txt', 'table3_3', '-ascii', '-double', '-tabs');
