%% I. First close all windows and clear workspace
close all;
clear input;
 
%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set HDMDc parameters

% algorithm : string : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.algorithm = {'HDMDc'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% system : char : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vanderpol, duffing, 
% trippletank, doubletank
% massoscillator,
% evaporationplant
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

% noise : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% struct('type','none')
% struct('type','normd','amp',...) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.noise = {{struct('type','none')}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
% struct('type','none')
% struct('type','const','value',...)
% struct('type','sine','amp',...,'freq',...,'phi',...) 
% struct('type','chirp','amp',...,'freqa',...,'freqb',...) 
% freqb should be <= 1/20 * 1/dt
% struct('type','prbs','amp',...) 
% struct('type','normd','amp',...) 
% struct('type','normdc','umin',...,'umax',...) 
%%%%%%%%%%%%%%%%%%%%%%%%
input.input = {{struct('type','normd','amp',1)}};
%%%%%%%%%%%%%%%%%%%%%%%%

% dt : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.dt = {0.1};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% timesteps : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.timesteps = {100};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pathtotraindata : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.pathtotraindata = {'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel5\VanderPol.mat'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {100};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pathtovaliddata : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.pathtovaliddata = {'C:\Users\bouaz\Desktop\Thesis-Tex\Inhalt\2_Ergebnisse\_Resultate\Kapitel5\VanderPol.mat'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {1,10,11,12,13,14,15,16,17,18,19,20};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {80};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input delays: double: optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.uhasdelays = {1};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spacing : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [timespacing, delayspacing]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.spacing = {[1,1]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% measured : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.measured = {1,2,[1,2]};%,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% observables : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {'identity'}
% {'monomial', [minexp. maxexp.]}
% {'rbf', bandwidth}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.observables = {{'monomial',[1 3]}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hdmdcinput = combineinputs(input,config);

%% IV. Run procedure
hdmdcresult = algprocedure(hdmdcinput,config);

