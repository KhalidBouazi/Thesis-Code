function ax = createmainplotui(tg,algdata,algnr,algplots,config)

tab = uitab(tg,'Title',[algdata.algorithm ' ' num2str(algnr)]);

%% Create 4 panels
plotpan = uipanel(tab,'Title','Plots','FontSize',12,...
    'BackgroundColor','white','Position',[0 0.2 0.7 0.8]);
pngpan = uipanel(tab,'Title','Png generieren','FontSize',12,...
    'BackgroundColor','white','Position',[0 0 0.35 0.2]);
tikzpan = uipanel(tab,'Title','Tikz generieren','FontSize',12,...
    'BackgroundColor','white','Position',[0.35 0 0.35 0.2]);
datapan = uipanel(tab,'Title','Daten','FontSize',12,...
    'BackgroundColor','white','Position',[0.7 0.2 0.3 0.8]);
savepan = uipanel(tab,'Title','Speichern','FontSize',12,...
    'BackgroundColor','white','Position',[0.7 0 0.3 0.2]);

%% For plotting
ax = axes('Parent',plotpan);

%% For png saving
for i = 1:length(algplots)
    cbx = 0.01 + floor((i-1)/4)*0.3;
    cby = 0.7 - mod((i-1),4)*0.2;
    cbstr = config.general.plots.(algplots{i}).name;
    plotcheckbox(i) = uicontrol('Parent',pngpan,'Style','checkbox','String',cbstr,...
        'FontSize',10,'BackgroundColor','white','Units','Normalized',...
        'Position',[cbx cby 0.3 0.15]);
end
plotcheckbox(end+1) = uicontrol('Parent',pngpan,'Style','checkbox','String','Alle auswählen',...
        'FontSize',10,'Units','Normalized','BackgroundColor','white',...
        'Position',[0.64 0.75 0.35 0.2]);
printtext = uicontrol('Parent',pngpan,'Style','text','BackgroundColor','white',...
    'FontSize',10,'Units','Normalized','Position',[0.64 0.1 0.35 0.4]);
pngprintbtn = uicontrol('Parent',pngpan,'Style','pushbutton','String','Als png speichern',...
    'FontSize',11,'Units','Normalized','Position',[0.64 0.5 0.35 0.2],...
    'Callback',{@onprintresult,plotcheckbox,printtext,'png'});

%% For tikz saving
for i = 1:length(algplots)
    cbx = 0.01 + floor((i-1)/4)*0.3;
    cby = 0.7 - mod((i-1),4)*0.2;
    cbstr = config.general.plots.(algplots{i}).name;
    plotcheckbox(i) = uicontrol('Parent',tikzpan,'Style','checkbox','String',cbstr,...
        'FontSize',10,'BackgroundColor','white','Units','Normalized',...
        'Position',[cbx cby 0.3 0.15]);
end
plotcheckbox(end+1) = uicontrol('Parent',tikzpan,'Style','checkbox','String','Alle auswählen',...
        'FontSize',10,'Units','Normalized','BackgroundColor','white',...
        'Position',[0.64 0.75 0.35 0.2]);
printtext = uicontrol('Parent',tikzpan,'Style','text','BackgroundColor','white',...
    'FontSize',10,'Units','Normalized','Position',[0.64 0.1 0.35 0.4]);
tikzprintbtn = uicontrol('Parent',tikzpan,'Style','pushbutton','String','Als tikz speichern',...
    'FontSize',11,'Units','Normalized','Position',[0.64 0.5 0.35 0.2],...
    'Callback',{@onprintresult,plotcheckbox,printtext,'tikz'});

%% For data
algorithm = algdata.algorithm;
inputfieldnames = config.(lower(algorithm)).fieldnames.input;
data = structbyfields(algdata,inputfieldnames);
data = structelements2char(data);

for i = 1:length(inputfieldnames)
    y = 0.95 - i*0.05;
    inputfieldname = inputfieldnames{i};
    dataname = uicontrol('Parent',datapan,'Style','text','Units','Normalized',...
        'Position',[0.05 y 0.3 0.04],'String',[inputfieldname ':'],... 
        'FontSize',12,'BackgroundColor','white','HorizontalAlignment','left');
    datavalue = uicontrol('Parent',datapan,'Style','text','Units','Normalized',...
        'Position',[0.4 y 0.6 0.04],'String',data.(inputfieldname),... 
        'FontSize',12,'BackgroundColor','white','HorizontalAlignment','left');
end

%% If new algorithm add note, favorite and data saving option
if isequal(config.general.usage,'new')
    notetext = uicontrol('Parent',savepan,'Style','text','Units','Normalized',...
        'Position',[0.2 0.8 0.2 0.2],'String','Notiz',...
        'FontSize',11,'BackgroundColor','white');
    notearea = uicontrol('Parent',savepan,'Style','edit','Max',3,'Min',1,...
        'FontSize',11,'Units','Normalized','Position',[0.01 0.1 0.62 0.7]);
    favoritecheckbox = uicontrol('Parent',savepan,'Style','checkbox','String','Favorit',...
        'FontSize',11,'Units','Normalized','BackgroundColor','white','Position',[0.64 0.6 0.35 0.2]);
    savetext = uicontrol('Parent',savepan,'Style','text',...
        'Units','Normalized','FontSize',10,'BackgroundColor','white','Position',[0.64 0.1 0.35 0.2]);
    savebtn = uicontrol('Parent',savepan,'Style','pushbutton','String','Daten speichern',...
        'Units','Normalized','FontSize',11,'Position',[0.64 0.35 0.35 0.2],...
        'Callback',{@onsaveresult,notearea,favoritecheckbox,savetext});
end

%% Function for saving result
    function onsaveresult(source,eventdata,textarea,checkbox,text)

        % Reset background color of text
        text.BackgroundColor = 'white';

        % Create metadata
        note = textarea.String;
        favorite = checkbox.Value;
        date = datetime('now','TimeZone','local','Format','d-MMM-y');
        time = datetime('now','TimeZone','local','Format','HH:mm:ss');
        algdata.note = note;
        algdata.favorite = favorite;
        algdata.date = date;
        algdata.time = time;

        % Try to save result
        saved = saveresult(algdata,config.general.archivepath,config);
        
        % Message for status
        if saved
            text.String = 'Gespeichert';
            text.BackgroundColor = [0.4660, 0.6740, 0.1880];
        else
            text.String = 'Schon gespeichert.';
            text.BackgroundColor = [0.8500, 0.3250, 0.0980];
        end

    end

%% Function for printing result
    function onprintresult(source,eventdata,checkboxs,text,type)
        checked = {};
        printed = false;
        
        % Extract checked plots
        if checkboxs(end).Value == 1 % alle Plots wurden ausgewählt
            checked = algplots;
        else
            for k = 1:length(checkboxs) - 1 % bestimmte Plots ausgewählt
                if checkboxs(k).Value == 1
                    checked = [checked, {algplots{k}}];
                end
            end
        end
        
        % Save extracted plots if not empty choice
        if isempty(checked) % Keine Plots gewählt
            text.String = 'Keine Plots ausgewählt.';
            text.BackgroundColor = [0.8500, 0.3250, 0.0980];
        else
            % Create metadata
            note = '';
            favorite = 0;
            date = datetime('now','TimeZone','local','Format','d-MMM-y');
            time = datetime('now','TimeZone','local','Format','HH:mm:ss');
            algdata.note = note;
            algdata.favorite = favorite;
            algdata.date = date;
            algdata.time = time;
            [saved,printed] = printresult(algdata,checked,type,config);
        end
        
        % Message for status
        if printed && ~saved
            text.String = 'Plots wurden generiert. Daten schon vorhanden.';
            text.BackgroundColor = [0.4660, 0.6740, 0.1880];
        elseif printed && saved
            text.String = 'Plots wurden generiert. Daten wurden gespeichert.';
            text.BackgroundColor = [0.4660, 0.6740, 0.1880];
        elseif ~isempty(checked)
            text.String = 'Plots wurden nicht generiert.';
            text.BackgroundColor = [0.8500, 0.3250, 0.0980];
        end
    end

end