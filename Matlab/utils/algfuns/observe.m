function PsiY = observe(Y,obsdata)

obstype = obsdata{1};

%% Run dictionary on data
switch obstype
    case 'identity'
        PsiY = Y;
    case 'monomial'
%         combs = expcomb(size(Y,1),obsdata{2});
%         PsiY = [];
%         for i = 1:size(Y,2)
%             PsiY(:,end+1) = prod(Y(:,i)'.^combs,2);
%         end
        PsiY = [];
        for i = obsdata{2}
            PsiY = [PsiY; Y.^i]; 
        end
    case 'rbf'
%         PsiY = [];
%         rbf = @(y,yi,sigma) exp(-((y-yi).^2/sigma^2));
%         for i = 1:100:size(Y,2)
%             PsiY = [PsiY; rbf(Y,Y(:,i),obsparam)];
%         end
    case 'examplesys'
        PsiY = [Y(1,:); Y(2,:); Y(1,:).^2];
    case 'vanderpol'
        PsiY = [Y(1,:) + Y(2,:) + (Y(1,:).^2 + Y(2,:).^2).^(1/2)];
    otherwise
        error(['Observables: no observable type ' obstype ' available.']);
end

end