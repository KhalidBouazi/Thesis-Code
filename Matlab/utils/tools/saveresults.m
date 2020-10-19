function saveresults(results)

algorithm = char(results.algorithm);

%% Open dialog for rating and note
output = savedialog(algorithm);

%% Define file for saving
filename = ['C:\Users\bouaz\Desktop\Thesis-Tex\content\2_Ergebnisse\Daten\' algorithm '.mat'];

%% Save results in specific folder and matfile
if strcmp(output.confirm,'yes')
    results.favorite = output.favorite;
    results.note = output.note;
    
    if isfile(filename)
        m = matfile(filename,'Writable',true);
        m.([algorithm 'data'])(end+1,:) = results;
    else
        if strcmp(algorithm,"DMD")
            DMDdata(1,:) = results;
            varstr = 'DMDdata';
        elseif strcmp(algorithm,"HAVOK")
            HAVOKdata(1,:) = results;
            varstr = 'HAVOKdata';
        else
            error(['Save results: No algorithm ' algorithm ' available.']);
        end
        save(filename,varstr,'-v7.3');
    end
end

end