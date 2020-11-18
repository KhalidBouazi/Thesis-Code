function algdata = observe(algdata)

%% Extract dictionary type
if isfield(algdata,'observables')
    if ~isempty(algdata.observables)
        obstype = algdata.observables{1};
        obsparam = algdata.observables{2};
    else
        algdata.observables = {'idt'};
        return;
    end
else
    algdata.observables = {'idt'};
    return;
end

%% Run dictionary on data
switch obstype
    case 'idt'
        return;
    case 'mon'
        PsiY = [];
        for i = 1:obsparam
            PsiY = [PsiY; algdata.Y.^i];
        end
    case 'rbf'
        PsiY = [];
        rbf = @(y,yi,sigma) exp(-((y-yi).^2/sigma^2));
        for i = 1:size(algdata.Y,2)
            PsiY = [PsiY; rbf(algdata.Y,algdata.Y(:,i),obsparam)];
        end
    otherwise
        error(['Observables: no observable type ' obstype ' available.']);
end

%% Save PsiY in Y (temporary)
algdata.Y = PsiY;

end