function data = updatedata(data,result)

datafieldnames = fieldnames(data);
algfieldnames = fieldnames(result);

%% Remove unnecessary data fields
for i = 1:length(datafieldnames)
    if ~isfield(result,datafieldnames{i})
        data = rmfield(data,datafieldnames{i});
    end
end

%% Add missing fields and fill with value or NaN
data = completedata(data,algfieldnames);

%% Order data fields
data = orderfields(data,algfieldnames);

%% Stack data and result
data = [data;result];

end