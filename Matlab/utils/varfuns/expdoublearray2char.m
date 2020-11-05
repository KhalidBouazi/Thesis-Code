function c = expdoublearray2char(value,expcnt)

valuelen = length(value);

if valuelen > 1
    c = '[';
    for i = 1:valuelen
        
        if expcnt(i) == 0
            expo = '';
        else
            expo = ['e' num2str(expcnt(i))];
        end
        
        c = [c num2str(value(i)) expo ';'];
        
    end
    c(end) = ']';
else
    if expcnt == 0
        expo = '';
    else
        expo = ['e' num2str(expcnt)];
    end
    c = [num2str(value) expo];
end

end