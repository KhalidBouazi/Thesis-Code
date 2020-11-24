function validalgdata = combineinputs(inputstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'system','dt','timesteps'};
optfunargs = {'params','x0','horizon','delays','spacing','rank'};
optargvals = {{[]},{[]},{0},{0},{[1,1]},{[]}};
inputstruct = checkandfillfunargs(inputstruct,oblgfunargs,optfunargs,optargvals);

%% ...
f = fieldnames(inputstruct);
numf = length(f);

%% Guarantee uniqueness of input elements
o = 1;
for i = 1:numf
    
    input = inputstruct.(f{i});
    
    % Check if inputstruct values are of type cell
    if ~iscell(input)
        error('Input values: Must be of type cell.');
    end
    
    % Check if inputstruct value content is empty -> remove field
    % Else check if value content is of type double 
    % -> transform with cell2mat to use unique function
    % -> transform back with mat2cell
    if isempty(input)
        inputstruct = rmfield(inputstruct,f{i});
        continue;
    elseif isa(input{1},'double')
        % TODO
        %tempin = cell2mat(inputstruct.(f{i}));
        %inputstruct.(f{i}) = mat2cell(unique(tempin,'first'),1,ones(,1));
        l(i) = length(input);
    elseif ~isa(input{1},'struct') && ~isa(input{1},'cell')
        inputstruct.(f{i}) = unique(input,'first');
        l(i) = length(input);
    else
        l(i) = length(input);
    end
    m(i) = o;
    o = o * l(i);
end

l = nonzeros(l)';
m = nonzeros(m)';

%% Construct combination matrix
f = fieldnames(inputstruct);
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
        algdata.(f{j}) = inputstruct.(f{j}){combmat(i,j)};
    end
    cellalgdata{i} = algdata;
end

%% Check validity of inputs
validalgdata = {};
for i = 1:length(cellalgdata)
    valid = checkinputvalidity(cellalgdata{i});
    if valid
        validalgdata = [validalgdata cellalgdata{i}];
    end
end

end



