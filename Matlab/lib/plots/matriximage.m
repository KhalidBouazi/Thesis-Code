function matriximage(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'A'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Start plotting
image(result.A);
colorbar;

end