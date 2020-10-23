function foldername = foldernameconvention(result,config)

algorithm = result.algorithm;
inputfieldnames = config.([lower(algorithm) 'input']);
foldername = '';

%% Create foldername according to foldername convention
for i = 1:length(inputfieldnames)
    inputfieldname = inputfieldnames{i};
    
    % Check if input fieldname exists in folder acronyms
    if isfield(config.folderacr,inputfieldname)
        inputacr = config.folderacr.(inputfieldname);
        value = result.(inputfieldname);
        valuestr = '';
    
        % Create value string for specific input fieldname
        if isequal(inputfieldname,'system')
            valuestr = config.systemacr.(value);
        elseif isa(value,'double')
            [value,expcnt] = comma2exp(value);
            valuestr = expdoublearray2char(value,expcnt);
        elseif isa(value,'char')
            valuestr = value;
        end
        
        if i ~= length(inputfieldnames)
            valuestr = [valuestr '_'];
        else
            valuestr = [valuestr '\'];
        end
        
        % Concatenate foldername
        foldername = [foldername inputacr valuestr];
        
    end 
end

end
