function algdata = observe(algdata)

%% Extract dictionary type
if isfield(algdata,'observables')
    if ~isempty(algdata.observables)
        obstype = algdata.observables{1};
        if ~strcmp(obstype,'identity')
            obsparam = algdata.observables{2};
        end
    else
        algdata.observables = {'identity'};
        return;
    end
else
    algdata.observables = {'identity'};
    return;
end

%% ...
dispstep('obs');
timer = tic;

%% Run dictionary on data
switch obstype
    case 'identity'
        return;
    case 'monomial'
        PsiY = [];
        for i = 1:obsparam
            PsiY = [PsiY; algdata.Y.^i];
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