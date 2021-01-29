%% Load mat file
var = 'hdmdresult';
data = load('C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel4\Duffing_Periodisch.mat',var);
data = data.(var);

%% Data
for i = 1:length(data)/3
    delays(i) = data{1,3*i-2}.delays;
end

for i = 1:length(data)/3
    Y1r{i} = data{1,3*i-2}.RMSEYr;
    Y1p{i} = data{1,3*i-2}.RMSEYp;
    Y1rank{i} = data{1,3*i-2}.rank;
    Y2r{i} = data{1,3*i-1}.RMSEYr;
    Y2p{i} = data{1,3*i-1}.RMSEYp;
    Y2rank{i} = data{1,3*i-1}.rank;
    Y3r1{i} = data{1,3*i}.RMSEYr(1);
    Y3p1{i} = data{1,3*i}.RMSEYp(1);
    Y3r2{i} = data{1,3*i}.RMSEYr(2);
    Y3p2{i} = data{1,3*i}.RMSEYp(2);
    Y3rank{i} = data{1,3*i}.rank;
end

table1_1 = [delays(:)'; Y1r{:}]';
table1_2 = [delays(:)'; Y1p{:}]';
table1_3 = [delays(:)'; Y1rank{:}]';

table2_1 = [delays(:)'; Y2r{:}]';
table2_2 = [delays(:)'; Y2p{:}]';
table2_3 = [delays(:)'; Y2rank{:}]';

table3_1 = [delays(:)'; Y3r1{:}]';
table3_2 = [delays(:)'; Y3p1{:}]';
table3_3 = [delays(:)'; Y3r2{:}]';
table3_4 = [delays(:)'; Y3p2{:}]';
table3_5 = [delays(:)'; Y3rank{:}]';

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x1');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x1\rekfehler.txt', 'table1_1', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x1\prdfehler.txt', 'table1_2', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x1\rang.txt', 'table1_3', '-ascii', '-double', '-tabs');

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x2');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x2\rekfehler.txt', 'table2_1', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x2\prdfehler.txt', 'table2_2', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x2\rang.txt', 'table2_3', '-ascii', '-double', '-tabs');

mkdir('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x\rekfehler1.txt', 'table3_1', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x\prdfehler1.txt', 'table3_2', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x\rekfehler2.txt', 'table3_3', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x\prdfehler2.txt', 'table3_4', '-ascii', '-double', '-tabs');
save('C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\4_duffing_fehlerundrang_x\rang.txt', 'table3_5', '-ascii', '-double', '-tabs');
