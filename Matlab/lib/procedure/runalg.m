function algdata = runalg(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'algorithm'};
optfunargs = {};
optargvals = {};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Choose and run algorithm
algorithm = algdata.algorithm;
if isequal(algorithm,'DMD')
    algdata = DMD(algdata);
elseif isequal(algorithm,'HAVOK')
    algdata = HAVOK(algdata);
else
    error(['Algorithm: No algorithm ' algorithm ' available.']);
end

end