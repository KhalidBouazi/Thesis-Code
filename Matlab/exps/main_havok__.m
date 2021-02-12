%% I. First close all windows and clear workspace
close all;
clear input;

%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set HAVOK__ parameters

% algorithm : string : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.algorithm = {'HAVOK__'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% system : char : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lorenz, vanderpol, duffing, 
% pendulum, trippletank,
% roessler, doubletank
% eindampfanlage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.system = {'lorenz'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% params : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.x0 = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% x0 : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%
input.params = {};
%%%%%%%%%%%%%%%%%%%%%%%%

% dt : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.dt = {0.001};
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
input.timesteps = {20000};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {15};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {100};
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

havok__input = combineinputs(input,config);

%% IV. Run procedure
havok__result = algprocedure(havok__input,config);

