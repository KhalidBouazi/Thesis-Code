function algdata = algprocedure(algdata,config)

for i = 1:length(algdata)
    
    dispstep('algnum',i);
    
    % I. Simulate system
    algdata{i} = simsys(algdata{i},config);
    
    % II. Transform through dictionary
    algdata{i} = observe(algdata{i});
    
    % III. Compute algorithm
    algdata{i} = runalg(algdata{i},config);
    
    dispstep('end',i);
    
end

% IV. Plot results in one figure
plotalg(algdata,config);

end
