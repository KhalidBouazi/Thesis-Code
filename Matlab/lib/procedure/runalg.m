function algdata = runalg(algdata,config)

%% Check obligatory and optional function arguments
oblgfunargs = {'algorithm'};
optfunargs = {};
optargvals = {};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

dispstep('alg',algdata.algorithm);

%% Choose and run algorithm
algorithm = algdata.algorithm;
fun = config.general.algorithms.(algorithm);
algdata = fun(algdata);

end