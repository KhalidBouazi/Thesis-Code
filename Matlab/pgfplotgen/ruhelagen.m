%% Functions
f1 = @(x) atan(x-1);
f2 = @(x) 5*(x-1).*(x-1.5).*(x-0.5);
f3 = @(x) 0*x;
f4 = @(x) (x-1).^2 + 0.2;

%%
x = 0.2:0.01:1.8;
x31 = 0.5:0.01:1.5;
x32 = 0.2:0.01:0.5;
x33 = 1.5:0.01:1.8;
y1 = f1(x);
y2 = f2(x);
y31 = f3(x31);
y32 = f2(x32);
y33 = f2(x33);
y4 = f4(x);

%% Plot
subplot(2,2,1);
plot(x,y1);
grid on;
subplot(2,2,2);
plot(x,y2);
grid on;
subplot(2,2,3);
plot(x31,y31);
hold on;
plot(x32,y32);
plot(x33,y33);
grid on;
subplot(2,2,4);
plot(x,y4);
grid on;

%% Tikz
pgfplot(x,y1,'1',...
    '2_ruhelage_1','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');
pgfplot(x,y2,'1',...
    '2_ruhelage_2','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');
pgfplot(x31,y31,'1',...
    x32,y32,'2',...
    x33,y33,'3',...
    '2_ruhelage_3','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');
pgfplot(x,y4,'1',...
    '2_ruhelage_4','C:\Users\bouaz\Desktop\Thesis-Tex\texmf\tex\latex\tuddesign\report\Bilder');

