function config = simconfig()

%% Display Tool logo in command window
disp('                            #######################################');
disp('                            #                                     #');
disp('                            #     Koopman Identification Tool     #');
disp('                            #                                     #');
disp('                            #######################################');

%% Define mode of usage
config.usage = 'new'; % archive

%% Define path to access all functions
addpath(genpath('C:\Users\bouaz\Desktop\Thesis-Code\Matlab'));

%% Define archive path for storing and loading data
config.archivepath = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\1_Daten\';
config.plotpath = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\2_Plots\';

%% Define foldername acronyms
config.folderacr = struct('algorithm','alg','system','sys','params','p','x0','x0',...
    'dt','dt','timesteps','ts','rank','r','delays','d','spacing','sp','measured','m');

%% Define algorithm names
config.algorithms = {'DMD','HAVOK'};

%% Define system functions struct
config.systemfuns = struct('lorenz',@lorenz,'duffing',@duffing,'roessler',@roessler,...
    'vanderpol',@vanderpol,'pendulum',@pendulum,'doubletank',@doubletank,...
    'trippletank',@trippletank);

%% Define systemname acronym struct
config.systemacr = struct('lorenz','LR','duffing','DF','roessler','RL',...
    'vanderpol','VDP','pendulum','PNDL','doubletank','DBLT',...
    'trippletank','TRLT');
                       
%% Define plot functions struct
config.plotfuns = struct('phase',@phaseplot,'phasebasis',@phasebasisplot,...
    'disceig',@disceigplot,'conteig',@conteigplot,'sing',@singplot,...
    'delayphase',@delayphaseplot,'reconstruct',@reconstructplot);
                     
%% Define plot names
config.plotnames = struct('phase','Phasenraum','phasebasis','Phasenraum mit ...',...
    'disceig','Diskrete Eigenwerte','conteig','Kontinuierliche Eigenwerte',...
    'sing','Singulärwerte','delayphase','Delay Phasenraum','reconstruct','Rekonstruktion');
                     
%% Define evaluation functions struct
config.evalfuns = struct('reconstruct',@reconstruct,'rmse',@rmse);
           
%% Define plot function names for algorithms
config.dmdplots = {'phase','disceig','sing'};%'phasebasis','reconstruct'};
config.havokplots = {'delayphase','sing'};

%% Define evaluation function names for algorithms
config.dmdevals = {{'reconstruct','Y_'},{'rmse','rmseY_'}}; %% Order !!!
config.havokevals = {};

%% Define algorithm input fieldnames
config.dmdinput = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured'};
config.havokinput = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured'};

%% Define general fieldnames
config.datafieldnames = {'t','X','Y'};
config.svdfieldnames = {'H','U','s','V'};
config.metadatafieldnames = {'note','favorite','date','time'};

%% Define DMD fieldname order
config.dmdevalfieldnames = {'Y_','rmseY_'};
config.dmdmodefieldnames = {'Atilde','W','d','Phi','omega','b'};
config.dmdorder = [config.dmdinput,config.datafieldnames,config.svdfieldnames,...
    config.dmdevalfieldnames,config.dmdmodefieldnames,config.metadatafieldnames];

%% Define HAVOK fieldname order
config.havokorder = [config.havokinput,config.datafieldnames,config.svdfieldnames,...
    config.metadatafieldnames];

%% Set latex as plot interpreter
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Set general plot config
set(groot,'defaultAxesGridLineStyle','--');
set(groot,'defaultAxesGridAlpha',0.2);
set(groot,'defaultAxesGridColor',[0.1 0.1 0.1]);
set(groot,'defaultAxesFontSize',14);
set(groot,'defaultLineLineWidth',1);

end


