function algdata = runalg(algdata,config)

dispstep('alg',algdata.algorithm);
timer = tic;

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'delays','spacing','rank'};
optargvals = {0,[1,1],[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Choose and run algorithm
algorithm = algdata.algorithm;
fun = config.general.algorithms.(algorithm);
algdata = fun(algdata);

%% Stop timer
timeelapsed = toc(timer);
dispstep('time',timeelapsed);

end