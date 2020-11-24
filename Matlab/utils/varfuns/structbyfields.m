function datastruct = structbyfields(data,fields)

for i = 1:length(data)
    for j = 1:length(fields)
        if isfield(data(i),fields{j})
            datastruct(i).(fields{j}) = data(i).(fields{j});
        end
    end
end

end