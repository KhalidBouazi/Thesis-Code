function pgf_checkLinenames(linenames)

%% Überprüfen, ob in Linenames verbotene Zeichen enthalten oder Namen doppelt sind
for i=1:length(linenames)
    if regexpi(linenames{i},'[\%]')
            error('linenames must not contain any   "\", or "%"');
    end
    if mod(length(findstr(linenames{i},'$')),2);  % wenn '$' nicht paarweise auftaucht
            error('"$" must be used in pairs');
    end
    for k=i+1:length(linenames)
        if strcmp(linenames{i},linenames{k})
            error('Dateinamen doppelt!!!');
        end
    end
end

end


