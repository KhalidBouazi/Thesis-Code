function path = pgf_getRelPath(folder, filename)

relpath = folder;

old_folder = cd;    % alten Pfad speichern
cd(folder);         % in Bild-Pfad wechseln

%% Überprüfen, ob Bild im Hauptverzeichnis liegt
currentDir = dir;
for i=1:length(currentDir)  % Schleife über alle Elemente im aktuellen Verzeichnis
    [~, ~, ext] = fileparts(currentDir(i).name); % Dateinamenendung
    if strcmp(ext,'.tcp') % wenn tcp-Datei gefunden wird
        error('Das Bild darf nicht im gleichen Verzeichnis liegen, wie die Hauptdatei!')
    end
end

%% .tcp-Datei suchen
flag = 0;
while ~flag
    cd ../
    currentPath = cd;
    if strcmp(currentPath(2:end),':\') % wenn höchste Ebene erreicht wurde
        break;
    end
    
    currentDir = dir;
    for i=1:length(currentDir)  % Schleife über alle Elemente im aktuellen Verzeichnis
        [~, ~, ext] = fileparts(currentDir(i).name); % Dateinamenendung
        if strcmp(ext,'.tcp') % wenn tcp-Datei gefunden wird
            flag = 1;
            relpath = strcat('.',folder(length(cd)+1:end));
            break;
        end
    end
end

path = strcat(strrep(relpath,'\','/'),'TikZdata/',filename,'/');


cd(old_folder);
end

