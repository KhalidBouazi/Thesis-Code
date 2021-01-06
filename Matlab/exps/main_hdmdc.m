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

% input : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
% struct('type','none')
% struct('type','const','value',...)
% struct('type','sine','amp',...,'freq',...,'phi',...) 
% struct('type','chirp','amp',...,'freqa',...,'freqb',...) 
% freqb should be <= 1/20 * 1/dt
% struct('type','prbs','amp',...) 
% struct('type','normd','amp',...) 
%%%%%%%%%%%%%%%%%%%%%%%%
input.input = {{struct('type','normd','amp',0.5)}};
%%%%%%%%%%%%%%%%%%%%%%%%

% dt : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.dt = {0.1};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% timesteps : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.timesteps = {1000};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {1000};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {30};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950};
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
input.measured = {1};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% observables : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {'identity'}
% {'monomial', [minexp. maxexp.]}
% {'rbf', bandwidth}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.observables = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hdmdcinput = combineinputs(input,config);

%% IV. Run procedure
hdmdcresult = algprocedure(hdmdcinput,config);

