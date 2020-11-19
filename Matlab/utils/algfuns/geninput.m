function [input,U,u_fun] = geninput(input,tspan,Nu)

dt = tspan(2) - tspan(1);
u_fun = cell(Nu,1);
U = zeros(Nu,length(tspan));
for i = 1:Nu
    if i <= length(input)
        inputi = input{i};
        switch inputi.type
            case 'none'
                u = zeros(1,length(tspan));
            case 'const'
                u = inputi.value;
            case 'sine'
                u = inputi.amp*sin(2*pi*inputi.freq*tspan + inputi.phi);
            case 'chirp'
                u = inputi.amp*chirp(tspan,inputi.freqa,tspan(end),inputi.freqb,'linear',-90);
            case 'prbs'
                u = randi([0 1], 1, length(tspan));
            otherwise
                error(['Input signal: No input signal `' inputi.type '` implemented yet.']); 
        end
    else
        input{i}.type = 'none';
        u = zeros(1,length(tspan));
    end
    
    u_fun{i} = @(t) u(round(1 + t/dt));
    U(i,:) = u;
end
    
end