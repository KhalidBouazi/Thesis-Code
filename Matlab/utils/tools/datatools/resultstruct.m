function result = resultstruct(structarray)
         
%% Commbine structs from structarray to result struct
for i = 1:length(structarray)
    f = fieldnames(structarray{i});
    for j = 1:length(f)
        result.(f{j}) = structarray{i}.(f{j});
    end
end

end