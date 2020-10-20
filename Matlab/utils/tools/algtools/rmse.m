function algstruct =  rmse(algstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','Y_'};
optfunargs = {};
optargvals = {};
algstruct = checkandfillfunargs(algstruct,oblgfunargs,optfunargs,optargvals);

%% Run for every algorithm combination
for i = 1:length(algstruct)

    algstruct(i).rmseY_ = sqrt(mean((algstruct(i).Y - algstruct(i).Y_).^2,2));
    
end

end