function algdata = polyobserv(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','observexp'};
optfunargs = {};
optargvals = {};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% 
p = (1:algdata.observexp)';
algdata.Y = algdata.Y.^p;

end