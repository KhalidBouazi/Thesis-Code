function result = mergestructs(structcellarray)
         
%% Commbine structs from structcellarray to result struct
for i = 1:length(structcellarray)
    f = fieldnames(structcellarray{i});
    for j = 1:length(f)
        result.(f{j}) = structcellarray{i}.(f{j});
    end
end

end