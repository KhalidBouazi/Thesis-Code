function exists = isinstruct(s,inputs)

exists = true;

fields = fieldnames(s);
for i = 1:length(fields)
    if isfield(inputs,fields{i})
        if ~isequal(inputs.(fields{i}),s.(fields{i}))
            exists = false;
            return;
        end
    end
    
end

end