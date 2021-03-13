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
        PsiY = [Y; Y.^2 + Y.^3];
    case 'duffing_x1'
        PsiY = [Y(1,:); Y(1,:).^2/2 - Y(1,:).^4/4];
    case 'duffing_x2'
        PsiY = [Y(1,:); Y(1,:).^2];
    case 'duffing_x'
        PsiY = [Y; Y(2,:).^2 - Y(1,:).^2/2 + Y(1,:).^4/4];        
    otherwise
        error(['Observables: no observable type ' obstype ' available.']);
end

end