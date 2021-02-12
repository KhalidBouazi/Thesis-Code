%% I. First close all windows and clear workspace
close all;
clear input;

%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set HAVOK_ parameters

% algorithm : string : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.algorithm = {'HAVOK_'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% system : char : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lorenz, vanderpol, duffing, 
% pendulum, trippletank,
% roessler, doubletank
% eindampfanlage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.system = {'vanderpol'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% params : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.x0 = {[1,0],[3,2]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x0 : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
input.params = {};
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
input.timesteps = {200};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {100};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {6,8,10,12,14};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {1000};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% {'monomial', max. exponent}
% {'rbf', bandwidth}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.observables = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

havok_input = combineinputs(input,config);

%% IV. Run procedure
havok_result = algprocedure(havok_input,config);

