function matriximage(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'A'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Start plotting
imagesc(result.A);
axis off;
colorbar;

end