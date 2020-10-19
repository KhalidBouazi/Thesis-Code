function [arguments, filename, filext, folder] = pgf_separation(input)

%% folder und filename extrahieren
if isdir(input{end})
    folder = input{end};
    if ~strcmp(folder(end),'\')
        folder = strcat(folder,'\');
    end
else
    error('folder does not exist');
end

if ischar(input{end-1})
    filename = input{end-1};
    index = strfind(filename,'.');
    if isempty(index)
        filext = '.tikz';
    else
        filext   = filename(index:end);
        filename = filename(1:index-1);
    end

    % auf ungültige Zeichen überprüfen
    if regexpi(filename,'[äöüß\/:*?"<>|%]')
        error('filename must not contain any   ä ö ü ß \ / : * ? " < > | %');
    end
else
    error('invalid filename');
end

%% Arguments
for i=1:length(input)-2
    arguments{i} = input{i};
end


end