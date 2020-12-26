function algdata = algprocedure(algdata,config)

% I. Simulate systems
algdata = simallsys(algdata,config);

m = length(algdata);
for i = 1:m
    
    dispstep('startalg',[i m]);
    
    % II. Do measurement
    algdata{i} = measure(algdata{i});
    
    % III. Compute algorithm
    algdata{i} = runalg(algdata{i},config);
    
    dispstep('endalg',[i m]);
    
end

% IV. Plot results in one figure
plotalg(algdata,config);

end
