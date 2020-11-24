function dispstep(type,arg)

switch type
    case 'algnum'
        disp(' _____________________________________');
        disp(' ');
        disp(['           START ALGORITHM ' num2str(arg)]);
        disp(' ');
    case 'sim'
        disp(' = SIMULATE SYSTEM...');
        disp(' ');
    case 'obs'
        disp(' = OBSERVE STATES...');
        disp(' ');    
    case 'alg'
        disp(' = RUN ALGORITHM...');
        disp(' ');
    case 'time'
        disp([' :::: Time elapsed: ' num2str(arg) 's ']);
        disp(' ');
    case 'end'
        disp(['           END OF ALGORITHM ' num2str(arg)]);
        disp(' _____________________________________');
    case 'plot'
        disp(' _____________________________________');
        disp(' ');
        disp(' = PLOT RESULTS');
        disp(' _____________________________________');
    otherwise
        error('...');
        
end





end