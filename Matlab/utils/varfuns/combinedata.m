function datacell = combinedata(datastruct)

%% ...
f = fieldnames(datastruct);
numf = length(f);

%% Guarantee uniqueness of input elements
o = 1;
for i = 1:numf
    
    data = datastruct.(f{i});
    
    % Check if datastruct values are of type cell
    if ~iscell(data)
        error('Input values: Must be of type cell.');
    end
    
    % Check if datastruct value content is empty -> remove field
    % Else check if value content is of type double 
    % -> transform with cell2mat to use unique function
    % -> transform back with mat2cell
    if isempty(data)
        datastruct = rmfield(datastruct,f{i});
        continue;
    elseif isa(data{1},'double')
        % TODO
        %tempin = cell2mat(datastruct.(f{i}));
        %datastruct.(f{i}) = mat2cell(unique(tempin,'first'),1,ones(,1));
        l(i) = length(data);
    elseif ~isa(data{1},'struct') && ~isa(data{1},'cell')
        datastruct.(f{i}) = unique(data,'first');
        l(i) = length(data);
    else
        l(i) = length(data);
    end
    m(i) = o;
    o = o * l(i);
end

l = nonzeros(l)';
m = nonzeros(m)';

%% Construct combination matrix
f = fieldnames(datastruct);
numf = length(f);
combmat = zeros(o,numf);
for i = 1:numf
    col = [];
    for k = 1:l(i)
        col = [col;ones(o/(m(i)*l(i)),1)*k];
    end
    combmat(:,i) = repmat(col,m(i),1);
end

%% Construct input combinations
for i = 1:size(combmat,1)
    data = struct();
    for j = 1:size(combmat,2)
        data.(f{j}) = datastruct.(f{j}){combmat(i,j)};
    end
    datacell{i} = data;
end

end