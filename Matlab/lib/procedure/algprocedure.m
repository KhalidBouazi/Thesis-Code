function algprocedure(algdata,config)

for i = 1:length(algdata)
    
    dispstep('algnum',i);
    
    t = tic;
    
    % I. Simulate system
    algdata{i} = simsys(algdata{i},config);
%     algdata{i}.Y = polyobserv(algdata{i}.Y,1);
    
    % II. Compute algorithm
    algdata{i} = runalg(algdata{i},config);
    
    % III. Evaluation
    algdata{i} = evalalg(algdata{i},config);
    
    timeelapsed = toc(t);
    
    dispstep('time',timeelapsed);
    
end

% IV. Plot results in one figure
plotalg(algdata,config);

end
