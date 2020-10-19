function pgf_createFolders(folder, filename)

% Überprüfen, ob die Ordner "TikZdata" und "filename" bereits existieren
if ~exist(strcat(folder,'TikZdata'),'dir')
    mkdir(strcat(folder,'TikZdata')); 
end
if ~exist(strcat(folder,'TikZdata\',filename),'dir')
    mkdir(strcat(folder,'TikZdata\',filename));
end

end

