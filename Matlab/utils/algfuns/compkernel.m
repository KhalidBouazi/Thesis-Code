function Psi = compkernel(kerneldata,Hy,Hyp)

%% Extract arguments
kerneltype = kerneldata{1};

if nargin == 2
    Hyp = Hy;
end

%% Do kernel computation
switch kerneltype
    case 'identity'
        Psi = Hyp'*Hy;
    case 'polynomial'
        exponent = kerneldata{2};
        Psi = (1 + Hyp'*Hy).^exponent;
    case 'rbf'
        rbf = @(y,yi,sigma) exp(-((y-yi).^2/sigma^2));
        
    otherwise
        error(['Kernel: no kernel type ' kerneltype ' available.']);
end

end