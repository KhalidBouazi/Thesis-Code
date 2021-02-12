function [noise,N,n_fun] = gennoise(noise,tspan,Nn)

dt = tspan(2) - tspan(1);
n_fun = cell(Nn,1);
N = zeros(Nn,length(tspan));

if Nn == 0
    noise = {struct('type','none')};
    return;
end

for i = 1:Nn
    if i <= Nn %length(noise)
        noisei = noise{1}; %{i};
        switch noisei.type
            case 'none'
                n = zeros(1,length(tspan));
            case 'normd'
                n = noisei.amp*randn(1,length(tspan));
            otherwise
                error(['Noise signal: No noise signal `' noisei.type '` implemented yet.']); 
        end
    else
        noise{i}.type = 'none';
        n = zeros(1,length(tspan));
    end
    
    n_fun{i} = @(t) n(round(1 + t/dt));
    N(i,:) = n;
end
    
end