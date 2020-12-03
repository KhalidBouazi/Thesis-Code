function rmsecompplot(results)

%% Extract all inputs
fields = {'system','params','x0','dt','timesteps','horizon','input','drank','spacing','measured','observables'};
inputstruct = struct();
for j = 1:length(fields)
    for i = 1:length(results)
        if isfield(results{i},fields{j})
            if ~isfield(inputstruct,fields{j})
                inputstruct.(fields{j}) = {results{i}.(fields{j})};
            else
                c = inputstruct.(fields{j});
                if ~isincell(c,results{i}.(fields{j}))
                    inputstruct.(fields{j}){end+1} = results{i}.(fields{j});
                end
            end
        end
    end
end

%% Combine inputs
combinations = combinedata(inputstruct);

%% Construct combinations with delays, rmse and rank
m = length(combinations);
data = cell(m,1);
for i = 1:m
    data{i} = combinations{i};
    for j = 1:length(results)
        if isinstruct(results{j},combinations{i})
            if isfield(data{i},'delays')
                data{i}.delays(end+1) = results{j}.delays; 
                data{i}.RMSEYp(:,end+1) = results{j}.RMSEYp; 
                data{i}.rank(end+1) = results{j}.rank; 
            else
                data{i}.delays = results{j}.delays; 
                data{i}.RMSEYp = results{j}.RMSEYp; 
                data{i}.rank = results{j}.rank; 
            end
        end
    end
    [data{i}.delays,idx] = sort(data{i}.delays);
    data{i}.RMSEYp = data{i}.RMSEYp(:,idx);
    data{i}.rank = data{i}.rank(idx);
end

%% Plot config
RMSEMarker = 'o';
RankMarker = 'd';
LineStyle = '--';
TitleFontSize = 14;

%% Start plotting
for i = 1:length(data)
    figure;
    m = size(data{i}.RMSEYp,1);
    for j = 1:m
        subplot(m,1,j);
        title(sprintf('$y_%d$',j),'FontWeight','Normal','FontSize',TitleFontSize);
        yyaxis left;
        semilogy(data{i}.delays,data{i}.RMSEYp(j,:),'Marker',RMSEMarker,'LineStyle',LineStyle);
        yyaxis right;
        plot(data{i}.delays,data{i}.rank,'Marker',RankMarker,'LineStyle',LineStyle);
        yyaxis right;
        ylabel('SVD Rang'); 
        ylim([0 floor(max(data{i}.rank)*1.3)]);
        yyaxis left;
        ylabel('$\mathrm{RMSE_{pred}}$');
        xlabel('Delays');
        if max(data{i}.RMSEYp(j,:)) < 1
            maxylimdelay = 1;
        else
            maxylimdelay = max(data{i}.RMSEYp(j,:))*3;
        end
        ylim([0 maxylimdelay]);
    end
end

end