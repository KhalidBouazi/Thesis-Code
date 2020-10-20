function algstruct = statemeas(algstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'X'};
optfunargs = {'measured'};
optargvals = {[]};
algstruct = checkandfillfunargs(algstruct,oblgfunargs,optfunargs,optargvals);

%% Run for every algorithm combination
for i = 1:length(algstruct)
    
    % Fill field measured with default if empty
    if isempty(algstruct(i).measured)
        algstruct(i).measured = 1:size(algstruct(i).X,1);
    end
        
    % Extract state measurement
    Y = algstruct(i).X(algstruct(i).measured,:);

    % Save in algstruct(i)
    algstruct(i).Y = Y;
    
end

end