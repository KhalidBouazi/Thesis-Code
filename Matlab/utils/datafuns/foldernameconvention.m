function foldername = foldernameconvention(result,config)

algorithm = result.algorithm;
folderacronyms = fieldnames(config.general.folderacr);
algfieldnames = config.(lower(algorithm)).fieldnames.order;
foldername = '';

%% Create foldername according to foldername convention
for i = 1:length(folderacronyms)
    folderacr = folderacronyms{i};
    
    % Check if folder acronym exists in result fieldnames
    if isfield(result,folderacr)
        value = result.(folderacr);
        valuestr = '';
    
        % Create value string for folder acronym
        if isequal(folderacr,'system')
            valuestr = config.general.systems.(value).acr;
        elseif isa(value,'double')
            [value,expcnt] = comma2exp(value);
            valuestr = expdoublearray2char(value,expcnt);
        elseif isa(value,'char')
            valuestr = value;
        end
        
        if i ~= length(folderacronyms)
            valuestr = [valuestr '_'];
        else
            valuestr = [valuestr '\'];
        end
        
        % Concatenate foldername
        foldername = [foldername config.general.folderacr.(folderacr) valuestr];
    end 
end

end
