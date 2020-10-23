function [saved,printed] = printresult(result,checkedplots,config)

printed = false;

%% Choose directory to place results in
path = uigetdir(config.plotpath);

%% Check if directory exists and create folder in it, then save checked plots in folder
if ~isequal(path,0)
    
    % Create foldername and path
    foldername = foldernameconvention(result,config);
    folderpath = [path '\' foldername];
    
    % Delete tikz if folder exists
    if exist(folderpath,'dir')
        deletetikzinfolder(folderpath)
    end
    
    % Create folder in directory
    [status, msg, msgID] = mkdir(folderpath);
    
    % Check if folder created
    if status == 1
        
        % Save every plot, that was checked in the figure
        for i = 1:length(checkedplots)
            checkedplot = checkedplots{i};
            if isfield(config.plotnames,checkedplot)
                
                % Define filename
                filename = checkedplot;

                % Switch through plotnames
                switch checkedplot
                    case 'phase'
                        x = result.X(1,:);
                        y = result.X(2,:);
                        z = result.X(3,:);
                        pgfplot3(x,y,z,filename,folderpath);
                    case 'disceig'
                        d = result.d;
                        pgfdisceigplot_(real(d),imag(d),filename,folderpath);
                    case 'sing'
                        s = result.s;
                        pgfsingplot_(1:length(s),s,filename,folderpath);
                    otherwise
                        error('...');
                end
                
            end
        end
        
        % Save data, that generated those plots
        saved = saveresult(result,config,folderpath);
                
        printed = true;
    else
        error('...');
    end
end

end