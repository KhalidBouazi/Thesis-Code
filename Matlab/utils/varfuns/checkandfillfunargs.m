function algstruct = checkandfillfunargs(algstruct,oblgfunargs,optfunargs,optargvals)

%% Define obligatory function arguments and check if they exist
checkoblfunargs(algstruct,oblgfunargs);

%% Define optional function arguments and fill with default if they don't exist
algstruct = filloptfunargs(algstruct,optfunargs,optargvals);

end