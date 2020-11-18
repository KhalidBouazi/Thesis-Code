function algdata = algprocedure(algdata,config)

for i = 1:length(algdata)
    
    dispstep('algnum',i);
    t = tic;
    
    % I. Simulate system
    algdata{i} = simsys(algdata{i},config);
    
    % II. Transform through dictionary
    algdata{i} = observe(algdata{i});
    
    % III. Compute algorithm
    algdata{i} = runalg(algdata{i},config);
    
    timeelapsed = toc(t);
    dispstep('time',timeelapsed);
    
end

% IV. Plot results in one figure
plotalg(algdata,config);

end
