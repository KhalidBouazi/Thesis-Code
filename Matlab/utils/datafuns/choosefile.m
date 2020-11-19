function choosefile(fig,table,label,config)

%% Choose file
if ~exist(config.general.archivepath, 'dir')
    % If that folder doesn't exist, just start in the current folder.
    config.general.archivepath = pwd;
end

defaultFileName = fullfile(config.general.archivepath, '*.mat');
[baseFileName, folder] = uigetfile(defaultFileName, 'Wähle eine Datei aus');

fig.Visible = 'off';
fig.Visible = 'on';

if baseFileName == 0
    % User clicked the Cancel button.
    return;
end

fullFileName = fullfile(folder, baseFileName);
baseFileNameSplit = split(baseFileName,'.');
algorithm = baseFileNameSplit{1};
file = matfile(fullFileName);
storedStruct = file.([algorithm 'data']);
assignin('base','datastruct',storedStruct);

%% Create table and fill with chosen file
algorithm = storedStruct.algorithm;
columnnames = [{'checkbox'},config.(lower(algorithm)).fieldnames.input,config.general.fieldnames.metadata];
data = structbyfields(storedStruct,columnnames(2:end));
data = structarr2cell(data);
data = cellelements2char(data);

checkboxes(1:size(data,1),1) = {false};
data = [checkboxes data];

chars(1,1:size(data,1)) = {'char'};
columnformat = ['logical',chars];

table.Data = data;
table.RowName = 1:size(data,1);
table.ColumnName = columnnames;
table.ColumnEditable = true;
table.ColumnFormat = columnformat;

%% Show loaded data filename
label.Text = baseFileName;

end