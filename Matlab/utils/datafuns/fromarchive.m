function [extracteddata,idx] = fromarchive(input,archivepath)

extracteddata = [];
idx = 0;

%% Check if field 'algorithm' exists in input
if isfield(input,'algorithm')
    algorithm = char(input.algorithm);
end

%% Define file for reading
filename = [archivepath algorithm '.mat'];

%% Check if file with specified algorithm type exists
if isfile(filename)
    m = matfile(filename);
    data = m.([algorithm 'data']);

    % Extract archive data for specified input 
    f = fieldnames(input);
    m = size(data,1);
    actpos = zeros(m,1);
    pos = ones(m,1);
    for i = 1:length(f)
        if isfield(data,f{i})
            for j = 1:m
                actpos(j,:) = isequal(data(j,1).(f{i}),input.(f{i}));
            end
        else
            error(['Data field: Field ' f{i} ' does not exist in data']);
        end
        pos = pos & actpos;
    end
    extracteddata = data(pos);
    idx = find(pos);
end
       
end
    
    
    