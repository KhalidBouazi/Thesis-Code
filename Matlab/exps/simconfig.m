function config = simconfig()

%% Display Tool logo in command window
disp('#######################################');
disp('#                                     #');
disp('#     Koopman Identification Tool     #');
disp('#                                     #');
disp('#######################################');

%% Define mode of usage
config.general.usage = 'new'; % archive

%% Define path to access all functions
addpath(genpath('C:\Users\bouaz\Desktop\Thesis-Code\Matlab'));

%% Define ARCHIVE path for storing and loading data
config.general.archivepath = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\1_Daten\';
config.general.plotpathtikz = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\2_Plots\tikz\';
config.general.plotpathpng = 'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\2_Plots\png\';

%% Define FOLDERNAME acronyms
config.general.folderacr = struct('algorithm','alg','system','sys','params','p','x0','x0',...
    'dt','dt','timesteps','ts','horizon','hrz','rank','r','delays','d','spacing','sp','measured','m','observables','obs');

%% Define ALGORITHMS struct with function
config.general.algorithms = struct('DMD',@DMD,'DMDc',@DMDc,'HDMD',@HDMD,'HDMDc',@HDMDc,'HAVOK',@HAVOK,'CONVCOORD',@CONVCOORD);

%% Define SYSTEMS struct with acronym and function
config.general.systems = ...
    struct('lorenz',struct('acr','LR','fun',@lorenz),...
           'duffing',struct('acr','DF','fun',@duffing),...
           'roessler',struct('acr','RL','fun',@roessler),...
           'vanderpol',struct('acr','VDP','fun',@vanderpol),...
           'pendulum',struct('acr','PDL','fun',@pendulum),...
           'doubletank',struct('acr','DBLT','fun',@doubletank),...
           'trippletank',struct('acr','TRLT','fun',@trippletank),...
           'eindampfanlage',struct('acr','EDMPF','fun',@eindampfanlage),...
           'linsys',struct('acr','LIN','fun',@linsys));
                       
%% Define PLOTS struct with name and function
config.general.plots = ...
    struct('phaseY',struct('name','Phasenraum','fun',@phaseplot,'args',{{'X','x'}},'loc','main'),...
           'phaseV',struct('name','Delay Phasenraum','fun',@phaseplot,'args',{{'V_','v'}},'loc','main'),...
           'disceig',struct('name','Diskr. Eigenwerte','fun',@disceigplot,'args',{{'d'}},'loc','main'),...
           'conteig',struct('name','Kontin. Eigenwerte','fun',@conteigplot,'args',{{'omega'}},'loc','main'),...
           'sing',struct('name','Singulärwerte','fun',@singplot,'args',{{'sn','sn_'}},'loc','main'),...
           'phasebasisY',struct('name','Phasenraum mit SVD Moden','fun',@phasebasisplot,'args',{{'X','V_'}},'loc','sec'),...
           'reconstructY',struct('name','Rekonstruktion','fun',@reconstructplot,'args',{{'Ytrain','Yr','RMSEYr','Ytest','Yp','RMSEYp','x'}},'loc','sec'),...
           'reconstructV',struct('name','Delay Rekonstruktion','fun',@reconstructplot,'args',{{'Vtrain','Vr','RMSEVr','Vtest','Vp','RMSEVp','v'}},'loc','sec'),...
           'reconstructW',struct('name','Conv. Rekonstruktion','fun',@reconstructplot,'args',{{'Wtrain','Wr','RMSEWr','Wtest','Wp','RMSEWp','w'}},'loc','sec'),...
           'rmseY',struct('name','rmse','fun',@rmseplot,'args',{{'rmseY'}},'loc','sec'),...
           'rmseV',struct('name','Delay rmse','fun',@rmseplot,'args',{{'rmseV'}},'loc','sec'),...
           'rmseW',struct('name','Conv. rmse','fun',@rmseplot,'args',{{'rmseW'}},'loc','sec'),...
           'matrix',struct('name','Koopmanoperator','fun',@matrixplot,'args',{{'A'}},'loc','sec'));
                     
%% Define general fieldnames
config.general.fieldnames.data = {'t','X','Y','Yn'};
config.general.fieldnames.svd = {'U_','s_','sn','sn_','V_'};
config.general.fieldnames.metadata = {'note','favorite','date','time'};

%% Define DMD struct
config.dmd.plots = {'phaseY','disceig','sing','conteig','reconstructY','rmseY','phasebasisY'};
config.dmd.fieldnames.input = {'algorithm','system','params','x0',...
    'dt','timesteps','horizon','rank','delays','spacing','measured','observables'};
config.dmd.fieldnames.hankel = {'H','Hp'};
config.dmd.fieldnames.model = {'Atilde','W','d','Phi','omega','b',...
    'Ytrain','Yr','tr','RMSEYr','rmseYr','Ytest','Yp','tp','RMSEYp','rmseYp',...
    'RMSEY','rmseY'};

config.dmd.fieldnames.order = [config.dmd.fieldnames.input,config.general.fieldnames.data,...
    config.dmd.fieldnames.hankel,config.general.fieldnames.svd,config.dmd.fieldnames.model,...
    config.general.fieldnames.metadata];

%% Define DMDc struct % TODO
config.dmdc.plots = {'phaseY','disceig','sing','conteig','reconstructY','rmseY','phasebasisY'};
config.dmdc.fieldnames.input = {'algorithm','system','params','x0','input',...
    'dt','timesteps','horizon','rank','delays','spacing','measured','observables'};
config.dmdc.fieldnames.data = {'U'};
config.dmdc.fieldnames.hankel = {'Hx','Hxp','H_'};
config.dmdc.fieldnames.model = {'Atilde','Btilde','W','d','Phi','omega','b',...
    'Ytrain','Yr','tr','RMSEYr','rmseYr','Ytest','Yp','tp','RMSEYp','rmseYp',...
    'RMSEY','rmseY'};

config.dmdc.fieldnames.order = [config.dmdc.fieldnames.input,config.general.fieldnames.data,...
    config.dmdc.fieldnames.data,config.dmdc.fieldnames.hankel,config.general.fieldnames.svd,...
    config.dmdc.fieldnames.model,config.general.fieldnames.metadata];

%% Define HDMD struct
config.hdmd.plots = {'phaseY','disceig','sing','conteig','reconstructY','rmseY','phasebasisY'};
config.hdmd.fieldnames.input = {'algorithm','system','params','x0',...
    'dt','timesteps','horizon','rank','delays','spacing','measured','observables'};
config.hdmd.fieldnames.hankel = {'H','Hp'};
config.hdmd.fieldnames.model = {'Atilde','W','d','Phi','omega','b',...
    'Ytrain','Yr','tr','RMSEYr','rmseYr','Ytest','Yp','tp','RMSEYp','rmseYp',...
    'RMSEY','rmseY'};

config.hdmd.fieldnames.order = [config.hdmd.fieldnames.input,config.general.fieldnames.data,...
    config.hdmd.fieldnames.hankel,config.general.fieldnames.svd,config.hdmd.fieldnames.model,...
    config.general.fieldnames.metadata];

%% Define HDMDc struct % TODO
config.hdmdc.plots = {'phaseY','disceig','sing','conteig','reconstructY','rmseY','phasebasisY'};
config.hdmdc.fieldnames.input = {'algorithm','system','params','x0','input',...
    'dt','timesteps','horizon','rank','delays','spacing','measured','observables'};
config.hdmdc.fieldnames.data = {'U'};
config.hdmdc.fieldnames.hankel = {'Hx','Hxp','H_'};
config.hdmdc.fieldnames.model = {'Atilde','Btilde','W','d','Phi','omega','b',...
    'Ytrain','Yr','tr','RMSEYr','rmseYr','Ytest','Yp','tp','RMSEYp','rmseYp',...
    'RMSEY','rmseY'};

config.hdmdc.fieldnames.order = [config.hdmdc.fieldnames.input,config.general.fieldnames.data,...
    config.hdmdc.fieldnames.data,config.hdmdc.fieldnames.hankel,config.general.fieldnames.svd,...
    config.hdmdc.fieldnames.model,config.general.fieldnames.metadata];

%% Define HAVOK struct
config.havok.plots = {'phaseY','phaseV','sing','reconstructV','rmseV','matrix'};
config.havok.fieldnames.input = {'algorithm','system','params','x0',...
    'dt','timesteps','horizon','rank','delays','spacing','measured','observables'};
config.havok.fieldnames.hankel = {'H'};
config.havok.fieldnames.model = {'A','B','Vtrain','Vr','tr','RMSEVr','rmseVr','Vtest','Vp','tp','RMSEVp','rmseVp',...
    'RMSEV','rmseV'};

config.havok.fieldnames.order = [config.havok.fieldnames.input,config.general.fieldnames.data,...
    config.havok.fieldnames.hankel,config.general.fieldnames.svd,config.havok.fieldnames.model,...
    config.general.fieldnames.metadata];

%% Define CONVCOORD struct
config.convcoord.plots = {'phaseY','phaseV','sing','reconstructW','rmseW','matrix'};
config.convcoord.fieldnames.input = {'algorithm','system','params','x0',...
    'dt','timesteps','horizon','rank','delays','spacing','measured','observables'};
config.convcoord.fieldnames.hankel = {'H'};
config.convcoord.fieldnames.model = {'A','Wtrain','Wr','tr','RMSEWr','rmseWr','Wtest','Wp','tp','RMSEWp','rmseWp','RMSEW','rmseW'};

config.convcoord.fieldnames.order = [config.convcoord.fieldnames.input,config.general.fieldnames.data,...
    config.convcoord.fieldnames.hankel,config.general.fieldnames.svd,config.convcoord.fieldnames.model,...
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


