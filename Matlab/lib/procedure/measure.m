function algdata = measure(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'X'};
optfunargs = {'measured'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Fill field measured with default if empty
if isempty(algdata.measured)
    algdata.measured = (1:size(algdata.X,1))';
end

%% Extract state measurement
algdata.Y = algdata.X(algdata.measured,:);

end