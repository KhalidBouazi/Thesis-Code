function validalgdata = combineinputs(inputstruct,config)

%% Check obligatory and optional function arguments
oblgfunargs = {'system','dt','timesteps'};
optfunargs = {'params','x0','horizon','delays','spacing','rank','observables','kernel'};
optargvals = {{[]},{[]},{0},{1},{[1,1]},{[]},{{'identity'}},{{'identity'}}};
inputstruct = checkandfillfunargs(inputstruct,oblgfunargs,optfunargs,optargvals);

%% Combine inputs
cellalgdata = combinedata(inputstruct);
validalgdata = cellalgdata;
%% Check validity of inputs
% validalgdata = {};
% for i = 1:length(cellalgdata)
%     [valid,cellalgdata{i}] = checkinputvalidity(cellalgdata{i},config);
%     if valid
%         validalgdata = [validalgdata cellalgdata{i}];
%     end
% end

end



