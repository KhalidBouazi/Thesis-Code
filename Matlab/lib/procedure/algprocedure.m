function algdata = algprocedure(algdata,config)

% I. Simulate systems
algdata = simallsys(algdata,config);

for i = 1:length(algdata)
    
    dispstep('startalg',i);
    
    % II. Do measurement
    algdata{i} = measure(algdata{i});

    % III. Norm data
    algdata{i} = normdata(algdata{i});

    % IV. Transform through dictionary
    algdata{i} = observe(algdata{i});
    
    % V. Compute algorithm
    algdata{i} = runalg(algdata{i},config);
    
    dispstep('endalg',i);
    
end

% VI. Plot results in one figure
plotalg(algdata,config);

end
