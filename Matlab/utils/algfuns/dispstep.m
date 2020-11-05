function dispstep(type,arg)

switch type
    case 'algnum'
        disp('                             _____________________________________');
        disp('                            |                                     |');
        disp(['                            |          START ALGORITHM ' num2str(arg) '          |']);
        disp('                            |                                     |');
    case 'sim'
        disp('                            |          I.SIMULATE SYSTEM          |');
        disp('                            |                                     |');
    case 'alg'
        disp('                            |          II.RUN ALGORITHM           |');
        disp('                            |                                     |');
    case 'eval'
        disp('                            |       III.EVALUATE ALGORITHM        |');
        disp('                            |                                     |');
    case 'time'
        if floor(arg)/10 >= 1
            timeelapsed = num2str(round(arg*10)/10);
        else
            timeelapsed = num2str(round(arg*10)/10);
        end
        disp(['                            |         Time elapsed: ' timeelapsed 's         |']);
        disp('                            |_____________________________________|');
    case 'plot'
        disp('                             _____________________________________');
        disp('                            |                                     |');
        disp('                            |           IV.PLOT RESULTS           |');
        disp('                            |_____________________________________|');
    otherwise
        error('...');
        
end





end