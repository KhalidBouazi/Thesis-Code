function validalgdata = combineinputs(inputstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'system','dt','timesteps'};
optfunargs = {'params','x0','horizon','delays','spacing','rank'};
optargvals = {{[]},{[]},{0},{0},{[1,1]},{[]}};
inputstruct = checkandfillfunargs(inputstruct,oblgfunargs,optfunargs,optargvals);

%% Combine inputs
cellalgdata = combinedata(inputstruct);

%% Check validity of inputs
validalgdata = {};
for i = 1:length(cellalgdata)
    valid = checkinputvalidity(cellalgdata{i});
    if valid
        validalgdata = [validalgdata cellalgdata{i}];
    end
end

end



