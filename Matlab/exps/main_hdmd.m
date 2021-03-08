%% I. First close all windows and clear workspace
close all;
clear input;

%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set HDMD parameters

% algorithm : string : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.algorithm = {'HDMD'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% system : char : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lorenz, vanderpol, duffing, 
% pendulum, trippletank,
% roessler, doubletank
% examplesys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.system = {'vanderpol'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% params : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.params = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x0 : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
input.x0 = {};
%%%%%%%%%%%%%%%%%%%%%%%%

% nx0 : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
input.nx0 = {10};
%%%%%%%%%%%%%%%%%%%%%%%%

% nx0v : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
input.nx0v = {10};
%%%%%%%%%%%%%%%%%%%%%%%%

% dt : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.dt = {0.1};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% noise : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% struct('type','none')
% struct('type','normd','amp',...) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.noise = {{struct('type','none')}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% timesteps : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.timesteps = {100};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pathtotraindata : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.pathtotraindata = {'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel4\HDMD\VanderPol.mat'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {100};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pathtovaliddata : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.pathtovaliddata = {'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel4\HDMD\VanderPol.mat'}; %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {1,20,40,80,120,160,200,250,300,450};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spacing : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [timespacing, delayspacing]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.spacing = {[1,1]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% measured : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.measured = {1};%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% observables : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {'identity'}
% {'monomial', max. exponent}
% {'rbf', bandwidth}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.observables = {{'monomial',[1]},{'monomial',[1 2]},{'monomial',[1 3]},{'monomial',[1 2 3]}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hdmdinput = combineinputs(input,config);

%% IV. Run procedure
hdmdresult = algprocedure(hdmdinput,config);

