function algdata = runalg(algdata,config)

dispstep('alg',algdata.algorithm);
timer = tic;

%% Choose and run algorithm
algorithm = algdata.algorithm;
fun = config.general.algorithms.(algorithm);
algdata = fun(algdata);

%% Stop timer
timeelapsed = toc(timer);
dispstep('time',timeelapsed);

end