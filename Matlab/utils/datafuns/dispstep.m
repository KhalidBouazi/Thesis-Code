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
        disp(['         START ALGORITHM ' num2str(arg(1)) '/' num2str(arg(2))]); 
    case 'alg'
        disp(' ');
        disp(' = RUN ALGORITHM...');
        disp(' ');
    case 'time'
        disp([' :::: Time elapsed: ' num2str(arg) 's ']);
    case 'endalg'
        disp(' ');
        disp(['          END ALGORITHM ' num2str(arg(1)) '/' num2str(arg(2))]);
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