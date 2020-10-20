function algstruct = filloptfunargs(algstruct,optfunargs,optargvals)

%% Extract optional arguments
for i = 1:length(algstruct)
    for j = 1:length(optfunargs)
        if ~isfield(algstruct(i),optfunargs{j}) || ...
           (isfield(algstruct(i),optfunargs{j}) && isempty(algstruct(i).(optfunargs{j})))
       
            algstruct(i).(optfunargs{j}) = optargvals{j};
            
        end
    end
end

end