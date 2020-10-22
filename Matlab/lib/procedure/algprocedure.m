function algprocedure(algdata,config)

for i = 1:length(algdata)
    
    dispalgnr(i);
    
    %% I. Simulate system
    algdata{i} = simsys(algdata{i},config);
    
    %% II. Compute algorithm
    algdata{i} = runalg(algdata{i});
    
    %% III. Evaluation
    algdata{i} = evalalg(algdata{i},config);
    
end

%% V. Plot results in one figure
plotalg(algdata,config);

end
