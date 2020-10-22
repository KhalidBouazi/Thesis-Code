function cellalgdata = combineinputs(input)

f = fieldnames(input);

%% Guarantee uniqueness of input elements
o = 1;
for i = 1:length(f)
    % Check if input values are of type cell
    if ~iscell(input.(f{i}))
        error('Input values: Must be of type cell.');
    end
    
    % Check if input value content is empty -> remove field
    % Else check if value content is of type double 
    % -> transform with cell2mat to use unique function
    % -> transform back with mat2cell
    if isempty(input.(f{i}))
        input = rmfield(input,f{i});
        continue;
    elseif isa(input.(f{i}){1},'double')
        % TODO
        %tempin = cell2mat(input.(f{i}));
        %input.(f{i}) = mat2cell(unique(tempin,'first'),1,ones(,1));
        l(i) = length(input.(f{i}));%{:}
    else
        input.(f{i}) = unique(input.(f{i}),'first');
        l(i) = length(input.(f{i}));
    end
    m(i) = o;
    o = o * l(i);
end

%% Construct combination matrix
f = fieldnames(input);
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
    algdata = struct();
    for j = 1:size(combmat,2)
        algdata.(f{j}) = input.(f{j}){combmat(i,j)};
    end
    cellalgdata{i} = algdata;
end

end