function celldata = choosedata(table,label)

data = table.Data;
celldata = {};
choice = [];

%% Extract choice and data
if ~isempty(data)
    for i = 1:size(data,1)
        if data{i,1}
            choice = [choice, i];
        end
    end
    if isempty(choice)        
        label.Text = 'Keine Daten gewählt.';
    end
else
    label.Text = 'Keine Daten geladen.';
end

%% Extract chosen data from datastruct
if evalin('base','exist(''datastruct'',''var'') == 1')
    datastruct = evalin('base','datastruct');
    data = datastruct(choice);
    assignin('base','datastruct',datastruct);
end

%% Convert structarray to cellarray with structs
for i = 1:length(data)
    celldata{i} = data(i);
end

end