function u = sysctrl(x,args)

switch args.type
    case 'noctrl'
        u = 0;
    case 'random'
        u = 1e-3*x(1);
    otherwise
        error(['Controller: No control `' args.type '` law implemented yet.']); 
end

end