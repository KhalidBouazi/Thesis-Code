function algdata = observe(algdata)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y'};
optfunargs = {'observables'};
optargvals = {[]};
algdata = checkandfillfunargs(algdata,oblgfunargs,optfunargs,optargvals);

%% Extract dictionary type
if ~isempty(algdata.observables) && ~strcmp(algdata.observables{1},'identity')
    obstype = algdata.observables{1};
    obsparam = algdata.observables{2};
elseif isempty(algdata.observables)
    algdata.observables = {'identity'};
    return;
else
    return; 
end

%% Start timer
dispstep('obs');
timer = tic;

%% Run dictionary on data
switch obstype
    case 'monomial'
        PsiY = [];
        for i = 1:length(obsparam)
            PsiY = [PsiY; algdata.Y.^(obsparam(i))];
        end
    case 'rbf'
        PsiY = [];
        rbf = @(y,yi,sigma) exp(-((y-yi).^2/sigma^2));
        for i = 1:100:size(algdata.Y,2)
            PsiY = [PsiY; rbf(algdata.Y,algdata.Y(:,i),obsparam)];
        end
    otherwise
        error(['Observables: no observable type ' obstype ' available.']);
end

%% Save PsiY in Y (temporary)
algdata.Y = PsiY;

%% Stop timer
timeelapsed = toc(timer);
dispstep('time',timeelapsed);

end