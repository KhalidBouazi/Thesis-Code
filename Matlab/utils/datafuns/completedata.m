function data = completedata(data,algfieldnames)

m = size(data,1);

%% Define functions to fill specific data fields  with computed data
date = datetime('now','TimeZone','local','Format','d-MMM-y');
time = datetime('now','TimeZone','local','Format','HH:mm:ss');
placeholders = struct('rmseY_',{{@rmse,'Y','Y_'}},'note',[],'favorite',0,'date',date,'time',time);

%% Add missing fields and fill with value or NaN
for i = 1:length(algfieldnames)
    if ~isfield(data,algfieldnames{i})
        for j = 1:m
            if isfield(placeholders,algfieldnames{i})
                placeholder = placeholders.(algfieldnames{i});
                if iscell(placeholder)
                    fun = placeholder{1};
                    inputfields = {placeholder{2:end}};
                    inputdata = cellbyfields(data(j,:),inputfields);
                    placeholder = fun(inputdata{:});
                end
                data(j,:).(algfieldnames{i}) = placeholder;
            else
                data(j,:).(algfieldnames{i}) = NaN;
            end
        end
    end
end

end