function evalarchivedata(table,label,config)

%% Extract chosen data from table
data = choosedata(table,label);

%% Plot data
if ~isempty(data)
    plotalg(data,config);
end

end