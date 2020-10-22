function checkoblfunargs(algstruct,oblgfunargs)

for i = 1:length(algstruct)
    if ~all(isfield(algstruct(i),oblgfunargs))
        argstr = '';
        for j = 1:length(oblgfunargs)
            argstr = [argstr oblgfunargs{j}];
        end
        error(['Struct field: Obligatory function arguments are {' argstr '}.']);
    end
end

end