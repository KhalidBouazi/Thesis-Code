function config = simconfig()

%% Display algorithm start in command window
disp('                            #######################################');
disp('                            #                                     #');
disp('                            #     Koopman Identification Tool     #');
disp('                            #                                     #');
disp('                            #        Algorithm started now        #');
disp('                            #                                     #');
disp('                            #######################################');

%% Add path to access all functions
addpath(genpath('C:\Users\bouaz\Desktop\Thesis-Code\Matlab'));

%% Set archive path
config.archivepath = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\1_Daten\';

%% Set latex as plot interpreter
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% General plot config
set(groot,'defaultAxesGridLineStyle','--');
set(groot,'defaultAxesGridAlpha',0.2);
set(groot,'defaultAxesGridColor',[0.1 0.1 0.1]);
set(groot,'defaultAxesFontSize',14);
set(groot,'defaultLineLineWidth',1);


