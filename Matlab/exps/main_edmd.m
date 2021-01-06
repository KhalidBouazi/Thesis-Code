%% I. First close all windows and clear workspace
close all;
clear input;

%% II. Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();

%% III. Set EDMD parameters

% algorithm : string : obligatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.algorithm = {'EDMD'};
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
input.delays = {5};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spacing : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [timespacing, delayspacing]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.spacing = {[1,1]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% measured : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.measured = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% observables : double : optional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {'identity'}
% {'monomial', max. exponent}
% {'rbf', bandwidth}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input.observables = {{'monomial',[1 2]}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edmdinput = combineinputs(input,config);

%% IV. Run procedure
edmdresult = algprocedure(edmdinput,config);

