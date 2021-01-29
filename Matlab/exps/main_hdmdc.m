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
input.system = {'duffing'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% params : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.params = {[1,1,1]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x0 : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
input.x0 = {[3,1]};
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
input.input = {{struct('type','normd','amp',0.3)}};
%%%%%%%%%%%%%%%%%%%%%%%%

% dt : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.dt = {0.1};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% timesteps : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.timesteps = {500};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {100};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {60};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {300,350,400,450,500,600};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input delays: double: optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.uhasdelays = {0,1};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spacing : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [timespacing, delayspacing]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.spacing = {[1,1]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% measured : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.measured = {1,[1,2]};
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

