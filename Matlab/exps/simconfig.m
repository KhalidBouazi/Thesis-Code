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
config.algorithms = {'DMD','HAVOK','HDMD','TEST'};

%% Define algorithm functions struct
config.algorithmfuns = struct('DMD',@DMD,'HAVOK',@HAVOK,'HDMD',@HDMD,'TEST',@TEST);

%% Define system functions struct
config.systemfuns = struct('lorenz',@lorenz,'duffing',@duffing,'roessler',@roessler,...
    'vanderpol',@vanderpol,'pendulum',@pendulum,'doubletank',@doubletank,...
    'trippletank',@trippletank);

%% Define systemname acronym struct
config.systemacr = struct('lorenz','LR','duffing','DF','roessler','RL',...
    'vanderpol','VDP','pendulum','PNDL','doubletank','DBLT',...
    'trippletank','TRLT');
                       
%% Define plot functions struct
config.plotfuns = struct('phase',@phaseplot,'disceig',@disceigplot,...
    'conteig',@conteigplot,'sing',@singplot,'delayphase',@delayphaseplot,...
    'phasebasis',@phasebasisplot,'reconstruct',@reconstructplot,...
    'delayseries',@delayseriesplot,'delayreconstruct',@delayreconstructplot);
config.mainplotfuns = struct('phase',@phaseplot,'disceig',@disceigplot,...
    'conteig',@conteigplot,'sing',@singplot,'delayphase',@delayphaseplot);
config.secplotfuns = struct('phasebasis',@phasebasisplot,...
    'reconstruct',@reconstructplot,'delayseries',@delayseriesplot,...
    'sing',@singplot,'delayreconstruct',@delayreconstructplot);
                     
%% Define plot names
config.plotnames = struct('phase','Phasenraum','phasebasis','Phasenraum mit ...',...
    'disceig','Diskr. Eigenwerte','conteig','Kontin. Eigenwerte',...
    'sing','Singulärwerte','delayphase','Delay Phasenraum','reconstruct','Rekonstruktion',...
    'delayseries','Delay Zeitsignal','delayreconstruct','Delay Rekonstruktion');
                     
%% Define evaluation functions struct
config.evalfuns = struct('reconstruct',@reconstruct,'rmse',@rmse);
           
%% Define plot function names for algorithms
config.maindmdplots = {'phase','disceig','sing','conteig'};
config.secdmdplots = {'reconstruct','phasebasis'};

config.mainhavokplots = {'phase','delayphase','sing'};
config.sechavokplots = {'delayseries','delayreconstruct'};

config.hdmdplots = {'phase','disceig','sing','conteig'};

config.maintestplots = {'phase','delayphase','sing'};
config.sectestplots = {'delayphase','delayreconstruct'};

%% Define evaluation function names for algorithms
config.dmdevals = {{'reconstruct','Y_'},{'rmse','rmseY_'}}; %% Order !!!
config.havokevals = {};
config.hdmdevals = {{'reconstruct','Y_'},{'rmse','rmseY_'}};
config.testevals = {};

%% Define algorithm input fieldnames
config.dmdinput = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured'};
config.havokinput = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured'};
config.hdmdinput = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured'};
config.testinput = {'algorithm','system','params','x0','dt','timesteps','rank','delays','spacing','measured'};

%% Define general fieldnames
config.datafieldnames = {'t','X','Y'};
config.svdfieldnames = {'U','s','V'};
config.metadatafieldnames = {'note','favorite','date','time'};

%% Define DMD fieldname order
config.dmdhankfieldnames = {'H','Hp'};
config.dmdevalfieldnames = {'Y_','rmseY_'};
config.dmdmodefieldnames = {'Atilde','W','d','Phi','omega','b'};
config.dmdorder = [config.dmdinput,config.datafieldnames,config.dmdhankfieldnames,...
    config.svdfieldnames,config.dmdevalfieldnames,config.dmdmodefieldnames,...
    config.metadatafieldnames];

%% Define HAVOK fieldname order
config.havokhankfieldnames = {'H'};
config.havokmodelfieldnames = {'A','B','V_'};
config.havokorder = [config.havokinput,config.datafieldnames,config.havokhankfieldnames,...
    config.svdfieldnames,config.havokmodelfieldnames,config.metadatafieldnames];

%% Define HDMD fieldname order
config.hdmdhankfieldnames = {'H','Hp'};
config.hdmdevalfieldnames = {'Y_','rmseY_'};
config.hdmdmodefieldnames = {'Atilde','W','d','Phi','omega','b'};
config.hdmdorder = [config.hdmdinput,config.datafieldnames,config.hdmdhankfieldnames,...
    config.svdfieldnames,config.hdmdevalfieldnames,config.hdmdmodefieldnames,...
    config.metadatafieldnames];

%% Define TEST fieldname order
config.testhankfieldnames = {'H'};
config.testmodelfieldnames = {'A','B'};
config.testorder = [config.testinput,config.datafieldnames,config.testhankfieldnames,...
    config.svdfieldnames,config.testmodelfieldnames,config.metadatafieldnames];

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


