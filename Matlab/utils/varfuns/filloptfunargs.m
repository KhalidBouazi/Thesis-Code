function algstruct = filloptfunargs(algstruct,optfunargs,optargvals)

%% Extract optional arguments
for i = 1:length(optfunargs)
    if ~isfield(algstruct,optfunargs{i}) || ...
       (isfield(algstruct,optfunargs{i}) && isempty(algstruct.(optfunargs{i})))

        algstruct.(optfunargs{i}) = optargvals{i};

    end
end

end