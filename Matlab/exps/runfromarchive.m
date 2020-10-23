%% First close all windows and clear workspace
close all;
if exist('fig','var')
    fig.delete;
end
clear;

%% Run simconfig to set working directory, archive path and consistent plot settings
config = simconfig();
config.usage = 'archive';

%% Create figure
fig = uifigure('Name','Vom Archiv ausführen','NumberTitle','off','Position',[400 200 700 500]);

table = uitable(fig,'Position',[30 100 640 320]);      

choosefilelbl = uilabel(fig,'Position',[200 423 450 30],'FontSize',12,...
    'Text','');

choosefilebtn = uibutton(fig,'Position',[30 430 150 30],...
    'Text','Wähle eine Matfile aus','FontSize',11,...
    'ButtonPushedFcn',@(btn,event,path)choosefile(fig,table,choosefilelbl,config));

evaldatalbl = uilabel(fig,'Position',[420 53 150 30],'FontSize',12,...
    'Text','');

evaldatabtn = uibutton(fig,'Position',[570 60 100 30],...
    'Text','Evaluiere Daten','FontSize',11,...
    'ButtonPushedFcn',@(btn,event)evalarchivedata(table,evaldatalbl,config));

                 

            





    