function plotalg(algdata,config)

%% Plotting
fig = figure('NumberTitle', 'off', 'Name','Ergebnisse','Position',[100 100 1300 650]);
tg = uitabgroup('Parent',fig);

for i = 1:length(algdata)
    
    % Define algorithm
    algorithm = algdata{i}.algorithm;
    
    % Extract plots for algorithm
    if any(strcmp(config.algorithms,algorithm))
        plots = config.([lower(algorithm) 'plots']);
    else
        error(['Plot: No algorithm ' algorithm ' available.']); 
    end
    
    % Compute layout dimension
    width = 2;
    height = round(length(plots)/width);
  
    % Create figure layout with tabs
    tab = uitab(tg,'Title',[algorithm ' ' char(string(i))]);
    
    if isequal(config.usage,'new')
        plotpan = uipanel(tab,'Title','Plots','FontSize',12,...
            'BackgroundColor','white','Position',[0 0.2 1 0.8]);
        savepan = uipanel(tab,'Title','Speichern','FontSize',12,...
            'BackgroundColor','white','Position',[0 0 1 0.2]);
        notetext = uicontrol('Parent',savepan,'Style','text',...
            'Position',[10 80 300 20],'String','Notiz',...
            'BackgroundColor','white');
        notearea = uicontrol('Parent',savepan,'Style','edit','Max',3,'Min',1,...
            'Position',[10 10 300 70]);
        favoritecheckbox = uicontrol('Parent',savepan,'Style','checkbox','String','Favorit',...
            'BackgroundColor','white','Position',[330 65 100 15]);
        savetext = uicontrol('Parent',savepan,'Style','text',...
            'BackgroundColor','white','Position',[330 10 100 20]);
        savebtn = uicontrol('Parent',savepan,'Style','pushbutton','String','Speichern',...
            'Position',[330 35 100 20],'Callback',{@onsaveresult,notearea,favoritecheckbox,savetext,algdata{i}});
    elseif isequal(config.usage,'archive')
        plotpan = uipanel(tab,'Title','Plots','FontSize',12,...
            'BackgroundColor','white','Position',[0 0.2 1 0.9]);
        printpan = uipanel(tab,'BackgroundColor','white','Position',[0 0 1 0.1]);
        printbtn = uicontrol('Parent',printpan,'Style','pushbutton','String','Drucken',...
            'Position',[1100 10 100 20],'Callback',{@onprintresult,algdata{i}});
    else
        error('...');
    end

    axes('Parent',plotpan);
    
    % Plot algorithm data
    for j = 1:length(plots)
        ax(i,j) = subplot(height,width,j);
        plotname = plots{j};
        if isfield(config.plotfuns,plotname)
            fun = config.plotfuns.(plotname);
            fun(algdata{i});
        else
            error(['Plot: No plot ' plotname ' available.']);
        end
    end
    
end

%% Link axes
for j = 1:size(ax,2)
    linkaxes(ax(:,j),'xy');
end

%% Function for saving result
    function onsaveresult(source,eventdata,textarea,checkbox,text,algdata)

        note = textarea.String;
        favorite = checkbox.Value;
        date = datetime('now','TimeZone','local','Format','d-MMM-y');
        time = datetime('now','TimeZone','local','Format','HH:mm:ss');
        algdata.note = note;
        algdata.favorite = favorite;
        algdata.date = date;
        algdata.time = time;

        saved = saveresult(algdata,config);
        
        if saved
            text.String = 'Gespeichert';
            text.BackgroundColor = [0.4660, 0.6740, 0.1880];
        else
            text.String = 'Schon gespeichert.';
            text.BackgroundColor = [0.8500, 0.3250, 0.0980];
        end

    end

end