function choosefile(startingfolder,fig,table,label)

%% Choose file
if ~exist(startingfolder, 'dir')
    % If that folder doesn't exist, just start in the current folder.
    startingfolder = pwd;
end

defaultFileName = fullfile(startingfolder, '*.mat');
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
data = struct2table(storedStruct);
columnname = {'checkbox','algorithm','system','dt','timesteps','params','x0','rank','delays','spacing','measured','note','favorite'};
data = data(:,columnname(2:end));
chars(1,1:size(data,1)) = {'char'};
columnformat = ['logical',chars];

data = table2cell(data);
data = cellelements2char(data);
checkboxes(1:size(data,1),1) = {false};
data = [checkboxes data];

table.Data = data;
table.RowName = 1:size(data,1);
table.ColumnName = columnname;
table.ColumnEditable = true;
table.ColumnFormat = columnformat;

%% Show loaded data filename
label.Text = baseFileName;

end