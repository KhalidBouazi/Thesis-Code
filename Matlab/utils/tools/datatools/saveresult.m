function saveresult(result,archivepath)

algorithm = result.algorithm;

%% Open dialog for rating and note
output = savedialog(algorithm);
    
%% Start saving procedure
if strcmp(output.confirm,'yes')
    
    % Define file for saving
    filename = [archivepath algorithm '.mat'];
    
    % Define cell array for input fieldnames
    inputfieldnames = {'algorithm','system','dt','timesteps','rank','delays','spacing'};
    
    % Check if data with same input already exists
    dataexists = checkdoubledata(result,inputfieldnames,archivepath);
    
    if ~dataexists
    
        % Define metadata
        date = datetime('now','TimeZone','local','Format','d-MMM-y');
        time = datetime('now','TimeZone','local','Format','HH:mm:ss');
        metadata = {output.note,output.favorite,date,time};

        % Define cell arrays for specific fieldname order
        datafieldnames = {'t','measured','X','Y'};
        svdfieldnames = {'H','U','s','V'};
        reconstructionfieldnames = {'Y_','rmseY_'};
        modecompfieldnames = {'Atilde','W','d','Phi','omega','b'};
        metadatafieldnames = {'note','favorite','date','time'};

        % Define fieldname composition for algorithms
        dmdfieldnames = [inputfieldnames,datafieldnames,svdfieldnames,modecompfieldnames,reconstructionfieldnames,metadatafieldnames];
        havokfieldnames = [inputfieldnames,datafieldnames,svdfieldnames,metadatafieldnames];

        % Choose specific algorithm fieldname order
        if isequal(algorithm,'DMD')
            algfieldnames = dmdfieldnames;
        elseif isequal(algorithm,'HAVOK')
            algfieldnames = havokfieldnames;
        else
            error(['Algorithm: No algorithm ' algorithm ' available.']);
        end

        % Add metadata to result struct
        for i = 1:length(metadatafieldnames)
            result.(metadatafieldnames{i}) = metadata{i};
        end

        % Complete result struct if necessary (because of uncomputed field values)
        result = completedata(result,algfieldnames);

        % Order fields in result struct by algorithm fieldnames
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
        
    end
    
end

end