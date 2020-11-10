function checkoblfunargs(algstruct,oblgfunargs)

if ~isempty(oblgfunargs) && ~all(isfield(algstruct,oblgfunargs))
    argstr = '';
    for j = 1:length(oblgfunargs)
        if j < length(oblgfunargs)
            argstr = [argstr oblgfunargs{j} ', '];
        else
            argstr = [argstr oblgfunargs{j}];
        end
    end
    error(['Struct field: Obligatory function arguments are {' argstr '}.']);
end

end