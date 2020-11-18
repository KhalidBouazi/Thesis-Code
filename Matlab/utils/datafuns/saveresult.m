function saved = saveresult(result,path,config)

saved = false;
algorithm = result.algorithm;

%% Define file for saving
filename = [path algorithm '.mat'];

%% Extract cell array for input fieldnames
algnames = fieldnames(config.general.algorithms);
if any(strcmp(algnames,algorithm))
    inputfieldnames = config.(lower(algorithm)).fieldnames.input;
else
    error(['Save result: No algorithm ' algorithm ' available.']); 
end

%% Check if data with same input already exists
[dataexists,~] = checkdoubledata(result,inputfieldnames,path);

%% Save result
if ~dataexists
    
    % Extract cell array for algorithm fieldname order
    algfieldnames = config.(lower(algorithm)).fieldnames.order;
    
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
        elseif isequal(algorithm,'DMDc')
            DMDcdata(1,:) = result;
            varstr = 'DMDcdata';
        elseif isequal(algorithm,'HAVOK')
            HAVOKdata(1,:) = result;
            varstr = 'HAVOKdata';
        elseif isequal(algorithm,'HDMD')
            HDMDdata(1,:) = result;
            varstr = 'HDMDdata';
        elseif isequal(algorithm,'CONVCOORD')
            CONVCOORDdata(1,:) = result;
            varstr = 'CONVCOORDdata';
        else
            error(['Save result: No algorithm ' algorithm ' available.']);
        end
    end
    
    save(filename,varstr,'-v7.3');
    saved = true;
    disp('Save data: data succesfully added to archive.');
    
elseif result.note ~= "" || result.favorite == 1

    update = false;
    m = matfile(filename,'Writable',true);
    data = m.([algorithm 'data']);
    
    if result.note ~= "" && ~strcmp(result.note,data(idx).note)
        % Append note to existing note
        data(idx).note = [data(idx).note newline result.note];
        update = true;
    end

    if result.favorite ~= data(idx).favorite && result.favorite == 1
        % Update favorite
        data(idx).favorite = 1;
        update = true;
    end

    % Update data in archive
    if update
        m.([algorithm 'data']) = data;
        saved = true;
        disp('Save data: data succesfully updated.');
    else
        disp('Double data: data already exists. Data has not been added to archive.');
    end

else
    disp('Double data: data already exists. Data has not been added to archive.');
end

end