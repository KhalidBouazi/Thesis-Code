%% I. First close all windows and clear workspace
close all;
clear input;

%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set kDMDc parameters

% algorithm : string : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.algorithm = {'kDMDc'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% system : char : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lorenz, vanderpol, duffing, 
% pendulum, trippletank,
% roessler, doubletank
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
%%%%%%%%%%%%%%%%%%%%%%%%
input.input = {{struct('type','normd','amp',1)}};
%%%%%%%%%%%%%%%%%%%%%%%%

% dt : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.dt = {0.1};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% timesteps : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.timesteps = {300};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% horizon : double : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.horizon = {300};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rank : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%
input.rank = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%

% delays : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.delays = {15};
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

% kernel : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {'identity'}
% {'polynomial', exponent}
% {'rbf', bandwidth}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.kernel = {{'identity'},{'polynomial',3}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kdmdcinput = combineinputs(input,config);

%% IV. Run procedure
kdmdcresult = algprocedure(kdmdcinput,config);

