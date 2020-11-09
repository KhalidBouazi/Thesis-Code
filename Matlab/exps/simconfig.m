function config = simconfig()

%% Display Tool logo in command window
disp('                            #######################################');
disp('                            #                                     #');
disp('                            #     Koopman Identification Tool     #');
disp('                            #                                     #');
disp('                            #######################################');

%% Define mode of usage
config.general.usage = 'new'; % archive

%% Define path to access all functions
addpath(genpath('C:\Users\bouaz\Desktop\Thesis-Code\Matlab'));

%% Define ARCHIVE path for storing and loading data
config.general.archivepath = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\1_Daten\';
config.general.plotpath = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\2_Plots\';

%% Define FOLDERNAME acronyms
config.general.folderacr = struct('algorithm','alg','system','sys','params','p','x0','x0',...
    'dt','dt','timesteps','ts','rank','r','delays','d','spacing','sp','measured','m');

%% Define ALGORITHMS struct with function
config.general.algorithms = struct('DMD',@DMD,'HAVOK',@HAVOK,'HDMD',@HDMD,'TEST',@TEST);

%% Define SYSTEMS struct with acronym and function
config.general.systems = ...
    struct('lorenz',struct('acr','LR','fun',@lorenz),...
           'duffing',struct('acr','DF','fun',@duffing),...
           'roessler',struct('acr','RL','fun',@roessler),...
           'vanderpol',struct('acr','VDP','fun',@vanderpol),...
           'pendulum',struct('acr','PDL','fun',@pendulum),...
           'doubletank',struct('acr','DBLT','fun',@doubletank),...
           'trippletank',struct('acr','TRLT','fun',@trippletank));
                       
%% Define PLOTS struct with name and function
config.general.plots = ...
    struct('phase',struct('name','Phasenraum','fun',@phaseplot),...
           'disceig',struct('name','Diskr. Eigenwerte','fun',@disceigplot),...
           'conteig',struct('name','Kontin. Eigenwerte','fun',@conteigplot),...
           'sing',struct('name','Singulärwerte','fun',@singplot),...
           'delayphase',struct('name','Delay Phasenraum','fun',@delayphaseplot),...
           'phasebasis',struct('name','Phasenraum mit SVD Moden','fun',@phasebasisplot),...
           'reconstruct',struct('name','Rekonstruktion','fun',@reconstructplot),...
           'delayseries',struct('name','Delay Zeitsignal','fun',@delayseriesplot),...
           'delayreconstruct',struct('name','Delay Rekonstruktion','fun',@delayreconstructplot),...
           'matriximage',struct('name','Matrixbild','fun',@matriximage));
                     
%% Define general fieldnames
config.general.fieldnames.data = {'t','X','Y'};
config.general.fieldnames.svd = {'U','s','V'};
config.general.fieldnames.metadata = {'note','favorite','date','time'};

%% Define DMD struct
config.dmd.plots.main = {'phase','disceig','sing','conteig'};
config.dmd.plots.sec = {'reconstruct','phasebasis'};
config.dmd.fieldnames.input = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured','observexp'};
config.dmd.fieldnames.hankel = {'H','Hp'};
config.dmd.fieldnames.model = {'Atilde','W','d','Phi','omega','b','Y_','rmseY_','t_'};

config.dmd.fieldnames.order = [config.dmd.fieldnames.input,config.general.fieldnames.data,...
    config.dmd.fieldnames.hankel,config.general.fieldnames.svd,config.dmd.fieldnames.model,...
    config.general.fieldnames.metadata];

%% Define HAVOK struct
config.havok.plots.main = {'phase','delayphase','sing'};
config.havok.plots.sec = {'delayreconstruct','matriximage'};
config.havok.fieldnames.input = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured','observexp'};
config.havok.fieldnames.hankel = {'H'};
config.havok.fieldnames.model = {'A','B','V_','rmseV_'};

config.havok.fieldnames.order = [config.havok.fieldnames.input,config.general.fieldnames.data,...
    config.havok.fieldnames.hankel,config.general.fieldnames.svd,config.havok.fieldnames.model,...
    config.general.fieldnames.metadata];

%% Define HDMD struct
config.hdmd.plots.main = {'phase','delayphase','sing'};
config.hdmd.plots.sec = {'reconstruct','phasebasis'}; 
config.hdmd.fieldnames.input = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured','observexp'};
config.hdmd.fieldnames.hankel = {'H','Hp'};
config.hdmd.fieldnames.model = {'Atilde','W','d','Phi','omega','b','Y_','rmseY_','t_'};

config.hdmd.fieldnames.order = [config.hdmd.fieldnames.input,config.general.fieldnames.data,...
    config.hdmd.fieldnames.hankel,config.general.fieldnames.svd,config.hdmd.fieldnames.model,...
    config.general.fieldnames.metadata];

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


