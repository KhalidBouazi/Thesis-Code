function dispstep(type,arg)

switch type
    case 'sim'
        disp(' _____________________________________');
        disp(' ');
        disp(' = SIMULATE SYSTEMS');
        disp(' ');
    case 'endsim'
        disp(' _____________________________________');
    case 'startalg'
        disp(' _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _');
        disp(' ');
        disp(['           START ALGORITHM ' num2str(arg)]);
        disp(' ');
    case 'obs'
        disp(' = OBSERVE STATES...');
        disp(' ');    
    case 'alg'
        disp(' = RUN ALGORITHM...');
        disp(' ');
    case 'time'
        disp([' :::: Time elapsed: ' num2str(arg) 's ']);
    case 'endalg'
        disp(' ');
        disp(['           END OF ALGORITHM ' num2str(arg)]);
        disp(' _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _');
    case 'plot'
        disp(' _____________________________________');
        disp(' ');
        disp(' = PLOT RESULTS');
        disp(' _____________________________________');
    otherwise
        error('...');
        
end





end