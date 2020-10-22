function saved = saveresult(result,config)

saved = false;

algorithm = result.algorithm;

%% Define file for saving
filename = [config.archivepath algorithm '.mat'];

%% Extract cell array for input fieldnames
if any(strcmp(config.algorithms,algorithm))
    inputfieldnames = config.([lower(algorithm) 'input']);
else
    error(['Save result: No algorithm ' algorithm ' available.']); 
end

%% Check if data with same input already exists
dataexists = checkdoubledata(result,inputfieldnames,config.archivepath);

%% Save result
if ~dataexists
    
    % Extract cell array for algorithm fieldname order
    algfieldnames = config.([lower(algorithm) 'order']);

    % Order fields in result struct by algorithm fieldname order
    result = orderfields(result,algfieldnames);

    % Save result in specific folder and matfile
    if isfile(filename)
        m = matfile(filename,'Writable',true);
        data = m.([algorithm 'data']);
        data = updatedata(data,result);
        m.([algorithm 'data']) = data;
    else
        if isequal(algorithm,'DMD')
            DMDdata(1,:) = result;
            varstr = 'DMDdata';
        elseif isequal(algorithm,'HAVOK')
            HAVOKdata(1,:) = result;
            varstr = 'HAVOKdata';
        else
            error(['Save result: No algorithm ' algorithm ' available.']);
        end
        save(filename,varstr,'-v7.3');
    end
    disp('Save data: data succesfully added to archive.');
    saved = true;
end

end