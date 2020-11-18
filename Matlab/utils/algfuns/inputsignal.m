function [input,U,u] = inputsignal(input,tspan,Nu)

u = {};
U = [];
for i = 1:Nu
    if i <= length(input)
        inputi = input{i};
        switch inputi.type
            case 'none'
                u = [u, {@(t) 0}];
                U = [U; zeros(1,length(tspan))];
            case 'sine'
    %           u = input.amp*sin(2*pi*input.freq*tspan - input.phi);
                u = [u, {@(t) sin(t)}];
                U = [U; sin(tspan)];
            case 'constant'
                u = input.value;
            otherwise
                error(['Input signal: No input signal `' inputi.type '` implemented yet.']); 
        end
    else
        input{i}.type = 'none';
        u = [u, {@(t) 0}];
        U = [U; zeros(1,length(tspan))];
    end
end
    
end