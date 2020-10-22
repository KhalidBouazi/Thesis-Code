function algdata = evalalg(algdata,config)
 
%% Define algorithm
algorithm = algdata.algorithm;

%% Extract plots for algorithm
if any(strcmp(config.algorithms,algorithm))
    evals = config.([lower(algorithm) 'evals']);
else
    error(['Evaluation: No algorithm ' algorithm ' available.']); 
end

%% Compute evaluation data
for j = 1:length(evals)
    evalname = evals{j}{1};
    evalvar = evals{j}{2};
    if isfield(config.evalfuns,evalname)
        fun = config.evalfuns.(evalname);
        algdata.(evalvar) = fun(algdata);
    else
        error(['Evaluation: No evaluation ' evalname ' available.']);
    end
end

end